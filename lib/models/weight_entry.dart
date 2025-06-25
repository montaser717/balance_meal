import 'package:hive/hive.dart';

part 'weight_entry.g.dart';

@HiveType(typeId: 3)
class WeightEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double weight;

  WeightEntry({required this.date, required this.weight});
}
