import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/services/i_meal_service.dart';
import 'package:balance_meal/services/storage_exception.dart';
import 'diary_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final IMealService _mealService;

  DiaryCubit(this._mealService) : super(const DiaryState());

  Future<void> loadMeals({bool showLoading = true}) async {
    if (showLoading) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }
    try {
      final meals = await _mealService.loadMeals();
      emit(state.copyWith(meals: meals, isLoading: false));
    } on StorageException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Unbekannter Fehler'));
    }
  }

  Future<void> addMeal(Meal meal) async {
    final isNew = meal.id.isEmpty;
    final mealWithId = isNew ? meal.copyWith(id: const Uuid().v4()) : meal;

    try {
      if (!isNew) {
        await _mealService.deleteMeal(meal.id);
      }

      await _mealService.addMeal(mealWithId);
    } on StorageException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
      return;
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Unbekannter Fehler'));
      return;
    }

    final existing = state.meals.any((m) => m.id == mealWithId.id);
    final updatedMeals = existing
        ? state.meals.map((m) => m.id == mealWithId.id ? mealWithId : m).toList()
        : [...state.meals, mealWithId];

    emit(state.copyWith(meals: updatedMeals));
  }

  Future<void> deleteMeal(String id) async {
    try {
      await _mealService.deleteMeal(id);
      await loadMeals();
    } on StorageException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Unbekannter Fehler'));
    }
  }

  Future<void> updateMeal(Meal meal) async {
    try {
      await _mealService.updateMeal(meal);
      await loadMeals(showLoading: false);
    } on StorageException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Unbekannter Fehler'));
    }
  }

  Future<void> resetIfNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpenedStr = prefs.getString('lastOpenedDate');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastOpenedStr != null) {
      final lastOpened = DateTime.parse(lastOpenedStr);
      final lastDate = DateTime(lastOpened.year, lastOpened.month, lastOpened.day);

      if (today.isAfter(lastDate)) {
        await _mealService.clearAllMeals();
        emit(state.copyWith(meals: []));
      }
    }

    await prefs.setString('lastOpenedDate', today.toIso8601String());
    await loadMeals(showLoading: false);
  }

  Future<void> resetDay() async {
    await _mealService.clearAllMeals();
    emit(state.copyWith(meals: []));
  }



}
