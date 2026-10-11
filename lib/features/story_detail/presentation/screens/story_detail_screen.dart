import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/genres.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/image_placeholder.dart';
import '../../../scene_player/domain/scene_player_args.dart';
import '../../../stories/presentation/providers/bookmarks_provider.dart';
import '../../../stories/presentation/providers/stories_providers.dart';
import '../widgets/chapter_list.dart';

class StoryDetailScreen extends ConsumerWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyByIdProvider(storyId));
    final scenesAsync = ref.watch(storyScenesProvider(storyId));
    final progressAsync = ref.watch(storyProgressProvider(storyId));
    final bookmarks = ref.watch(bookmarksProvider);
    final isBookmarked = bookmarks.contains(storyId);

    final story = storyAsync.valueOrNull;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            leading: AppIconButton(icon: LucideIcons.arrowLeft, onTap: () => context.pop()),
            actions: [
              AppIconButton(
                icon: isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
                onTap: () => ref.read(bookmarksProvider.notifier).toggle(storyId),
              ),
              const SizedBox(width: 8),
            ],
            expandedHeight: 320,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'story-cover-$storyId',
                child: RemoteImage(url: story?.coverUrl),
              ),
            ),
          ),
          if (story == null)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(story.title, style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _Tag(genreLabelKeyFor(story.genre).tr()),
                      _Tag((story.status == 'completed' ? 'stories.completed' : 'stories.ongoing').tr()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  scenesAsync.when(
                    data: (scenes) => Text(
                      'storyDetail.chapters'.tr(args: ['${StoryChapter.group(scenes).length}']),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    loading: () => const SizedBox(),
                    error: (error, stackTrace) => const SizedBox(),
                  ),
                  if (story.description != null) ...[
                    const SizedBox(height: 16),
                    Text(story.description!, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                  const SizedBox(height: 24),
                  scenesAsync.when(
                    data: (scenes) => ChapterList(
                      scenes: scenes,
                      currentSceneId: progressAsync.valueOrNull?.currentSceneId,
                      onTapScene: (scene) => context.push(
                        '/play/${scene.id}',
                        extra: ScenePlayerArgs(storyId: storyId, unlockCostDiamonds: scene.unlockCostDiamonds),
                      ),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Text('errors.networkError'.tr()),
                  ),
                ]),
              ),
            ),
        ],
      ),
      bottomNavigationBar: story == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    final sceneId = progressAsync.valueOrNull?.currentSceneId;
                    if (sceneId == null) return;
                    final currentScene = scenesAsync.valueOrNull?.firstWhereOrNull((s) => s.id == sceneId);
                    context.push(
                      '/play/$sceneId',
                      extra: ScenePlayerArgs(storyId: storyId, unlockCostDiamonds: currentScene?.unlockCostDiamonds),
                    );
                  },
                  child: Text(
                    (progressAsync.valueOrNull != null && progressAsync.valueOrNull!.choicesMade.isNotEmpty)
                        ? 'storyDetail.continueReading'.tr()
                        : 'storyDetail.startReading'.tr(),
                  ),
                ),
              ),
            ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: colors.border), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
