import 'package:balance_meal/bloc/profile/profile_cubit.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/models/weight_entry.dart';
import 'package:balance_meal/services/i_profile_service.dart';
import 'package:balance_meal/services/storage_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import '../helpers/hive_test_helper.dart';

class MockProfileService extends Mock implements IProfileService {}

void main() {
  late MockProfileService service;
  late ProfileCubit cubit;

  setUpAll(() async {
    await setUpHive();
  });

  tearDownAll(() async {
    await tearDownHive();
  });

  setUp(() {
    service = MockProfileService();
    cubit = ProfileCubit(service);
  });

  group('loadProfile', () {
    test('loads profile if available', () async {
      final profile = UserProfile(
        name: 'Max',
        age: 30,
        height: 1.8,
        weight: 80,
        gender: 'maennlich',
        activityLevel: 'mittel',
        goal: 'halten',
      );
      when(() => service.loadProfile()).thenAnswer((_) async => profile);

      await cubit.loadProfile();

      expect(cubit.state.profile.name, 'Max');
      expect(cubit.state.errorMessage, isNull);
      verify(() => service.loadProfile()).called(1);
    });

    test('emits error when profile not found', () async {
      when(() => service.loadProfile()).thenAnswer((_) async => null);
      await cubit.loadProfile();
      expect(cubit.state.errorMessage, isNotNull);
    });
  });

  test('saveProfile stores weight entry and calls service', () async {
    final profile = UserProfile(
      name: 'Anna',
      age: 25,
      height: 1.7,
      weight: 60,
      gender: 'weiblich',
      activityLevel: 'mittel',
      goal: 'halten',
    );
    when(() => service.saveProfile(profile)).thenAnswer((_) async {});

    await cubit.saveProfile(profile);

    final box = Hive.box<WeightEntry>('weightBox');
    expect(box.isNotEmpty, true);
    verify(() => service.saveProfile(profile)).called(1);
  });

  test('updateProfileField changes profile values', () {
    cubit.updateProfileField(name: 'Tom', age: 40);
    expect(cubit.state.profile.name, 'Tom');
    expect(cubit.state.profile.age, 40);
  });
}
