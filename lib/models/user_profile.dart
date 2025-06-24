import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum Gender { maennlich, weiblich, divers }
enum Goal { abnehmen, zunehmen, halten }
enum ActivityLevel { niedrig, mittel, hoch }

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String name,
    @Default(0) int age,
    @Default(0.0) double height,
    @Default(0.0) double weight,
    @Default(Gender.maennlich) Gender gender,
    @Default(Goal.halten) Goal goal,
    @Default(ActivityLevel.mittel) ActivityLevel activityLevel,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileCalculation on UserProfile {
  double get bmr {
    final base = 10 * weight + 6.25 * height - 5 * age;
    return gender == Gender.weiblich ? base - 161 : base + 5;
  }

  double get activityFactor {
    switch (activityLevel) {
      case ActivityLevel.niedrig:
        return 1.2;
      case ActivityLevel.mittel:
        return 1.55;
      case ActivityLevel.hoch:
        return 1.9;
    }
  }

  double get goalFactor {
    switch (goal) {
      case Goal.abnehmen:
        return 0.85;
      case Goal.zunehmen:
        return 1.15;
      case Goal.halten:
        return 1.0;
    }
  }

  double get dailyCalorieTarget => bmr * activityFactor * goalFactor;
}
