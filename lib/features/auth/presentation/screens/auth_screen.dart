import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../providers/auth_state_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  AppException? _error;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final notifier = ref.read(authStateProvider.notifier);
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      if (_isSignUp) {
        await notifier.register(email, password);
        // Login goes through the router's redirect (auth state flipping to
        // authenticated sends it to /stories); registration explicitly
        // detours through onboarding first, since the backend has no
        // "onboarding completed" flag for the redirect to gate on.
        if (mounted) context.go('/onboarding');
      } else {
        await notifier.login(email, password);
      }
    } on DioException catch (e) {
      setState(() => _error = mapDioException(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _continueAsGuest() async {
    final notifier = ref.read(authStateProvider.notifier);
    if (ref.read(appConfigProvider).offline) {
      notifier.continueAsGuest();
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await notifier.registerGuest();
    } on DioException catch (e) {
      setState(() => _error = mapDioException(e));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'auth.validation.emailRequired'.tr();
    if (!_emailRegex.hasMatch(v)) return 'auth.validation.emailInvalid'.tr();
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'auth.validation.passwordRequired'.tr();
    if (v.length < 8) return 'auth.validation.passwordTooShort'.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final appName = ref.watch(appConfigProvider).appName;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(LucideIcons.bookMarked, size: 48, color: colors.accent),
                    const SizedBox(height: 12),
                    Text(appName, textAlign: TextAlign.center, style: textTheme.displayLarge),
                    const SizedBox(height: 8),
                    Text('auth.tagline'.tr(), textAlign: TextAlign.center, style: textTheme.bodyMedium),
                    const SizedBox(height: 32),
                    _AuthModeToggle(
                      isSignUp: _isSignUp,
                      onChanged: (value) {
                        setState(() {
                          _isSignUp = value;
                          _error = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(labelText: 'auth.email'.tr(), hintText: 'auth.emailHint'.tr()),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: 'auth.password'.tr(),
                        suffixIcon: AppIconButton(
                          icon: _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                          size: 20,
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!.localizedMessage(), style: textTheme.bodyMedium?.copyWith(color: colors.error)),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_isSignUp ? 'auth.signUp'.tr() : 'auth.signIn'.tr()),
                    ),
                    const SizedBox(height: 16),
                    TextButton(onPressed: _isSubmitting ? null : _continueAsGuest, child: Text('auth.continueAsGuest'.tr())),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthModeToggle extends StatelessWidget {
  const _AuthModeToggle({required this.isSignUp, required this.onChanged});

  final bool isSignUp;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _segment(context, label: 'auth.signIn'.tr(), selected: !isSignUp, onTap: () => onChanged(false))),
          Expanded(child: _segment(context, label: 'auth.signUp'.tr(), selected: isSignUp, onTap: () => onChanged(true))),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, {required String label, required bool selected, required VoidCallback onTap}) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.microDuration,
        curve: Motion.microCurve,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.titleMedium?.copyWith(color: selected ? Colors.white : colors.textSecondary),
        ),
      ),
    );
  }
}
