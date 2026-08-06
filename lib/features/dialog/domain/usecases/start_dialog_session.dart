import '../../data/dialog_repository.dart';
import '../models/dialog_session.dart';

class StartDialogSession {
  const StartDialogSession(this._repository);

  final DialogRepository _repository;

  Future<DialogSession> call(String characterId, String sceneId) {
    return _repository.startSession(characterId, sceneId);
  }
}
