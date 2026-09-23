import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/segmented_control.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../profile/domain/models/user_profile.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../widgets/settings_row.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final profile = profileAsync.valueOrNull;
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('settings.appearance'.tr()),
          Text('settings.theme'.tr(), style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          SegmentedControl<ThemeMode>(
            value: themeMode,
            options: [
              SegmentedOption(value: ThemeMode.dark, label: 'settings.themeDark'.tr(), icon: LucideIcons.moon),
              SegmentedOption(value: ThemeMode.light, label: 'settings.themeLight'.tr(), icon: LucideIcons.sun),
            ],
            onChanged: (mode) => _setThemeMode(ref, mode),
          ),
          const SizedBox(height: 20),
          Text('settings.language'.tr(), style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          SegmentedControl<String>(
            value: context.locale.languageCode,
            options: const [
              SegmentedOption(value: 'ru', label: 'Русский'),
              SegmentedOption(value: 'en', label: 'English'),
            ],
            onChanged: (code) => _setLanguage(context, ref, code),
          ),
          const SizedBox(height: 28),
          _SectionHeader('settings.notifications'.tr()),
          SettingsSwitchRow(
            label: 'settings.newChapterAlerts'.tr(),
            subtitle: 'settings.newChapterAlertsBody'.tr(),
            value: profile?.notifyNewChapters ?? true,
            onChanged: profile == null ? null : (value) => _syncProfile(ref, UpdateProfileRequest(notifyNewChapters: value)),
          ),
          const Divider(height: 24),
          SettingsSwitchRow(
            label: 'settings.promotionalOffers'.tr(),
            subtitle: 'settings.promotionalOffersBody'.tr(),
            value: profile?.notifyPromotionalOffers ?? false,
            onChanged: profile == null
                ? null
                : (value) => _syncProfile(ref, UpdateProfileRequest(notifyPromotionalOffers: value)),
          ),
          const SizedBox(height: 28),
          _SectionHeader('settings.account'.tr()),
          SettingsRow(label: 'settings.email'.tr(), trailingText: profileAsync.valueOrNull?.email ?? ''),
          const Divider(height: 1),
          SettingsRow(
            label: 'settings.changePassword'.tr(),
            onTap: () => context.push('/settings/change-password'),
          ),
          const Divider(height: 1),
          SettingsRow(
            label: 'settings.manageSubscription'.tr(),
            onTap: () => _showNotAvailable(context, 'settings.manageSubscriptionBody'.tr()),
          ),
          const SizedBox(height: 28),
          _SectionHeader('settings.about'.tr()),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              return SettingsRow(label: 'settings.version'.tr(), trailingText: snapshot.data?.version ?? '');
            },
          ),
          const Divider(height: 1),
          SettingsRow(label: 'settings.termsPrivacy'.tr(), onTap: () => _openTerms(config.termsPrivacyUrl)),
          const SizedBox(height: 32),
          OutlinedButton(onPressed: () => _signOut(context, ref), child: Text('common.signOut'.tr())),
        ],
      ),
    );
  }

  Future<void> _setThemeMode(WidgetRef ref, ThemeMode mode) async {
    await ref.read(themeModeProvider.notifier).setThemeMode(mode);
    final wireValue = mode == ThemeMode.light ? 'light' : 'dark';
    await _syncProfile(ref, UpdateProfileRequest(theme: wireValue));
  }

  Future<void> _setLanguage(BuildContext context, WidgetRef ref, String code) async {
    await context.setLocale(Locale(code));
    await _syncProfile(ref, UpdateProfileRequest(language: code));
  }

  /// Best-effort background sync — a failed PATCH here shouldn't block the
  /// (already-applied) local UI change; the user's next successful edit
  /// will re-sync anyway.
  Future<void> _syncProfile(WidgetRef ref, UpdateProfileRequest request) async {
    try {
      await ref.read(userProfileNotifierProvider.notifier).updateProfile(request);
    } catch (_) {
      // Local state already reflects the choice; nothing further to do.
    }
  }

  void _showNotAvailable(BuildContext context, String body) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('common.notAvailableYet'.tr()),
        content: Text(body),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('common.confirm'.tr()))],
      ),
    );
  }

  Future<void> _openTerms(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'common.signOutConfirmTitle'.tr(),
      body: 'common.signOutConfirmBody'.tr(),
      confirmLabel: 'common.signOut'.tr(),
      cancelLabel: 'common.cancel'.tr(),
      destructive: true,
    );
    if (confirmed) {
      await ref.read(authStateProvider.notifier).signOut();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: colors.textMuted, letterSpacing: 0.8, fontWeight: FontWeight.w700),
      ),
    );
  }
}
