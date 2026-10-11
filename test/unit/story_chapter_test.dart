import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';
import 'package:nocturne/features/story_detail/presentation/widgets/chapter_list.dart';

SceneSummary _scene(int order, {String? chapter, String? title}) =>
    SceneSummary(id: 's$order', orderIndex: order, isUnlocked: true, chapterTitle: chapter, title: title);

void main() {
  test('a story that marks no chapters lists every scene as one', () {
    final chapters = StoryChapter.group([_scene(0), _scene(1), _scene(2)]);

    expect(chapters.map((c) => c.start.id), ['s0', 's1', 's2']);
    expect(chapters.every((c) => c.sections.isEmpty), isTrue);
    expect(chapters[1].lastOrderIndex, 1);
  });

  test('marked chapters span up to the next one and collect their titled sections', () {
    final chapters = StoryChapter.group([
      _scene(0, chapter: 'One', title: 'a'),
      _scene(1),
      _scene(2, title: 'b'),
      _scene(3),
      _scene(4, chapter: 'Two', title: 'c'),
      _scene(5),
    ]);

    expect(chapters.map((c) => c.title), ['One', 'Two']);
    expect(chapters[0].sections.map((s) => s.title), ['a', 'b']);
    expect(chapters[0].lastOrderIndex, 3);
    expect(chapters[1].lastOrderIndex, 5);

    // A reader on an untitled scene is in the section that started before it.
    expect(chapters[0].sectionAt(1)?.title, 'a');
    expect(chapters[0].sectionAt(3)?.title, 'b');
    expect(chapters[0].sectionAt(4), isNull);
  });
}
