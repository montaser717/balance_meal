import 'package:balance_meal/bloc/diary/diary_cubit.dart';
import 'package:balance_meal/bloc/diary/diary_state.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/ui/diary/widget/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDiaryCubit extends Mock implements DiaryCubit {}

void main() {
  testWidgets('MealCard delete button triggers cubit', (tester) async {
    final cubit = MockDiaryCubit();
    final meal = Meal(
      id: '1',
      name: 'Meal',
      calories: 200,
      protein: 20,
      fat: 5,
      carbs: 30,
      date: DateTime.utc(2024),
    );
    when(() => cubit.state).thenReturn(const DiaryState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DiaryCubit>.value(
          value: cubit,
          child: MealCard(title: 'Meal', meal: meal),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
