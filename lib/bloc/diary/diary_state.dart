import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/meal.dart';

part 'diary_state.freezed.dart';

@freezed
class DiaryState with _$DiaryState {
  const factory DiaryState({
    @Default([]) List<Meal> meals,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _DiaryState;
}
