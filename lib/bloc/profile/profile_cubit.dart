import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:balance_meal/models/user_profile.dart';
import 'package:balance_meal/models/weight_entry.dart';
import 'package:balance_meal/services/i_profile_service.dart';
import 'package:balance_meal/services/storage_exception.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final IProfileService _service;

  ProfileCubit(this._service) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profile = await _service.loadProfile();
      if (profile == null) {
        emit(ProfileState.initial()
            .copyWith(isLoading: false, errorMessage: 'Profil nicht gefunden'));
      } else {
        emit(state.copyWith(profile: profile, isLoading: false));
      }
    } on StorageException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Unbekannter Fehler'));
    }
  }
  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _service.saveProfile(profile);
      try {
        final weightBox = Hive.box<WeightEntry>('weightBox');
        final lastEntry =
            weightBox.isNotEmpty ? weightBox.getAt(weightBox.length - 1) : null;
        if (lastEntry == null || lastEntry.weight != profile.weight) {
          await weightBox.add(
            WeightEntry(date: DateTime.now(), weight: profile.weight),
          );
        }
      } catch (e) {
        throw StorageException('Fehler beim Speichern des Gewichts');
      }
      emit(state.copyWith(profile: profile, errorMessage: null));
    } on StorageException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Unbekannter Fehler'));
    }
  }

  void updateProfileField({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
  }) {
    final updated = state.profile.copyWith(
      name: name ?? state.profile.name,
      age: age ?? state.profile.age,
      gender: gender ?? state.profile.gender,
      height: height ?? state.profile.height,
      weight: weight ?? state.profile.weight,
      activityLevel: activityLevel ?? state.profile.activityLevel,
      goal: goal ?? state.profile.goal,
    );
    emit(state.copyWith(profile: updated));
  }
}
