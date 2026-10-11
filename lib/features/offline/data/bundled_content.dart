import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/media/media_source.dart';
import '../../stories/domain/models/story.dart';

/// The stories shipped inside the app for the offline build: parsed from
/// `assets/content/content.json`, which the backend's seed command writes
/// (`make export-content`) in the same shape as its API responses — so this
/// reuses the API models, and the two sources can't drift apart.
class BundledContent {
  BundledContent._(this.stories, this._scenesByStory, this._scenes, this._sceneOfChoice, this._choices);

  static const _root = 'assets/content';

  /// Catalog order: newest first, like `GET /stories`.
  final List<Story> stories;
  final Map<String, List<Scene>> _scenesByStory;
  final Map<String, Scene> _scenes;
  final Map<String, Scene> _sceneOfChoice;
  final Map<String, BundledChoice> _choices;

  static Future<BundledContent> load([AssetBundle? bundle]) async {
    final raw = await (bundle ?? rootBundle).loadString('$_root/content.json');
    return BundledContent.parse(jsonDecode(raw) as Map<String, dynamic>);
  }

  factory BundledContent.parse(Map<String, dynamic> json) {
    final stories = <Story>[];
    final scenesByStory = <String, List<Scene>>{};
    final scenes = <String, Scene>{};
    final sceneOfChoice = <String, Scene>{};
    final choices = <String, BundledChoice>{};

    for (final rawStory in (json['stories'] as List).cast<Map<String, dynamic>>()) {
      final story = Story.fromJson(_withBundledMedia(rawStory) as Map<String, dynamic>);
      stories.add(story);

      final storyScenes = <Scene>[];
      for (final rawScene in (rawStory['scenes'] as List).cast<Map<String, dynamic>>()) {
        // Free dialogue is a conversation with an AI character run by the
        // server — there's nothing to talk to offline.
        final scene = Scene.fromJson({
          ..._withBundledMedia(rawScene) as Map<String, dynamic>,
          'free_dialog_enabled': false,
        });
        storyScenes.add(scene);
        scenes[scene.id] = scene;
        for (final rawChoice in (rawScene['choices'] as List).cast<Map<String, dynamic>>()) {
          final id = rawChoice['id'] as String;
          sceneOfChoice[id] = scene;
          choices[id] = BundledChoice(
            choice: scene.choices.firstWhere((c) => c.id == id),
            onceKey: rawChoice['once_key'] as String?,
          );
        }
      }
      storyScenes.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      scenesByStory[story.id] = storyScenes;
    }

    stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return BundledContent._(stories, scenesByStory, scenes, sceneOfChoice, choices);
  }

  Story? story(String id) => stories.where((s) => s.id == id).firstOrNull;

  /// A story's scenes in reading order (by `order_index`).
  List<Scene> scenesOf(String storyId) => _scenesByStory[storyId] ?? const [];

  Scene? scene(String id) => _scenes[id];

  /// The scene a choice is offered on.
  Scene? sceneOfChoice(String choiceId) => _sceneOfChoice[choiceId];

  BundledChoice? choice(String id) => _choices[id];

  /// Rewrites the bundle's root-relative media URLs (`/media/...`) into
  /// `asset:` URLs, at any depth — same keys the API client resolves.
  static Object? _withBundledMedia(Object? json) {
    if (json is Map<String, dynamic>) {
      return json.map((key, value) {
        if (value is String && _mediaKeys.contains(key) && value.startsWith('/')) {
          return MapEntry(key, bundledMediaUrl('$_root$value'));
        }
        return MapEntry(key, _withBundledMedia(value));
      });
    }
    if (json is List) return json.map(_withBundledMedia).toList();
    return json;
  }

  static const _mediaKeys = {
    'cover_url',
    'background_url',
    'character_sprite_url',
    'background_music_url',
    'sprite_url',
    'sfx_url',
  };
}

/// A choice plus the one field the API keeps server-side: its `once_key`
/// (see the backend's `internal/story/one_time_choices.go`).
class BundledChoice {
  const BundledChoice({required this.choice, this.onceKey});

  final Choice choice;
  final String? onceKey;
}
