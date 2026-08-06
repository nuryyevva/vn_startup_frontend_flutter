enum SessionEndReason { timeLimit, messageLimit, storyEvent, userLeft }

/// Maps the backend's `end_reason`/`reason` wire string (see
/// `internal/dialog/service.go`'s `EndSession`) to the typed enum. Returns
/// null for anything unrecognized rather than guessing — callers decide
/// how to handle that (e.g. treat as `userLeft`).
SessionEndReason? sessionEndReasonFromWire(String? raw) {
  switch (raw) {
    case 'time_limit':
      return SessionEndReason.timeLimit;
    case 'message_limit':
      return SessionEndReason.messageLimit;
    case 'story_event':
      return SessionEndReason.storyEvent;
    case 'user_left':
      return SessionEndReason.userLeft;
    default:
      return null;
  }
}
