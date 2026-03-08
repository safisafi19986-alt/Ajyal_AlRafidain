import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';
import '../../widgets/iraqi_pattern_background.dart';
import '../../widgets/loading_overlay.dart';
import 'otp_verification_screen.dart';

/// Phone number login screen with Iraqi UI styling.
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = '+964'; // Iraq country code

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    if (!_formKey.currentState!.validate()) return;

    final phone = '$_countryCode${_phoneController.text.trim()}';
    context.read<AuthProvider>().sendOtp(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Navigate to OTP screen when code is sent
        if (authProvider.authState == AuthState.otpSent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OtpVerificationScreen(),
              ),
            );
          });
        }

        return Scaffold(
          body: LoadingOverlay(
            isLoading: authProvider.isLoading,
            message: 'جاري إرسال رمز التحقق...',
            child: IraqiPatternBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      // App Logo placeholder
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: IraqiTheme.primaryGold.withAlpha(51),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: IraqiTheme.primaryGold,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 60,
                          color: IraqiTheme.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // App name
                      Text(
                        'أجيال الرافدين',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              color: IraqiTheme.lightText,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تعليم عراقي بهوية حضارية',
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: IraqiTheme.lightText.withAlpha(204),
                                ),
                      ),
                      const SizedBox(height: 48),
                      // Login card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'تسجيل الدخول',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'أدخل رقم هاتفك لتلقي رمز التحقق',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: IraqiTheme.darkText
                                            .withAlpha(153),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                // Phone input
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Country code dropdown
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: IraqiTheme.desertSand,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFE0D5C5),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _countryCode,
                                            isDense: true,
                                            items: const [
                                              DropdownMenuItem(
                                                value: '+964',
                                                child: Text('🇮🇶 +964'),
                                              ),
                                              DropdownMenuItem(
                                                value: '+966',
                                                child: Text('🇸🇦 +966'),
                                              ),
                                              DropdownMenuItem(
                                                value: '+971',
                                                child: Text('🇦🇪 +971'),
                                              ),
                                              DropdownMenuItem(
                                                value: '+962',
                                                child: Text('🇯🇴 +962'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _countryCode = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Phone number field
                                      Expanded(
                                        child: TextFormField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          textDirection: TextDirection.ltr,
                                          decoration: const InputDecoration(
                                            hintText: '7XX XXX XXXX',
                                            prefixIcon: Icon(
                                              Icons.phone_android_rounded,
                                              color: IraqiTheme.ishtarBlue,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'يرجى إدخال رقم الهاتف';
                                            }
                                            if (value.trim().length < 9) {
                                              return 'رقم الهاتف غير صالح';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Error message
                                if (authProvider.errorMessage != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      authProvider.errorMessage!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: IraqiTheme.errorRed,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                // Send OTP button
                                ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _onSendOtp,
                                  child: const Text('إرسال رمز التحقق'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
