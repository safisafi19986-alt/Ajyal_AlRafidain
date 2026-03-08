import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';
import '../../widgets/iraqi_pattern_background.dart';
import '../../widgets/loading_overlay.dart';

/// OTP verification screen.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _otpControllers.map((c) => c.text).join();

  void _onVerify() {
    if (_otpCode.length == 6) {
      context.read<AuthProvider>().verifyOtp(_otpCode);
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_otpCode.length == 6) {
      _onVerify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          body: LoadingOverlay(
            isLoading: authProvider.isLoading,
            message: 'جاري التحقق...',
            child: IraqiPatternBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Back button
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: IraqiTheme.lightText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: IraqiTheme.primaryGold.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sms_rounded,
                          size: 50,
                          color: IraqiTheme.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'التحقق من الرقم',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: IraqiTheme.lightText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'أدخل رمز التحقق المكون من 6 أرقام',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: IraqiTheme.lightText.withAlpha(204),
                            ),
                      ),
                      const SizedBox(height: 32),
                      // OTP input fields
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(6, (index) {
                                    return SizedBox(
                                      width: 45,
                                      height: 55,
                                      child: TextFormField(
                                        controller: _otpControllers[index],
                                        focusNode: _focusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: IraqiTheme.ishtarBlue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) =>
                                            _onOtpChanged(index, value),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Error
                              if (authProvider.errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
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
                              // Verify button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _otpCode.length == 6 &&
                                          !authProvider.isLoading
                                      ? _onVerify
                                      : null,
                                  child: const Text('تحقق'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Resend
                              TextButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () {
                                        Navigator.of(context).pop();
                                      },
                                child: Text(
                                  'إعادة إرسال الرمز',
                                  style: TextStyle(
                                    color: IraqiTheme.ishtarBlue
                                        .withAlpha(179),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
