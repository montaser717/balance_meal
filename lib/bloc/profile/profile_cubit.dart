import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/user_profile.dart';
import '../../models/weight_entry.dart';
import '../../services/hive_profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final HiveProfileService _service;

  ProfileCubit(this._service) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    final profile = await _service.loadProfile();
    emit(state.copyWith(profile: profile!, isLoading: false));
  }
  final weightEntries = [
    WeightEntry(date: DateTime.now().subtract(Duration(days: 2)), weight: 80),
    WeightEntry(date: DateTime.now(), weight: 78),
  ];
  Future<void> saveProfile(UserProfile profile) async {
    await _service.saveProfile(profile);
    final weightBox = Hive.box<WeightEntry>('weightBox');
   // await weightBox.add(WeightEntry(date: DateTime.now(), weight: profile.weight));
    final now = DateTime.now();
    await weightBox.addAll([
      WeightEntry(date: now.subtract(Duration(days: 6)), weight: 82.5),
      WeightEntry(date: now.subtract(Duration(days: 5)), weight: 81.2),
      WeightEntry(date: now.subtract(Duration(days: 4)), weight: 80.9),
      WeightEntry(date: now.subtract(Duration(days: 3)), weight: 80.3),
      WeightEntry(date: now.subtract(Duration(days: 2)), weight: 79.8),
      WeightEntry(date: now.subtract(Duration(days: 1)), weight: 79.2),
      WeightEntry(date: now, weight: 78.9),
    ]);
    emit(state.copyWith(profile: profile));
  }

  void updateProfileField({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
  }) {
    final updated = state.profile.copyWith(
      name: name ?? state.profile.name,
      age: age ?? state.profile.age,
      gender: gender ?? state.profile.gender,
      height: height ?? state.profile.height,
      weight: weight ?? state.profile.weight,
      activityLevel: activityLevel ?? state.profile.activityLevel,
      goal: goal ?? state.profile.goal,
    );
    emit(state.copyWith(profile: updated));
  }
}
