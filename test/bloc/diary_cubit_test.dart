import 'package:balance_meal/bloc/diary/diary_cubit.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/services/i_meal_service.dart';
import 'package:balance_meal/services/storage_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMealService extends Mock implements IMealService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Meal(
      id: 'dummy',
      name: '',
      calories: 0,
      protein: 0,
      fat: 0,
      carbs: 0,
      date: DateTime(2024),
    ));
  });

  group('DiaryCubit', () {
    late DiaryCubit cubit;
    late MockMealService service;

    setUp(() {
      service = MockMealService();
      cubit = DiaryCubit(service);
    });

    test('loads meals successfully', () async {
      when(() => service.loadMeals()).thenAnswer((_) async => [
            Meal(
              id: '1',
              name: 'Test',
              calories: 100,
              protein: 10,
              fat: 2,
              carbs: 20,
              date: DateTime(2024, 1, 1),
            )
          ]);

      await cubit.loadMeals();
      expect(cubit.state.meals, hasLength(1));
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNull);
    });

    test('emits error when service fails', () async {
      when(() => service.loadMeals()).thenThrow(StorageException('fail'));
      await cubit.loadMeals();
      expect(cubit.state.errorMessage, 'fail');
    });

    test('addMeal adds meal to state', () async {
      final meal = Meal(
        id: '',
        name: 'm',
        calories: 100,
        protein: 10,
        fat: 2,
        carbs: 20,
        date: DateTime(2024),
      );
      when(() => service.addMeal(any())).thenAnswer((_) async {});

      await cubit.addMeal(meal);
      expect(cubit.state.meals, isNotEmpty);
    });
  });
}
