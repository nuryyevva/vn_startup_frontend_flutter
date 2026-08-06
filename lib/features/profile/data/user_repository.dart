import '../domain/models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> getMe();
  Future<UserProfile> updateMe(UpdateProfileRequest request);
}
