import 'package:balance_meal/bloc/profile/profile_cubit.dart';
import 'package:balance_meal/models/meal.dart';
import 'package:balance_meal/services/i_profile_service.dart';
import 'package:balance_meal/ui/diary/diary_view.dart';
import 'package:balance_meal/common/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/hive_test_helper.dart';
import 'package:hive/hive.dart';

class MockProfileService extends Mock implements IProfileService {}

void main() {
  late MockProfileService profileService;

  setUpAll(() async {
    await setUpHive();
  });

  tearDownAll(() async {
    await tearDownHive();
  });

  setUp(() {
    profileService = MockProfileService();
  });

  testWidgets('shows meals from hive', (tester) async {
    final meal = Meal(
      id: '1',
      name: 'Toast',
      calories: 100,
      protein: 4,
      fat: 2,
      carbs: 15,
      date: DateTime.now(),
    );
    final mealBox = Hive.box<Meal>('meals');
    await mealBox.put(meal.id, meal);

    final cubit = ProfileCubit(profileService);
    cubit.updateProfileField();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const DiaryView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.meals), findsOneWidget);
    expect(find.text('Toast'), findsOneWidget);
  });
}
