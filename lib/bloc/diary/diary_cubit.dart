import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/meal.dart';
import '../../services/i_meal_service.dart';
import 'diary_state.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final IMealService _mealService;

  DiaryCubit(this._mealService) : super(const DiaryState());

  Future<void> loadMeals() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final meals = await _mealService.loadMeals();
      emit(state.copyWith(meals: meals, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> addMeal(Meal meal) async {
    await _mealService.addMeal(meal);
    await loadMeals(); // nach dem Hinzufügen neu laden
  }

  Future<void> deleteMeal(String id) async {
    await _mealService.deleteMeal(id);
    await loadMeals(); // nach dem Löschen neu laden
  }
}
