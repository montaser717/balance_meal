import '../../models/user_profile.dart';

class ProfileState {
  final UserProfile profile;
  final bool isSaving;

  ProfileState({
    required this.profile,
    this.isSaving = false,
  });

  ProfileState copyWith({
    UserProfile? profile,
    bool? isSaving,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
