import 'package:balance_meal/services/hive_profile_service.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/weight_entry.dart';

class WeightService {
  final String _boxName = 'weightsBox'; //
  final HiveProfileService _profileService;

  WeightService(this._profileService);
  Future<void> addOrUpdateEntry(WeightEntry entry) async {
    final box = await Hive.openBox<WeightEntry>(_boxName);

    final normalizedDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
    await box.put(normalizedDate.toIso8601String(), entry);

    final now = DateTime.now();
    final isToday = normalizedDate.year == now.year &&
        normalizedDate.month == now.month &&
        normalizedDate.day == now.day;

    if (isToday) {
      final profile = await _profileService.loadProfile();
      if (profile != null) {
        await _profileService.saveProfile(profile.copyWith(weight: entry.weight));
      }
    }
  }

  Future<List<Map<String, dynamic>>> loadWeightsFilled({int days = 360}) async {
    final box = await Hive.openBox<WeightEntry>(_boxName);
    final now = DateTime.now();
    final from = now.subtract(Duration(days: days - 1));
    final keyFormat = DateFormat('yyyy-MM-dd');

    final Map<String, double> rawWeights = {};

    for (final key in box.keys) {
      final entry = box.get(key);
      if (entry != null) {
        final dateKey = keyFormat.format(entry.date);
        rawWeights[dateKey] = entry.weight;
      }
    }

    List<Map<String, dynamic>> result = [];
    double? lastWeight;

    for (int i = 0; i < days; i++) {
      final date = from.add(Duration(days: i));
      final key = keyFormat.format(date);

      if (rawWeights.containsKey(key)) {
        lastWeight = rawWeights[key];
      }

      if (lastWeight != null) {
        result.add({
          'date': date,
          'weight': lastWeight,
        });
      }
    }

    return result;
  }

  Future<List<WeightEntry>> getAllEntries() async {
    final box = await Hive.openBox<WeightEntry>(_boxName);
    return box.values.toList();
  }

  Future<List<Map<String, dynamic>>> loadWeights() async {
    final entries = await getAllEntries();
    return entries
        .map((e) => {'date': e.date, 'weight': e.weight})
        .toList();
  }

  Future<void> deleteEntry(DateTime date) async {
    final box = await Hive.openBox<WeightEntry>(_boxName);

    final normalizedDate = DateTime(date.year, date.month, date.day);
    await box.delete(normalizedDate.toIso8601String());
  }

  Future<void> deleteOldEntries() async {
    final box = await Hive.openBox<WeightEntry>(_boxName);
    final now = DateTime.now();
    final toDelete = box.keys.where((key) {
      final entry = box.get(key);
      return entry != null && entry.date.isBefore(now.subtract(const Duration(days: 365)));
    }).toList();

    for (var key in toDelete) {
      await box.delete(key);
    }
  }
}
