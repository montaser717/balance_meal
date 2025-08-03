import 'dart:math';

import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 2)
class UserProfile {
  @HiveField(0) final String name;
  @HiveField(1) final int age;
  @HiveField(2) final double height;
  @HiveField(3) final double weight;
  @HiveField(4) final String gender;
  @HiveField(5) final String activityLevel;
  @HiveField(6) final String goal;

  UserProfile({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }


}

extension UserProfileCalculations on UserProfile {
  double get bmr {
    if (gender == 'maennlich') {
      return 10 * weight + 6.25 * height * 100 - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height * 100 - 5 * age - 161;
    }
  }

  double get activityMultiplier {
    switch (activityLevel) {
      case 'gering':
        return 1.2;
      case 'mittel':
        return 1.55;
      case 'hoch':
        return 1.9;
      default:
        return 1.2;
    }
  }

  int get calorieGoal {
    int tdee = (bmr * activityMultiplier).round();
    switch (goal) {
      case 'abnehmen':
        return tdee - 400;
      case 'zunehmen':
        return tdee + 400;
      default:
        return tdee;
    }
  }

  int get proteinGoal => (weight * 2).round();
  int get fatGoal => (weight * 1).round(); // 1g Fett pro kg
  int get carbGoal {
    final kcalRest = calorieGoal - (proteinGoal * 4 + fatGoal * 9);
    return max((kcalRest / 4).round(), 0);
  }
}

