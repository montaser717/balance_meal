// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  calories: (json['calories'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'calories': instance.calories,
      'date': instance.date.toIso8601String(),
    };
