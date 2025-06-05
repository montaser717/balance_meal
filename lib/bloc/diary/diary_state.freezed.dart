// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DiaryState {
  List<Meal> get meals => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DiaryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryStateCopyWith<DiaryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryStateCopyWith<$Res> {
  factory $DiaryStateCopyWith(
    DiaryState value,
    $Res Function(DiaryState) then,
  ) = _$DiaryStateCopyWithImpl<$Res, DiaryState>;
  @useResult
  $Res call({List<Meal> meals, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$DiaryStateCopyWithImpl<$Res, $Val extends DiaryState>
    implements $DiaryStateCopyWith<$Res> {
  _$DiaryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiaryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meals = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            meals:
                null == meals
                    ? _value.meals
                    : meals // ignore: cast_nullable_to_non_nullable
                        as List<Meal>,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiaryStateImplCopyWith<$Res>
    implements $DiaryStateCopyWith<$Res> {
  factory _$$DiaryStateImplCopyWith(
    _$DiaryStateImpl value,
    $Res Function(_$DiaryStateImpl) then,
  ) = __$$DiaryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Meal> meals, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$DiaryStateImplCopyWithImpl<$Res>
    extends _$DiaryStateCopyWithImpl<$Res, _$DiaryStateImpl>
    implements _$$DiaryStateImplCopyWith<$Res> {
  __$$DiaryStateImplCopyWithImpl(
    _$DiaryStateImpl _value,
    $Res Function(_$DiaryStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiaryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meals = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DiaryStateImpl(
        meals:
            null == meals
                ? _value._meals
                : meals // ignore: cast_nullable_to_non_nullable
                    as List<Meal>,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$DiaryStateImpl implements _DiaryState {
  const _$DiaryStateImpl({
    final List<Meal> meals = const [],
    this.isLoading = false,
    this.errorMessage,
  }) : _meals = meals;

  final List<Meal> _meals;
  @override
  @JsonKey()
  List<Meal> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DiaryState(meals: $meals, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryStateImpl &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_meals),
    isLoading,
    errorMessage,
  );

  /// Create a copy of DiaryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryStateImplCopyWith<_$DiaryStateImpl> get copyWith =>
      __$$DiaryStateImplCopyWithImpl<_$DiaryStateImpl>(this, _$identity);
}

abstract class _DiaryState implements DiaryState {
  const factory _DiaryState({
    final List<Meal> meals,
    final bool isLoading,
    final String? errorMessage,
  }) = _$DiaryStateImpl;

  @override
  List<Meal> get meals;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of DiaryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryStateImplCopyWith<_$DiaryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
