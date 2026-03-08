import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/auth_service.dart';

/// Authentication state management provider.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // ── State ──
  AppUser? _currentUser;
  Student? _studentProfile;
  ParentModel? _parentProfile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _verificationId;
  int? _resendToken;
  AuthState _authState = AuthState.initial;

  // ── Getters ──
  AppUser? get currentUser => _currentUser;
  Student? get studentProfile => _studentProfile;
  ParentModel? get parentProfile => _parentProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthState get authState => _authState;
  bool get isAuthenticated => _currentUser != null;
  User? get firebaseUser => _authService.currentUser;

  // ── Phone Authentication ──

  /// Send OTP to phone number.
  Future<void> sendOtp(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    await _authService.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        _authState = AuthState.otpSent;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = _getAuthErrorMessage(error);
        _authState = AuthState.error;
        _setLoading(false);
      },
      onAutoVerified: (credential) async {
        await _signInWithCredential(credential);
      },
      resendToken: _resendToken,
    );
  }

  /// Verify OTP code.
  Future<void> verifyOtp(String otp) async {
    if (_verificationId == null) {
      _errorMessage = 'يرجى طلب رمز التحقق أولاً';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final userCredential = await _authService.verifyOtp(
        verificationId: _verificationId!,
        otp: otp,
      );

      await _handleAuthSuccess(userCredential);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _authState = AuthState.error;
      _setLoading(false);
    }
  }

  /// Handle successful auth - check if user profile exists.
  Future<void> _handleAuthSuccess(UserCredential userCredential) async {
    final uid = userCredential.user!.uid;
    final profile = await _authService.getUserProfile(uid);

    if (profile != null) {
      _currentUser = profile;
      await _loadRoleProfile(profile);
      _authState = AuthState.authenticated;
    } else {
      _authState = AuthState.needsRegistration;
    }
    _setLoading(false);
  }

  /// Sign in with auto-verified credential.
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await _handleAuthSuccess(userCredential);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _authState = AuthState.error;
      _setLoading(false);
    }
  }

  // ── Registration ──

  /// Complete user registration with role selection.
  Future<void> completeRegistration({
    required UserRole role,
    required String displayName,
  }) async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) {
      _errorMessage = 'يجب تسجيل الدخول أولاً';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authService.createUserProfile(
        uid: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber ?? '',
        role: role,
        displayName: displayName,
      );

      await _loadRoleProfile(_currentUser!);
      _authState = AuthState.authenticated;
      _setLoading(false);
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء إنشاء الحساب';
      _authState = AuthState.error;
      _setLoading(false);
    }
  }

  // ── Parent-Student Linking ──

  /// Link a student to the current parent using student code.
  Future<bool> linkStudent(String studentCode) async {
    if (_currentUser == null || _currentUser!.role != UserRole.parent) {
      _errorMessage = 'يجب أن تكون ولي أمر لربط طالب';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.linkStudentToParent(
        parentUserId: _currentUser!.uid,
        studentCode: studentCode,
      );

      if (success) {
        // Reload parent profile to get updated linked students
        _parentProfile =
            await _authService.getParentByUserId(_currentUser!.uid);
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'رمز الطالب غير صحيح أو غير موجود';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء ربط الطالب';
      _setLoading(false);
      return false;
    }
  }

  // ── Session Management ──

  /// Load role-specific profile data.
  Future<void> _loadRoleProfile(AppUser user) async {
    switch (user.role) {
      case UserRole.student:
        _studentProfile = await _authService.getStudentByUserId(user.uid);
        break;
      case UserRole.parent:
        _parentProfile = await _authService.getParentByUserId(user.uid);
        break;
      case UserRole.teacher:
      case UserRole.superAdmin:
        break;
    }
  }

  /// Check and restore existing session on app start.
  Future<void> checkExistingSession() async {
    _setLoading(true);

    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      final profile = await _authService.getUserProfile(firebaseUser.uid);
      if (profile != null) {
        _currentUser = profile;
        await _loadRoleProfile(profile);
        _authState = AuthState.authenticated;
      } else {
        _authState = AuthState.needsRegistration;
      }
    } else {
      _authState = AuthState.unauthenticated;
    }

    _setLoading(false);
  }

  /// Sign out.
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _studentProfile = null;
    _parentProfile = null;
    _verificationId = null;
    _resendToken = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }

  // ── Helpers ──

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Get user-friendly error messages in Arabic.
  String _getAuthErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صالح';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً. يرجى المحاولة لاحقاً';
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح';
      case 'session-expired':
        return 'انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد';
      case 'network-request-failed':
        return 'خطأ في الاتصال بالإنترنت';
      default:
        return 'حدث خطأ غير متوقع: ${error.message}';
    }
  }
}

/// Authentication states.
enum AuthState {
  initial,
  unauthenticated,
  otpSent,
  needsRegistration,
  authenticated,
  error,
}
