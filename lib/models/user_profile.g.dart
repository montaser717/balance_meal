// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      name: json['name'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']) ??
          Gender.maennlich,
      goal: $enumDecodeNullable(_$GoalEnumMap, json['goal']) ?? Goal.halten,
      activityLevel:
          $enumDecodeNullable(_$ActivityLevelEnumMap, json['activityLevel']) ??
              ActivityLevel.mittel,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'gender': _$GenderEnumMap[instance.gender]!,
      'goal': _$GoalEnumMap[instance.goal]!,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
    };

const _$GenderEnumMap = {
  Gender.maennlich: 'maennlich',
  Gender.weiblich: 'weiblich',
  Gender.divers: 'divers',
};

const _$GoalEnumMap = {
  Goal.abnehmen: 'abnehmen',
  Goal.zunehmen: 'zunehmen',
  Goal.halten: 'halten',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.niedrig: 'niedrig',
  ActivityLevel.mittel: 'mittel',
  ActivityLevel.hoch: 'hoch',
};
