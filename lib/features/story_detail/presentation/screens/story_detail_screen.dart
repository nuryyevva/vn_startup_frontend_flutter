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
import '../../../stories/domain/models/story.dart';
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
                      onRestartFromChapter: (scene) => _confirmRestart(context, ref, fromScene: scene),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
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
                    if (progressAsync.valueOrNull != null && progressAsync.valueOrNull!.choicesMade.isNotEmpty)
                      TextButton(
                        onPressed: () => _confirmRestart(context, ref),
                        child: Text('storyDetail.restart'.tr()),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// "Start over" asks first: it wipes the progress and what the AI characters remember about the player.
Future<void> _restartStory(BuildContext context, WidgetRef ref, String storyId, {String? fromSceneId}) async {
  try {
    final restarted = await ref.read(storyRepositoryProvider).restartStory(storyId, fromSceneId: fromSceneId);
    ref.invalidate(storyProgressProvider(storyId));
    ref.invalidate(myProgressProvider);
    if (!context.mounted) return;
    context.push('/play/${restarted.currentSceneId}', extra: ScenePlayerArgs(storyId: storyId));
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('errors.unknownError'.tr())));
    }
  }
}

extension on StoryDetailScreen {
  /// Asks before wiping progress and what the characters remember: the whole story, or (with [fromScene], a chapter's
  /// first scene) only that chapter onwards.
  Future<void> _confirmRestart(BuildContext context, WidgetRef ref, {SceneSummary? fromScene}) async {
    final partial = fromScene != null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text((partial ? 'storyDetail.restartChapterTitle' : 'storyDetail.restartTitle').tr()),
        content: Text((partial ? 'storyDetail.restartChapterBody' : 'storyDetail.restartBody').tr()),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text('common.cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text((partial ? 'storyDetail.restartChapterConfirm' : 'storyDetail.restartConfirm').tr()),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await _restartStory(context, ref, storyId, fromSceneId: fromScene?.id);
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
