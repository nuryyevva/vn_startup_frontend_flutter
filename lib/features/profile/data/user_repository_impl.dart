import '../domain/models/user_profile.dart';
import 'user_api.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserApi api}) : _api = api;

  final UserApi _api;

  @override
  Future<UserProfile> getMe() => _api.getMe();

  @override
  Future<UserProfile> updateMe(UpdateProfileRequest request) => _api.updateMe(request);
}
