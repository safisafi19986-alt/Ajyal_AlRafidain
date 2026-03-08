import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';
import '../../utils/student_code_generator.dart';
import '../../widgets/loading_overlay.dart';

/// Screen for parents to link students using unique student codes.
class LinkStudentScreen extends StatefulWidget {
  const LinkStudentScreen({super.key});

  @override
  State<LinkStudentScreen> createState() => _LinkStudentScreenState();
}

class _LinkStudentScreenState extends State<LinkStudentScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _linkSuccess = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onLinkStudent() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().linkStudent(
          _codeController.text.trim().toUpperCase(),
        );

    if (success) {
      setState(() => _linkSuccess = true);
      _codeController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم ربط الطالب بنجاح!'),
            backgroundColor: IraqiTheme.successGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ربط طالب'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: LoadingOverlay(
            isLoading: authProvider.isLoading,
            message: 'جاري ربط الطالب...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Card(
                    color: IraqiTheme.desertSand,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: IraqiTheme.ishtarBlue,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'كيفية ربط الطالب',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اطلب من الطالب أو المعلم الرمز الفريد الخاص بالطالب '
                            '(يبدأ بـ AJR) وأدخله أدناه لربط حساب الطالب بحسابك.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Code input
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            controller: _codeController,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.characters,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                ),
                            decoration: const InputDecoration(
                              hintText: 'AJR-XXXXX-XXXX',
                              prefixIcon: Icon(
                                Icons.qr_code_rounded,
                                color: IraqiTheme.ishtarBlue,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال رمز الطالب';
                              }
                              if (!StudentCodeGenerator.isValidCode(
                                  value.trim().toUpperCase())) {
                                return 'رمز الطالب غير صالح. يجب أن يكون بصيغة AJR-XXXXX-XXXX';
                              }
                              return null;
                            },
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
                                  ?.copyWith(color: IraqiTheme.errorRed),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ElevatedButton.icon(
                          onPressed:
                              authProvider.isLoading ? null : _onLinkStudent,
                          icon: const Icon(Icons.link_rounded),
                          label: const Text('ربط الطالب'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Linked students list
                  if (authProvider.parentProfile != null &&
                      authProvider.parentProfile!.linkedStudentIds.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الطلاب المرتبطون (${authProvider.parentProfile!.linkedStudentIds.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...authProvider.parentProfile!.linkedStudentIds
                            .map((id) => Card(
                                  child: ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: IraqiTheme.tigrisTeal
                                            .withAlpha(31),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: IraqiTheme.tigrisTeal,
                                      ),
                                    ),
                                    title: Text('طالب: $id'),
                                    trailing: const Icon(
                                      Icons.check_circle_rounded,
                                      color: IraqiTheme.successGreen,
                                    ),
                                  ),
                                )),
                      ],
                    ),
                  // Success message
                  if (_linkSuccess)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Card(
                        color: IraqiTheme.successGreen.withAlpha(26),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: IraqiTheme.successGreen),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'تم ربط الطالب بنجاح! يمكنك ربط المزيد من الطلاب.',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
