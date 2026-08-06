import '../../data/dialog_repository.dart';
import '../models/dialog_message.dart';

class SendDialogMessage {
  const SendDialogMessage(this._repository);

  final DialogRepository _repository;

  Future<DialogMessage> call(String sessionId, String text) {
    return _repository.sendMessage(sessionId, text);
  }
}
