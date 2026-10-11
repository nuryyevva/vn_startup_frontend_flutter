import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/motion.dart';
import '../../../stories/domain/models/story.dart';

/// A chapter as listed on the story detail screen: the scene it starts at,
/// plus the named sections inside it (shown when the chapter is expanded).
///
/// A branching story is made of many short scenes linked by choices, so it
/// marks which of them start a chapter ([SceneSummary.chapterTitle]) and
/// which start a section of one ([SceneSummary.title]). A story that marks
/// no chapters lists every scene as its own chapter, with no sections.
class StoryChapter {
  const StoryChapter({required this.start, required this.sections, required this.lastOrderIndex});

  final SceneSummary start;
  final List<SceneSummary> sections;

  /// `order_index` of the chapter's last scene.
  final int lastOrderIndex;

  String? get title => start.chapterTitle;

  bool contains(int orderIndex) => orderIndex >= start.orderIndex && orderIndex <= lastOrderIndex;

  /// The section a reader at [orderIndex] is in: the last one starting at
  /// or before it.
  SceneSummary? sectionAt(int orderIndex) =>
      contains(orderIndex) ? sections.lastWhereOrNull((s) => s.orderIndex <= orderIndex) : null;

  /// Groups [scenes] (ordered by `order_index`) into chapters.
  static List<StoryChapter> group(List<SceneSummary> scenes) {
    final starts = scenes.where((s) => s.chapterTitle != null).toList();
    if (starts.isEmpty) {
      return [
        for (final scene in scenes) StoryChapter(start: scene, sections: const [], lastOrderIndex: scene.orderIndex),
      ];
    }
    return [
      for (final (i, start) in starts.indexed)
        () {
          final end = i + 1 < starts.length ? starts[i + 1].orderIndex : scenes.last.orderIndex + 1;
          return StoryChapter(
            start: start,
            sections: scenes
                .where((s) => s.title != null && s.orderIndex >= start.orderIndex && s.orderIndex < end)
                .toList(),
            lastOrderIndex: end - 1,
          );
        }(),
    ];
  }
}

/// The story's chapters; one with sections gets a small expand button that
/// reveals them, with the reader's current section marked — the quickest
/// way to see where they stopped.
class ChapterList extends StatefulWidget {
  const ChapterList({super.key, required this.scenes, required this.currentSceneId, required this.onTapScene});

  final List<SceneSummary> scenes;
  final String? currentSceneId;
  final ValueChanged<SceneSummary> onTapScene;

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  /// Chapters the reader expanded/collapsed by hand, by start scene id.
  /// Until they do, the chapter they're in the middle of starts expanded.
  final _toggled = <String, bool>{};

  @override
  Widget build(BuildContext context) {
    final scenes = widget.scenes;
    final chapters = StoryChapter.group(scenes);
    final current = widget.currentSceneId == null
        ? null
        : scenes.firstWhereOrNull((s) => s.id == widget.currentSceneId)?.orderIndex;
    final finished = current != null && scenes.isNotEmpty && current >= scenes.last.orderIndex;

    return Column(
      children: [
        for (final (i, chapter) in chapters.indexed)
          _ChapterTile(
            number: i + 1,
            chapter: chapter,
            currentOrderIndex: current,
            // Read once progress is past the chapter — or, for the last
            // one, once the story's final scene is reached.
            isRead:
                current != null &&
                (current > chapter.lastOrderIndex || (finished && chapter.sections.isNotEmpty && chapter == chapters.last)),
            isExpanded:
                _toggled[chapter.start.id] ??
                (current != null && !finished && chapter.contains(current) && current > chapter.start.orderIndex),
            onToggle: (expanded) => setState(() => _toggled[chapter.start.id] = expanded),
            onTapScene: widget.onTapScene,
          ),
      ],
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({
    required this.number,
    required this.chapter,
    required this.currentOrderIndex,
    required this.isRead,
    required this.isExpanded,
    required this.onToggle,
    required this.onTapScene,
  });

  final int number;
  final StoryChapter chapter;
  final int? currentOrderIndex;
  final bool isRead;
  final bool isExpanded;
  final ValueChanged<bool> onToggle;
  final ValueChanged<SceneSummary> onTapScene;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final scene = chapter.start;
    final isLocked = !scene.isUnlocked;
    final label = 'storyDetail.chapterLabel'.tr(args: ['$number']);
    final current = currentOrderIndex;
    final currentSection = current == null ? null : chapter.sectionAt(current);

    return Column(
      children: [
        InkWell(
          onTap: () => onTapScene(scene),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: chapter.title == null
                      ? Text(label, style: textTheme.bodyLarge)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: textTheme.labelMedium?.copyWith(color: colors.textMuted)),
                            const SizedBox(height: 2),
                            Text(chapter.title!, style: textTheme.bodyLarge),
                          ],
                        ),
                ),
                if (isLocked)
                  Row(
                    children: [
                      Icon(LucideIcons.lock, size: 16, color: colors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        'storyDetail.chapterUnlockCost'.tr(args: ['${scene.unlockCostDiamonds}']),
                        style: textTheme.labelMedium,
                      ),
                    ],
                  )
                else if (isRead)
                  Icon(LucideIcons.circleCheck, size: 20, color: colors.accent)
                else
                  Icon(LucideIcons.circle, size: 20, color: colors.textMuted),
                if (chapter.sections.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => onToggle(!isExpanded),
                    visualDensity: VisualDensity.compact,
                    tooltip: (isExpanded ? 'storyDetail.hideScenes' : 'storyDetail.showScenes').tr(),
                    icon: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: Motion.microDuration,
                      child: Icon(LucideIcons.chevronDown, size: 20, color: colors.textSecondary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: Motion.microDuration,
          alignment: Alignment.topCenter,
          child: !isExpanded
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: colors.border)),
                    ),
                    child: Column(
                      children: [
                        for (final (i, section) in chapter.sections.indexed)
                          _SectionRow(
                            number: i + 1,
                            section: section,
                            isCurrent: section.id == currentSection?.id && !isRead,
                            // Read once progress has reached the next
                            // section (or left the chapter altogether).
                            isRead:
                                isRead ||
                                (current != null &&
                                    i + 1 < chapter.sections.length &&
                                    current >= chapter.sections[i + 1].orderIndex),
                            onTap: () => onTapScene(section),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.number,
    required this.section,
    required this.isCurrent,
    required this.isRead,
    required this.onTap,
  });

  final int number;
  final SceneSummary section;
  final bool isCurrent;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text('$number', style: textTheme.labelMedium?.copyWith(color: colors.textMuted)),
            ),
            Expanded(
              child: Text(
                section.title ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: isCurrent ? colors.textPrimary : colors.textSecondary,
                  fontWeight: isCurrent ? FontWeight.w600 : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'storyDetail.youAreHere'.tr(),
                  style: textTheme.labelSmall?.copyWith(color: colors.accent, fontWeight: FontWeight.w600),
                ),
              )
            else if (isRead)
              Icon(LucideIcons.check, size: 16, color: colors.accent),
            // Keeps the trailing column aligned with the chapter row's
            // expand button above.
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
