import '../../data/dialog_repository.dart';

class EndDialogSession {
  const EndDialogSession(this._repository);

  final DialogRepository _repository;

  Future<void> call(String sessionId) {
    return _repository.endSession(sessionId);
  }
}
