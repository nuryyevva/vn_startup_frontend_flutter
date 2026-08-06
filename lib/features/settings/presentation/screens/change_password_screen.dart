import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The form UI is real; submitting is disabled with an explicit explanation
/// rather than silently doing nothing — the backend has no
/// change-password endpoint yet (`internal/auth` only exposes
/// register/login/refresh). See project README "known limitations".
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text('settings.changePasswordTitle'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'settings.currentPassword'.tr()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'settings.newPassword'.tr()),
            ),
            const SizedBox(height: 16),
            Text(
              'settings.changePasswordUnavailable'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.warning),
            ),
            const SizedBox(height: 24),
            const ElevatedButton(onPressed: null, child: _SaveLabel()),
          ],
        ),
      ),
    );
  }
}

class _SaveLabel extends StatelessWidget {
  const _SaveLabel();

  @override
  Widget build(BuildContext context) => Text('common.save'.tr());
}
