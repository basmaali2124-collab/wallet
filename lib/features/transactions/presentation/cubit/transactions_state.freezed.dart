// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsState {

 TransactionsStatus get status; List<TransactionModel> get all; DateTime get date; TransactionType? get filter; TransactionCategory? get category; String? get error;
/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsStateCopyWith<TransactionsState> get copyWith => _$TransactionsStateCopyWithImpl<TransactionsState>(this as TransactionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.all, all)&&(identical(other.date, date) || other.date == date)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.category, category) || other.category == category)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(all),date,filter,category,error);

@override
String toString() {
  return 'TransactionsState(status: $status, all: $all, date: $date, filter: $filter, category: $category, error: $error)';
}


}

/// @nodoc
abstract mixin class $TransactionsStateCopyWith<$Res>  {
  factory $TransactionsStateCopyWith(TransactionsState value, $Res Function(TransactionsState) _then) = _$TransactionsStateCopyWithImpl;
@useResult
$Res call({
 TransactionsStatus status, List<TransactionModel> all, DateTime date, TransactionType? filter, TransactionCategory? category, String? error
});




}
/// @nodoc
class _$TransactionsStateCopyWithImpl<$Res>
    implements $TransactionsStateCopyWith<$Res> {
  _$TransactionsStateCopyWithImpl(this._self, this._then);

  final TransactionsState _self;
  final $Res Function(TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? all = null,Object? date = null,Object? filter = freezed,Object? category = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionsStatus,all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TransactionType?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionsState].
extension TransactionsStatePatterns on TransactionsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionsStatus status,  List<TransactionModel> all,  DateTime date,  TransactionType? filter,  TransactionCategory? category,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.status,_that.all,_that.date,_that.filter,_that.category,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionsStatus status,  List<TransactionModel> all,  DateTime date,  TransactionType? filter,  TransactionCategory? category,  String? error)  $default,) {final _that = this;
switch (_that) {
case _TransactionsState():
return $default(_that.status,_that.all,_that.date,_that.filter,_that.category,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionsStatus status,  List<TransactionModel> all,  DateTime date,  TransactionType? filter,  TransactionCategory? category,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _TransactionsState() when $default != null:
return $default(_that.status,_that.all,_that.date,_that.filter,_that.category,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionsState extends TransactionsState {
  const _TransactionsState({this.status = TransactionsStatus.loading, final  List<TransactionModel> all = const <TransactionModel>[], required this.date, this.filter, this.category, this.error}): _all = all,super._();
  

@override@JsonKey() final  TransactionsStatus status;
 final  List<TransactionModel> _all;
@override@JsonKey() List<TransactionModel> get all {
  if (_all is EqualUnmodifiableListView) return _all;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_all);
}

@override final  DateTime date;
@override final  TransactionType? filter;
@override final  TransactionCategory? category;
@override final  String? error;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsStateCopyWith<_TransactionsState> get copyWith => __$TransactionsStateCopyWithImpl<_TransactionsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._all, _all)&&(identical(other.date, date) || other.date == date)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.category, category) || other.category == category)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_all),date,filter,category,error);

@override
String toString() {
  return 'TransactionsState(status: $status, all: $all, date: $date, filter: $filter, category: $category, error: $error)';
}


}

/// @nodoc
abstract mixin class _$TransactionsStateCopyWith<$Res> implements $TransactionsStateCopyWith<$Res> {
  factory _$TransactionsStateCopyWith(_TransactionsState value, $Res Function(_TransactionsState) _then) = __$TransactionsStateCopyWithImpl;
@override @useResult
$Res call({
 TransactionsStatus status, List<TransactionModel> all, DateTime date, TransactionType? filter, TransactionCategory? category, String? error
});




}
/// @nodoc
class __$TransactionsStateCopyWithImpl<$Res>
    implements _$TransactionsStateCopyWith<$Res> {
  __$TransactionsStateCopyWithImpl(this._self, this._then);

  final _TransactionsState _self;
  final $Res Function(_TransactionsState) _then;

/// Create a copy of TransactionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? all = null,Object? date = null,Object? filter = freezed,Object? category = freezed,Object? error = freezed,}) {
  return _then(_TransactionsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionsStatus,all: null == all ? _self._all : all // ignore: cast_nullable_to_non_nullable
as List<TransactionModel>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TransactionType?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
