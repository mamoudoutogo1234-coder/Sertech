import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../application/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _submitting = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final controller = ref.read(authControllerProvider);
      await controller.signUp(
        email: _email.text.trim(),
        password: _password.text,
        displayName: _name.text.trim().isEmpty ? null : _name.text.trim(),
      );
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    if (_error != null) {
      return Scaffold(
        body: AppErrorView(
          message: l10n.authError,
          technicalDetails: _error,
          retryLabel: l10n.retry,
          onRetry: () => setState(() => _error = null),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.36,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/auth_img/register.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primaryDeep,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x40000000),
                        Color(0xCC07110C),
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + AppSpacing.s12,
                  left: AppSpacing.s16,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + AppSpacing.s16,
                  right: AppSpacing.s24,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.leaf,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Text(
                        l10n.appName.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 40,
                    offset: const Offset(0, -20),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.s24,
                  AppSpacing.s28,
                  AppSpacing.s24,
                  MediaQuery.of(context).padding.bottom + AppSpacing.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.registerTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s28),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _name,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nom complet',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s14),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: l10n.email,
                              prefixIcon: const Icon(Icons.mail_outline),
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty || !email.contains('@')) {
                                return l10n.emailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.s14),
                          TextFormField(
                            controller: _password,
                            obscureText: _obscure1,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: l10n.password,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure1 = !_obscure1),
                                icon: Icon(
                                  _obscure1
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if ((value ?? '').length < 6) {
                                return l10n.passwordTooShort;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.s14),
                          TextFormField(
                            controller: _confirm,
                            obscureText: _obscure2,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: l10n.confirmPassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure2 = !_obscure2),
                                icon: Icon(
                                  _obscure2
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if ((value ?? '') != _password.text) {
                                return l10n.passwordsDoNotMatch;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.s24),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: _submitting ? null : _submit,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.radiusLg),
                                ),
                              ),
                              child: _submitting
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      l10n.createAccount,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Text(
                                l10n.alreadyHaveAccountText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TextButton(
                                onPressed: _submitting
                                    ? null
                                    : () => context.pushNamed(RouteNames.login),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  l10n.signInLink,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
