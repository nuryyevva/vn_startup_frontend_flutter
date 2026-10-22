import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/genres.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/genre_chip.dart';
import '../../../../core/widgets/image_placeholder.dart';
import '../../../achievements/presentation/providers/achievements_provider.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../stats/presentation/providers/reading_stats_provider.dart';
import '../../../stories/presentation/open_story.dart';
import '../../../stories/presentation/providers/stories_providers.dart';
import '../../../stories/presentation/widgets/story_card.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../../domain/models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/achievement_tile.dart';
import '../widgets/favorite_genres_sheet.dart';
import '../widgets/stat_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final progressAsync = ref.watch(myProgressProvider);
    final balanceAsync = ref.watch(walletBalanceProvider);
    final statsAsync = ref.watch(readingStatsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('nav.profile'.tr()),
        actions: [
          AppIconButton(icon: LucideIcons.settings, onTap: () => context.push('/settings')),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileNotifierProvider);
          ref.invalidate(myProgressProvider);
          ref.invalidate(achievementsProvider);
          await Future.wait([ref.read(walletBalanceProvider.notifier).refresh(), ref.read(readingStatsProvider.notifier).refresh()]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            profileAsync.when(
              data: (profile) => _ProfileHeader(profile: profile),
              loading: () => const _ProfileHeaderSkeleton(),
              error: (error, stackTrace) => const SizedBox(),
            ),
            const SizedBox(height: 24),
            _StatsGrid(
              finished: progressAsync.valueOrNull?.where((p) => p.isFinished).length,
              diamonds: balanceAsync.valueOrNull,
              dayStreak: statsAsync.valueOrNull?.dayStreak,
              hoursRead: statsAsync.valueOrNull?.hoursRead,
            ),
            const SizedBox(height: 24),
            _SectionTitle('profile.myLibrary'.tr()),
            const SizedBox(height: 12),
            progressAsync.when(
              data: (progress) => progress.isEmpty
                  ? _EmptyState('profile.emptyLibrary'.tr())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: progress.length,
                      itemBuilder: (context, index) {
                        final p = progress[index];
                        return StoryCard(
                          story: p.story,
                          progress: p,
                          compact: true,
                          onTap: () => openStory(context, p.story),
                        );
                      },
                    ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => _EmptyState('profile.emptyLibrary'.tr()),
            ),
            const SizedBox(height: 24),
            _SectionTitle('profile.achievements'.tr()),
            const SizedBox(height: 12),
            achievementsAsync.when(
              data: (achievements) => achievements.isEmpty
                  ? _EmptyState('profile.emptyAchievements'.tr())
                  : Column(children: [for (final a in achievements) AchievementTile(achievement: a)]),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => _EmptyState('errors.networkError'.tr()),
            ),
            const SizedBox(height: 24),
            _FavoriteGenresSection(profile: profileAsync.valueOrNull),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => _signOut(context, ref),
              child: Text('common.signOut'.tr()),
            ),
          ].animate(interval: Motion.staggerStep).fadeIn(duration: Motion.staggerItemDuration).slideY(begin: 0.05, end: 0),
        ),
      ),
    );
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayName = profile.displayName?.isNotEmpty == true ? profile.displayName! : profile.email;
    return Column(
      children: [
        const SizedBox(
          width: 88,
          height: 88,
          child: ClipOval(child: ImagePlaceholder(icon: LucideIcons.user, iconSize: 36)),
        ),
        const SizedBox(height: 12),
        Text(displayName, style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text('profile.readerSince'.tr(args: ['${profile.createdAt.year}']), style: textTheme.bodyMedium),
      ],
    );
  }
}

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(width: 88, height: 88, child: ClipOval(child: ImagePlaceholder())),
        SizedBox(height: 12),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.finished, required this.diamonds, required this.dayStreak, required this.hoursRead});

  final int? finished;
  final int? diamonds;
  final int? dayStreak;
  final double? hoursRead;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        StatTile(icon: LucideIcons.flame, value: dayStreak?.toString(), label: 'profile.dayStreak'.tr()),
        StatTile(icon: LucideIcons.clock, value: hoursRead?.toStringAsFixed(1), label: 'profile.hoursRead'.tr()),
        StatTile(
          icon: LucideIcons.bookOpenCheck,
          value: finished?.toString(),
          label: 'profile.finished'.tr(),
        ),
        StatTile(icon: LucideIcons.gem, value: diamonds?.toString(), label: 'profile.diamonds'.tr()),
      ],
    );
  }
}

class _FavoriteGenresSection extends ConsumerWidget {
  const _FavoriteGenresSection({required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = profile?.favoriteGenres ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _SectionTitle('profile.favoriteGenres'.tr())),
            TextButton.icon(
              onPressed: profile == null ? null : () => _edit(context, ref, selected),
              icon: const Icon(LucideIcons.pencil, size: 16),
              label: Text('profile.editGenres'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (selected.isEmpty)
          _EmptyState('onboarding.genresSubtitle'.tr())
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final id in selected) GenreChip(label: genreLabelKeyFor(id).tr(), selected: true, onTap: () {})],
          ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, List<String> selected) async {
    final result = await showFavoriteGenresSheet(context, initiallySelected: selected.toSet());
    if (result == null) return;
    await ref.read(userProfileNotifierProvider.notifier).updateProfile(UpdateProfileRequest(favoriteGenres: result.toList()));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted));
  }
}
