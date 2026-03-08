import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../utils/student_code_generator.dart';

/// Service for handling Firebase phone authentication and user management.
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Current Firebase user.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Send OTP to phone number for verification.
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken)
        onCodeSent,
    required void Function(FirebaseAuthException error) onError,
    required void Function(PhoneAuthCredential credential)
        onAutoVerified,
    int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      verificationCompleted: onAutoVerified,
      verificationFailed: onError,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Verify OTP and sign in.
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return await _auth.signInWithCredential(credential);
  }

  /// Check if user profile exists in Firestore.
  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  /// Create a new user profile after phone auth.
  Future<AppUser> createUserProfile({
    required String uid,
    required String phoneNumber,
    required UserRole role,
    required String displayName,
  }) async {
    final now = DateTime.now();
    final user = AppUser(
      uid: uid,
      phoneNumber: phoneNumber,
      role: role,
      displayName: displayName,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore.collection('users').doc(uid).set(user.toFirestore());

    // Create role-specific profile
    switch (role) {
      case UserRole.student:
        await _createStudentProfile(uid: uid, fullName: displayName);
        break;
      case UserRole.parent:
        await _createParentProfile(
          uid: uid,
          phoneNumber: phoneNumber,
          fullName: displayName,
        );
        break;
      case UserRole.teacher:
        await _createTeacherProfile(uid: uid, fullName: displayName);
        break;
      case UserRole.superAdmin:
        // Super admin doesn't need extra profile
        break;
    }

    return user;
  }

  /// Create student profile with unique code.
  Future<Student> _createStudentProfile({
    required String uid,
    required String fullName,
  }) async {
    final now = DateTime.now();
    final uniqueCode = await _generateUniqueStudentCode();
    final studentDoc = _firestore.collection('students').doc();

    final student = Student(
      id: studentDoc.id,
      userId: uid,
      fullName: fullName,
      uniqueCode: uniqueCode,
      grade: 4, // Default grade, can be updated later
      createdAt: now,
      updatedAt: now,
    );

    await studentDoc.set(student.toFirestore());
    return student;
  }

  /// Create parent profile.
  Future<ParentModel> _createParentProfile({
    required String uid,
    required String phoneNumber,
    required String fullName,
  }) async {
    final now = DateTime.now();
    final parentDoc = _firestore.collection('parents').doc();

    final parent = ParentModel(
      id: parentDoc.id,
      userId: uid,
      phoneNumber: phoneNumber,
      fullName: fullName,
      linkedStudentIds: [],
      createdAt: now,
      updatedAt: now,
    );

    await parentDoc.set(parent.toFirestore());
    return parent;
  }

  /// Create teacher profile.
  Future<Teacher> _createTeacherProfile({
    required String uid,
    required String fullName,
  }) async {
    final now = DateTime.now();
    final teacherDoc = _firestore.collection('teachers').doc();

    final teacher = Teacher(
      id: teacherDoc.id,
      userId: uid,
      fullName: fullName,
      assignedGrades: [],
      createdAt: now,
      updatedAt: now,
    );

    await teacherDoc.set(teacher.toFirestore());
    return teacher;
  }

  /// Generate a unique student code that doesn't exist in Firestore.
  Future<String> _generateUniqueStudentCode() async {
    String code;
    bool exists;

    do {
      code = StudentCodeGenerator.generate();
      final query = await _firestore
          .collection('students')
          .where('uniqueCode', isEqualTo: code)
          .limit(1)
          .get();
      exists = query.docs.isNotEmpty;
    } while (exists);

    return code;
  }

  /// Link a student to a parent using the student's unique code.
  Future<bool> linkStudentToParent({
    required String parentUserId,
    required String studentCode,
  }) async {
    // Find student by unique code
    final studentQuery = await _firestore
        .collection('students')
        .where('uniqueCode', isEqualTo: studentCode)
        .limit(1)
        .get();

    if (studentQuery.docs.isEmpty) {
      return false;
    }

    final studentDoc = studentQuery.docs.first;
    final studentId = studentDoc.id;

    // Find parent profile
    final parentQuery = await _firestore
        .collection('parents')
        .where('userId', isEqualTo: parentUserId)
        .limit(1)
        .get();

    if (parentQuery.docs.isEmpty) {
      return false;
    }

    final parentDoc = parentQuery.docs.first;

    // Update parent's linked students
    await parentDoc.reference.update({
      'linkedStudentIds': FieldValue.arrayUnion([studentId]),
      'updatedAt': Timestamp.now(),
    });

    // Update student's parent ID
    await studentDoc.reference.update({
      'parentId': parentDoc.id,
      'updatedAt': Timestamp.now(),
    });

    return true;
  }

  /// Get student profile by user ID.
  Future<Student?> getStudentByUserId(String userId) async {
    final query = await _firestore
        .collection('students')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return Student.fromFirestore(query.docs.first);
  }

  /// Get parent profile by user ID.
  Future<ParentModel?> getParentByUserId(String userId) async {
    final query = await _firestore
        .collection('parents')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return ParentModel.fromFirestore(query.docs.first);
  }

  /// Get linked students for a parent.
  Future<List<Student>> getLinkedStudents(List<String> studentIds) async {
    if (studentIds.isEmpty) return [];

    final students = <Student>[];
    // Firestore 'in' query supports max 10 items
    for (int i = 0; i < studentIds.length; i += 10) {
      final batch = studentIds.sublist(
        i,
        i + 10 > studentIds.length ? studentIds.length : i + 10,
      );
      final query = await _firestore
          .collection('students')
          .where(FieldPath.documentId, whereIn: batch)
          .get();
      students.addAll(query.docs.map((doc) => Student.fromFirestore(doc)));
    }
    return students;
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
