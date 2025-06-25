import 'package:hive/hive.dart';

import '../models/user_profile.dart';

class HiveProfileService {
  final _box = Hive.box<UserProfile>('profileBox');

  UserProfile? loadProfile() {
    return _box.get('profile');
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _box.put('profile', profile);
  }

  void deleteProfile() {
    _box.delete('profile');
  }
}
