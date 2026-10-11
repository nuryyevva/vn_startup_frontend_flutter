import '../../stories/domain/models/story.dart';

/// One line of a scene's `dialogue_script`, resolved for playback: lines
/// whose `when` conditions don't hold are already dropped, and the
/// background/sprite in effect at this line are filled in.
///
/// Script line format (see `cmd/seed/story_graph.go` on the backend):
/// `speaker` is a character name or the sentinel `narrator`/`thought`;
/// `background_url` / `sprite_url` switch the background/character from
/// that line on (`sprite_url: ""` hides the character); `sfx_url` plays a
/// one-shot sound; `when` is a list of conditions on the player's
/// `choices_made` (see [_conditionHolds]).
class DialogueLine {
  const DialogueLine({required this.speaker, required this.text, this.sfxUrl, this.backgroundUrl, this.spriteUrl});

  static const narratorSpeaker = 'narrator';
  static const thoughtSpeaker = 'thought';

  final String speaker;
  final String text;
  final String? sfxUrl;

  /// Background in effect at this line — the scene's own unless a line at
  /// or before this one switched it.
  final String? backgroundUrl;

  /// Character sprite in effect at this line: null means "whatever the
  /// scene says" (the pre-existing single-character behaviour), an empty
  /// string means explicitly hidden.
  final String? spriteUrl;

  bool get isNarration => speaker == narratorSpeaker;
  bool get isThought => speaker == thoughtSpeaker;

  /// Name to show above the line, or empty for narration and thoughts.
  String get speakerName => (isNarration || isThought) ? '' : speaker;

  /// Resolves [scene]'s script for a player whose progress has
  /// [choicesMade] (oldest first, as returned by the backend).
  static List<DialogueLine> resolveScript(Scene scene, List<String> choicesMade) {
    var background = scene.backgroundUrl;
    var sprite = scene.characterSpriteUrl;
    final out = <DialogueLine>[];
    for (final raw in scene.dialogueScript) {
      if (raw is! Map<String, dynamic>) continue;
      final conditions = raw['when'];
      if (conditions is List && !conditions.every((c) => _conditionHolds(c, choicesMade))) {
        continue;
      }
      if (raw['background_url'] case final String url when url.isNotEmpty) background = url;
      if (raw['sprite_url'] case final String url) sprite = url;
      out.add(
        DialogueLine(
          speaker: (raw['speaker'] as String?) ?? '',
          text: (raw['text'] as String?) ?? '',
          sfxUrl: raw['sfx_url'] as String?,
          backgroundUrl: background,
          spriteUrl: sprite,
        ),
      );
    }
    return out;
  }

  /// `{"among": [...], "chosen": [...]}` / `{"among": [...], "not_chosen":
  /// [...]}`: looks only at the most recent choice in [choicesMade] that's
  /// in `among`. `choices_made` is append-only across replays, so "ever
  /// chosen" would leak earlier playthroughs into the current one.
  static bool _conditionHolds(Object? condition, List<String> choicesMade) {
    if (condition is! Map<String, dynamic>) return true;
    final among = _ids(condition['among']);
    final chosen = _ids(condition['chosen']);
    final notChosen = _ids(condition['not_chosen']);
    final pool = {...among, ...chosen, ...notChosen};

    String? latest;
    for (final id in choicesMade.reversed.map((e) => e.toLowerCase())) {
      if (pool.contains(id)) {
        latest = id;
        break;
      }
    }

    if (chosen.isNotEmpty && (latest == null || !chosen.contains(latest))) return false;
    if (notChosen.isNotEmpty && latest != null && notChosen.contains(latest)) return false;
    return true;
  }

  static Set<String> _ids(Object? raw) =>
      raw is List ? raw.whereType<String>().map((e) => e.toLowerCase()).toSet() : const {};
}
