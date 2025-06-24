import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_profile.dart';
import 'profile_state.dart';
import '../../services/profile_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _service = ProfileService();

  ProfileCubit() : super(ProfileState(profile: const UserProfile())){
    loadProfile();
  }


  Future<UserProfile> loadProfile() async {
    final loaded = await _service.loadProfile();
    final result = loaded ?? const UserProfile();
    emit(state.copyWith(profile: result));
    return result;
  }


  Future<bool> saveProfile() async {
    emit(state.copyWith(isSaving: true));
    final success = await _service.saveProfile(state.profile);
    emit(state.copyWith(isSaving: false));
    return success;
  }


  UserProfile updateName(String name) {
    final updated = state.profile.copyWith(name: name);
    emit(state.copyWith(profile: updated));
    return updated;
  }

  UserProfile updateAge(int age) {
    final updated = state.profile.copyWith(age: age);
    emit(state.copyWith(profile: updated));
    return updated;
  }

  UserProfile updateHeight(double height) {
    final updated = state.profile.copyWith(height: height);
    emit(state.copyWith(profile: updated));
    return updated;
  }

  UserProfile updateWeight(double weight) {
    final updated = state.profile.copyWith(weight: weight);
    emit(state.copyWith(profile: updated));
    return updated;
  }

  UserProfile? updateGender(Gender? gender) {
    if (gender == null) return null;
    final updated = state.profile.copyWith(gender: gender);
    emit(state.copyWith(profile: updated));
    return updated;
  }

  UserProfile? updateGoal(Goal? goal) {
    if (goal == null) return null;
    final updated = state.profile.copyWith(goal: goal);
    emit(state.copyWith(profile: updated));
    return updated;
  }

  UserProfile? updateActivityLevel(ActivityLevel? level) {
    if (level == null) return null;
    final updated = state.profile.copyWith(activityLevel: level);
    emit(state.copyWith(profile: updated));
    return updated;
  }

}
