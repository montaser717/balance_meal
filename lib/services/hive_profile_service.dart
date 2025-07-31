import 'package:hive/hive.dart';

import 'package:balance_meal/models/user_profile.dart';
import 'i_profile_service.dart';
import 'storage_exception.dart';

class HiveProfileService implements IProfileService {
  final Box<UserProfile> _box = Hive.box<UserProfile>('profileBox');

  @override
  Future<UserProfile?> loadProfile() async {
    try {
      return _box.get('profile');
    } catch (e) {
      throw StorageException('Fehler beim Laden des Profils');
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _box.put('profile', profile);
    } catch (e) {
      throw StorageException('Fehler beim Speichern des Profils');
    }
  }

  @override
  Future<void> deleteProfile() async {
    try {
      await _box.delete('profile');
    } catch (e) {
      throw StorageException('Fehler beim Löschen des Profils');
    }
  }
}
