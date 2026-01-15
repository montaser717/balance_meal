import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:balance_meal/models/user_profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    required UserProfile profile,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ProfileState;

  factory ProfileState.initial() => ProfileState(
    profile: UserProfile(
      name: '',
      age: 0,
      gender: 'maennlich',
      height: 1.75,
      weight: 70,
      activityLevel: 'mittel',
      goal: 'halten',
    ),
  );
}
