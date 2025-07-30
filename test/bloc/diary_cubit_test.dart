import 'package:balance_meal/bloc/diary/diary_cubit.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/services/i_meal_service.dart';
import 'package:balance_meal/services/storage_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMealService extends Mock implements IMealService {}

void main() {
  late MockMealService service;
  late DiaryCubit cubit;

  setUp(() {
    service = MockMealService();
    cubit = DiaryCubit(service);
  });

  group('loadMeals', () {
    test('emits meals on success', () async {
      final meals = [
        Meal(
          id: '1',
          name: 'Test',
          calories: 100,
          protein: 10,
          fat: 5,
          carbs: 20,
          date: DateTime(2024, 1, 1),
        )
      ];
      when(() => service.loadMeals()).thenAnswer((_) async => meals);

      await cubit.loadMeals();

      expect(cubit.state.meals, meals);
      expect(cubit.state.isLoading, false);
      expect(cubit.state.errorMessage, isNull);
      verify(() => service.loadMeals()).called(1);
    });

    test('emits error on failure', () async {
      when(() => service.loadMeals()).thenThrow(StorageException('fail'));

      await cubit.loadMeals();

      expect(cubit.state.meals, isEmpty);
      expect(cubit.state.isLoading, false);
      expect(cubit.state.errorMessage, isNotNull);
    });
  });

  test('addMeal adds meal to state', () async {
    final meal = Meal(
      id: '',
      name: 'New',
      calories: 50,
      protein: 5,
      fat: 2,
      carbs: 8,
      date: DateTime.now(),
    );
    when(() => service.addMeal(any())).thenAnswer((_) async {});
    when(() => service.deleteMeal(any())).thenAnswer((_) async {});

    await cubit.addMeal(meal);

    expect(cubit.state.meals.length, 1);
    expect(cubit.state.meals.first.name, 'New');
    verify(() => service.addMeal(any())).called(1);
  });
}
