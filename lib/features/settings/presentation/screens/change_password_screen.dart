import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canSubmit =
        !_isSaving && _currentPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty;
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
              onChanged: (_) => setState(() => _errorMessage = null),
              decoration: InputDecoration(labelText: 'settings.currentPassword'.tr()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              onChanged: (_) => setState(() => _errorMessage = null),
              decoration: InputDecoration(labelText: 'settings.newPassword'.tr()),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.warning)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: canSubmit ? _submit : null,
              child: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('common.save'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(_currentPasswordController.text, _newPasswordController.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('settings.changePasswordSuccess'.tr())));
      Navigator.of(context).pop();
    } on DioException catch (error) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = mapDioException(error).localizedMessage();
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'errors.unknownError'.tr();
        });
      }
    }
  }
}
