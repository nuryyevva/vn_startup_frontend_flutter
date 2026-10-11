import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/core/network/media_url.dart';
import 'package:nocturne/features/scene_player/domain/dialogue_line.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';

Scene _scene(List<Map<String, dynamic>> script, {String? background = 'bg0', String? sprite}) => Scene(
  id: 's',
  storyId: 'story',
  orderIndex: 0,
  backgroundUrl: background,
  characterSpriteUrl: sprite,
  dialogueScript: script,
  freeDialogEnabled: false,
);

void main() {
  group('DialogueLine.resolveScript', () {
    test('backgrounds and sprites are sticky until switched; empty sprite hides', () {
      final lines = DialogueLine.resolveScript(
        _scene([
          {'speaker': 'narrator', 'text': 'a'},
          {'speaker': 'Ной', 'text': 'b', 'sprite_url': 'noah', 'background_url': 'bg1'},
          {'speaker': 'thought', 'text': 'c'},
          {'speaker': 'narrator', 'text': 'd', 'sprite_url': ''},
        ]),
        const [],
      );

      expect(lines.map((l) => l.backgroundUrl), ['bg0', 'bg1', 'bg1', 'bg1']);
      expect(lines.map((l) => l.spriteUrl), [null, 'noah', 'noah', '']);
      expect(lines[1].speakerName, 'Ной');
      expect(lines[2].isThought, isTrue);
      expect(lines[2].speakerName, isEmpty);
    });

    test('chosen/not_chosen look only at the latest choice among the group', () {
      final script = [
        {
          'speaker': 'narrator',
          'text': 'photo',
          'when': [
            {
              'chosen': ['yes'],
              'among': ['yes', 'no', 'entry'],
            },
          ],
        },
        {
          'speaker': 'narrator',
          'text': 'no photo',
          'when': [
            {
              'not_chosen': ['yes'],
              'among': ['yes', 'no', 'entry'],
            },
          ],
        },
      ];
      List<String> texts(List<String> made) =>
          DialogueLine.resolveScript(_scene(script), made).map((l) => l.text).toList();

      expect(texts([]), ['no photo']);
      expect(texts(['entry', 'yes']), ['photo']);
      expect(texts(['entry', 'no']), ['no photo']);
      // A replay: the photo from the first playthrough no longer counts
      // once the chapter is entered again without taking one.
      expect(texts(['entry', 'yes', 'other', 'entry']), ['no photo']);
    });

    test('lines whose conditions fail do not affect sticky state', () {
      final lines = DialogueLine.resolveScript(
        _scene([
          {
            'speaker': 'narrator',
            'text': 'hidden',
            'background_url': 'bgX',
            'when': [
              {
                'chosen': ['a'],
                'among': ['a', 'b'],
              },
            ],
          },
          {'speaker': 'narrator', 'text': 'shown'},
        ]),
        const ['b'],
      );
      expect(lines.single.backgroundUrl, 'bg0');
    });
  });

  group('resolveMediaUrlsInJson', () {
    test('resolves root-relative media URLs at any depth and keeps the rest', () {
      final json = resolveMediaUrlsInJson({
        'background_url': '/media/bg.webp',
        'cover_url': 'https://cdn.example.com/c.png',
        'title': '/not/a/media/key',
        'dialogue_script': [
          {'sprite_url': '/media/s.webp'},
          {'sprite_url': ''},
        ],
      }, 'http://10.0.2.2:8080');

      expect(json, {
        'background_url': 'http://10.0.2.2:8080/media/bg.webp',
        'cover_url': 'https://cdn.example.com/c.png',
        'title': '/not/a/media/key',
        'dialogue_script': [
          {'sprite_url': 'http://10.0.2.2:8080/media/s.webp'},
          {'sprite_url': ''},
        ],
      });
    });
  });
}
