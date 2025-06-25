import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/meal.dart';
import '../../services/i_meal_service.dart';
import 'diary_state.dart';

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
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> addMeal(Meal meal) async {
    final isNew = meal.id.isEmpty;
    final mealWithId = isNew ? meal.copyWith(id: const Uuid().v4()) : meal;

    if (!isNew) {
      await _mealService.deleteMeal(meal.id);
    }

    await _mealService.addMeal(mealWithId);

    final existing = state.meals.any((m) => m.id == mealWithId.id);
    final updatedMeals = existing
        ? state.meals.map((m) => m.id == mealWithId.id ? mealWithId : m).toList()
        : [...state.meals, mealWithId];

    emit(state.copyWith(meals: updatedMeals));
  }

  Future<void> deleteMeal(String id) async {
    await _mealService.deleteMeal(id);
    await loadMeals();
  }

  Future<void> updateMeal(Meal meal) async {
    await _mealService.updateMeal(meal);
    await loadMeals(showLoading: false);
  }

}
