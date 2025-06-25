import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_profile.dart';
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

  Future<void> saveProfile(UserProfile profile) async {
    await _service.saveProfile(profile);
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
