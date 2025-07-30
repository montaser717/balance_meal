import 'package:balance_meal/bloc/profile/profile_cubit.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/services/i_profile_service.dart';
import 'package:balance_meal/ui/profile/profile_view.dart';
import 'package:balance_meal/common/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/hive_test_helper.dart';

class MockProfileService extends Mock implements IProfileService {}

void main() {
  late MockProfileService service;

  setUpAll(() async {
    await setUpHive();
  });

  tearDownAll(() async {
    await tearDownHive();
  });

  setUp(() {
    service = MockProfileService();
  });

  testWidgets('loads profile on start', (tester) async {
    final profile = UserProfile(
      name: 'Test',
      age: 20,
      height: 1.8,
      weight: 70,
      gender: 'maennlich',
      activityLevel: 'mittel',
      goal: 'halten',
    );
    when(() => service.loadProfile()).thenAnswer((_) async => profile);
    when(() => service.saveProfile(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => ProfileCubit(service),
          child: const ProfileView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.profile), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
  });
}
