import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/diamond_badge.dart';
import '../../../../core/widgets/genre_chip.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../wallet/presentation/providers/wallet_balance_provider.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/stories_providers.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/story_card.dart';

class StoriesScreen extends ConsumerStatefulWidget {
  const StoriesScreen({super.key});

  @override
  ConsumerState<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent - 400) return;
    ref.read(storiesListProvider.notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final appName = ref.watch(appConfigProvider).appName;
    final balanceAsync = ref.watch(walletBalanceProvider);
    final genres = ref.watch(appConfigProvider).genres;
    final selectedGenre = ref.watch(selectedGenreProvider);
    final storiesAsync = ref.watch(storiesListProvider);
    final bookmarks = ref.watch(bookmarksProvider);
    final myProgressAsync = ref.watch(myProgressProvider);

    final continueReading = (myProgressAsync.valueOrNull ?? const [])
        .where((p) => !p.isFinished && p.currentSceneOrderIndex > 0)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(storiesListProvider.notifier).refresh();
            ref.invalidate(myProgressProvider);
            await ref.read(walletBalanceProvider.notifier).refresh();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appName, style: Theme.of(context).textTheme.headlineLarge),
                      DiamondBadge(
                        balance: balanceAsync.valueOrNull,
                        onTap: () => StatefulNavigationShell.of(context).goBranch(1),
                      ),
                    ],
                  ),
                ),
              ),
              if (continueReading.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text('stories.continueReading'.tr(), style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    // 140-wide card: 3:4 cover (~187) + title + progress bar
                    // + percent label — 220 clipped the label (see
                    // ContinueReadingCard).
                    height: 252,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: continueReading.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final progress = continueReading[index];
                        return ContinueReadingCard(
                          progress: progress,
                          onTap: () => context.push('/story/${progress.story.id}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length + 1,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GenreChip(
                            label: 'genres.all'.tr(),
                            selected: selectedGenre == null,
                            onTap: () => _selectGenre(null),
                          );
                        }
                        final genre = genres[index - 1];
                        return GenreChip(
                          label: genre.labelKey.tr(),
                          selected: selectedGenre == genre.id,
                          onTap: () => _selectGenre(genre.id),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: storiesAsync.when(
                  data: (pageState) {
                    final stories = pageState.items;
                    if (stories.isEmpty) {
                      return SliverToBoxAdapter(
                        child: _EmptyCatalog(),
                      );
                    }
                    return SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.6,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final story = stories[index];
                          final progress = myProgressAsync.valueOrNull?.where((p) => p.story.id == story.id).firstOrNull;
                          return StoryCard(
                            story: story,
                            progress: progress,
                            isBookmarked: bookmarks.contains(story.id),
                            onBookmarkTap: () => ref.read(bookmarksProvider.notifier).toggle(story.id),
                            onTap: () => context.push('/story/${story.id}'),
                          ).animate(delay: Motion.staggerStep * (index % 6)).fadeIn(duration: Motion.staggerItemDuration);
                        },
                        childCount: stories.length,
                      ),
                    );
                  },
                  loading: () => SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: const ShimmerPlaceholder(),
                      ),
                      childCount: 6,
                    ),
                  ),
                  error: (error, stackTrace) =>
                      SliverToBoxAdapter(child: _ErrorState(onRetry: () => ref.read(storiesListProvider.notifier).refresh())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectGenre(String? genreId) {
    ref.read(selectedGenreProvider.notifier).state = genreId;
    _scrollController.animateTo(0, duration: Motion.screenDuration, curve: Motion.screenCurve);
  }
}

class _EmptyCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text('stories.emptyCatalogTitle'.tr(), style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'stories.emptyCatalogBody'.tr(),
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text('errors.networkError'.tr()),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text('common.retry'.tr())),
        ],
      ),
    );
  }
}
