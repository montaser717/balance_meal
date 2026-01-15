import "package:balance_meal/models/user_profile.dart";

abstract class IProfileService {
  Future<UserProfile?> loadProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> deleteProfile();
}
