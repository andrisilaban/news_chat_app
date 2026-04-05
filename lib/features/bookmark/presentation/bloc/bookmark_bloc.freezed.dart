// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookmarkEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadBookmarks,
    required TResult Function(String category, Article article) addBookmark,
    required TResult Function(String url) removeBookmark,
    required TResult Function(String url) checkStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadBookmarks,
    TResult? Function(String category, Article article)? addBookmark,
    TResult? Function(String url)? removeBookmark,
    TResult? Function(String url)? checkStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadBookmarks,
    TResult Function(String category, Article article)? addBookmark,
    TResult Function(String url)? removeBookmark,
    TResult Function(String url)? checkStatus,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadBookmarks value) loadBookmarks,
    required TResult Function(_AddBookmark value) addBookmark,
    required TResult Function(_RemoveBookmark value) removeBookmark,
    required TResult Function(_CheckStatus value) checkStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadBookmarks value)? loadBookmarks,
    TResult? Function(_AddBookmark value)? addBookmark,
    TResult? Function(_RemoveBookmark value)? removeBookmark,
    TResult? Function(_CheckStatus value)? checkStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadBookmarks value)? loadBookmarks,
    TResult Function(_AddBookmark value)? addBookmark,
    TResult Function(_RemoveBookmark value)? removeBookmark,
    TResult Function(_CheckStatus value)? checkStatus,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkEventCopyWith<$Res> {
  factory $BookmarkEventCopyWith(
    BookmarkEvent value,
    $Res Function(BookmarkEvent) then,
  ) = _$BookmarkEventCopyWithImpl<$Res, BookmarkEvent>;
}

/// @nodoc
class _$BookmarkEventCopyWithImpl<$Res, $Val extends BookmarkEvent>
    implements $BookmarkEventCopyWith<$Res> {
  _$BookmarkEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadBookmarksImplCopyWith<$Res> {
  factory _$$LoadBookmarksImplCopyWith(
    _$LoadBookmarksImpl value,
    $Res Function(_$LoadBookmarksImpl) then,
  ) = __$$LoadBookmarksImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadBookmarksImplCopyWithImpl<$Res>
    extends _$BookmarkEventCopyWithImpl<$Res, _$LoadBookmarksImpl>
    implements _$$LoadBookmarksImplCopyWith<$Res> {
  __$$LoadBookmarksImplCopyWithImpl(
    _$LoadBookmarksImpl _value,
    $Res Function(_$LoadBookmarksImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadBookmarksImpl implements _LoadBookmarks {
  const _$LoadBookmarksImpl();

  @override
  String toString() {
    return 'BookmarkEvent.loadBookmarks()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadBookmarksImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadBookmarks,
    required TResult Function(String category, Article article) addBookmark,
    required TResult Function(String url) removeBookmark,
    required TResult Function(String url) checkStatus,
  }) {
    return loadBookmarks();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadBookmarks,
    TResult? Function(String category, Article article)? addBookmark,
    TResult? Function(String url)? removeBookmark,
    TResult? Function(String url)? checkStatus,
  }) {
    return loadBookmarks?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadBookmarks,
    TResult Function(String category, Article article)? addBookmark,
    TResult Function(String url)? removeBookmark,
    TResult Function(String url)? checkStatus,
    required TResult orElse(),
  }) {
    if (loadBookmarks != null) {
      return loadBookmarks();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadBookmarks value) loadBookmarks,
    required TResult Function(_AddBookmark value) addBookmark,
    required TResult Function(_RemoveBookmark value) removeBookmark,
    required TResult Function(_CheckStatus value) checkStatus,
  }) {
    return loadBookmarks(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadBookmarks value)? loadBookmarks,
    TResult? Function(_AddBookmark value)? addBookmark,
    TResult? Function(_RemoveBookmark value)? removeBookmark,
    TResult? Function(_CheckStatus value)? checkStatus,
  }) {
    return loadBookmarks?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadBookmarks value)? loadBookmarks,
    TResult Function(_AddBookmark value)? addBookmark,
    TResult Function(_RemoveBookmark value)? removeBookmark,
    TResult Function(_CheckStatus value)? checkStatus,
    required TResult orElse(),
  }) {
    if (loadBookmarks != null) {
      return loadBookmarks(this);
    }
    return orElse();
  }
}

abstract class _LoadBookmarks implements BookmarkEvent {
  const factory _LoadBookmarks() = _$LoadBookmarksImpl;
}

/// @nodoc
abstract class _$$AddBookmarkImplCopyWith<$Res> {
  factory _$$AddBookmarkImplCopyWith(
    _$AddBookmarkImpl value,
    $Res Function(_$AddBookmarkImpl) then,
  ) = __$$AddBookmarkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String category, Article article});
}

/// @nodoc
class __$$AddBookmarkImplCopyWithImpl<$Res>
    extends _$BookmarkEventCopyWithImpl<$Res, _$AddBookmarkImpl>
    implements _$$AddBookmarkImplCopyWith<$Res> {
  __$$AddBookmarkImplCopyWithImpl(
    _$AddBookmarkImpl _value,
    $Res Function(_$AddBookmarkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? article = null}) {
    return _then(
      _$AddBookmarkImpl(
        null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        null == article
            ? _value.article
            : article // ignore: cast_nullable_to_non_nullable
                  as Article,
      ),
    );
  }
}

/// @nodoc

class _$AddBookmarkImpl implements _AddBookmark {
  const _$AddBookmarkImpl(this.category, this.article);

  @override
  final String category;
  @override
  final Article article;

  @override
  String toString() {
    return 'BookmarkEvent.addBookmark(category: $category, article: $article)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddBookmarkImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.article, article) || other.article == article));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, article);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddBookmarkImplCopyWith<_$AddBookmarkImpl> get copyWith =>
      __$$AddBookmarkImplCopyWithImpl<_$AddBookmarkImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadBookmarks,
    required TResult Function(String category, Article article) addBookmark,
    required TResult Function(String url) removeBookmark,
    required TResult Function(String url) checkStatus,
  }) {
    return addBookmark(category, article);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadBookmarks,
    TResult? Function(String category, Article article)? addBookmark,
    TResult? Function(String url)? removeBookmark,
    TResult? Function(String url)? checkStatus,
  }) {
    return addBookmark?.call(category, article);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadBookmarks,
    TResult Function(String category, Article article)? addBookmark,
    TResult Function(String url)? removeBookmark,
    TResult Function(String url)? checkStatus,
    required TResult orElse(),
  }) {
    if (addBookmark != null) {
      return addBookmark(category, article);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadBookmarks value) loadBookmarks,
    required TResult Function(_AddBookmark value) addBookmark,
    required TResult Function(_RemoveBookmark value) removeBookmark,
    required TResult Function(_CheckStatus value) checkStatus,
  }) {
    return addBookmark(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadBookmarks value)? loadBookmarks,
    TResult? Function(_AddBookmark value)? addBookmark,
    TResult? Function(_RemoveBookmark value)? removeBookmark,
    TResult? Function(_CheckStatus value)? checkStatus,
  }) {
    return addBookmark?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadBookmarks value)? loadBookmarks,
    TResult Function(_AddBookmark value)? addBookmark,
    TResult Function(_RemoveBookmark value)? removeBookmark,
    TResult Function(_CheckStatus value)? checkStatus,
    required TResult orElse(),
  }) {
    if (addBookmark != null) {
      return addBookmark(this);
    }
    return orElse();
  }
}

abstract class _AddBookmark implements BookmarkEvent {
  const factory _AddBookmark(final String category, final Article article) =
      _$AddBookmarkImpl;

  String get category;
  Article get article;

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddBookmarkImplCopyWith<_$AddBookmarkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RemoveBookmarkImplCopyWith<$Res> {
  factory _$$RemoveBookmarkImplCopyWith(
    _$RemoveBookmarkImpl value,
    $Res Function(_$RemoveBookmarkImpl) then,
  ) = __$$RemoveBookmarkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String url});
}

/// @nodoc
class __$$RemoveBookmarkImplCopyWithImpl<$Res>
    extends _$BookmarkEventCopyWithImpl<$Res, _$RemoveBookmarkImpl>
    implements _$$RemoveBookmarkImplCopyWith<$Res> {
  __$$RemoveBookmarkImplCopyWithImpl(
    _$RemoveBookmarkImpl _value,
    $Res Function(_$RemoveBookmarkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null}) {
    return _then(
      _$RemoveBookmarkImpl(
        null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RemoveBookmarkImpl implements _RemoveBookmark {
  const _$RemoveBookmarkImpl(this.url);

  @override
  final String url;

  @override
  String toString() {
    return 'BookmarkEvent.removeBookmark(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveBookmarkImpl &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveBookmarkImplCopyWith<_$RemoveBookmarkImpl> get copyWith =>
      __$$RemoveBookmarkImplCopyWithImpl<_$RemoveBookmarkImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadBookmarks,
    required TResult Function(String category, Article article) addBookmark,
    required TResult Function(String url) removeBookmark,
    required TResult Function(String url) checkStatus,
  }) {
    return removeBookmark(url);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadBookmarks,
    TResult? Function(String category, Article article)? addBookmark,
    TResult? Function(String url)? removeBookmark,
    TResult? Function(String url)? checkStatus,
  }) {
    return removeBookmark?.call(url);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadBookmarks,
    TResult Function(String category, Article article)? addBookmark,
    TResult Function(String url)? removeBookmark,
    TResult Function(String url)? checkStatus,
    required TResult orElse(),
  }) {
    if (removeBookmark != null) {
      return removeBookmark(url);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadBookmarks value) loadBookmarks,
    required TResult Function(_AddBookmark value) addBookmark,
    required TResult Function(_RemoveBookmark value) removeBookmark,
    required TResult Function(_CheckStatus value) checkStatus,
  }) {
    return removeBookmark(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadBookmarks value)? loadBookmarks,
    TResult? Function(_AddBookmark value)? addBookmark,
    TResult? Function(_RemoveBookmark value)? removeBookmark,
    TResult? Function(_CheckStatus value)? checkStatus,
  }) {
    return removeBookmark?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadBookmarks value)? loadBookmarks,
    TResult Function(_AddBookmark value)? addBookmark,
    TResult Function(_RemoveBookmark value)? removeBookmark,
    TResult Function(_CheckStatus value)? checkStatus,
    required TResult orElse(),
  }) {
    if (removeBookmark != null) {
      return removeBookmark(this);
    }
    return orElse();
  }
}

abstract class _RemoveBookmark implements BookmarkEvent {
  const factory _RemoveBookmark(final String url) = _$RemoveBookmarkImpl;

  String get url;

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoveBookmarkImplCopyWith<_$RemoveBookmarkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckStatusImplCopyWith<$Res> {
  factory _$$CheckStatusImplCopyWith(
    _$CheckStatusImpl value,
    $Res Function(_$CheckStatusImpl) then,
  ) = __$$CheckStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String url});
}

/// @nodoc
class __$$CheckStatusImplCopyWithImpl<$Res>
    extends _$BookmarkEventCopyWithImpl<$Res, _$CheckStatusImpl>
    implements _$$CheckStatusImplCopyWith<$Res> {
  __$$CheckStatusImplCopyWithImpl(
    _$CheckStatusImpl _value,
    $Res Function(_$CheckStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null}) {
    return _then(
      _$CheckStatusImpl(
        null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CheckStatusImpl implements _CheckStatus {
  const _$CheckStatusImpl(this.url);

  @override
  final String url;

  @override
  String toString() {
    return 'BookmarkEvent.checkStatus(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckStatusImpl &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckStatusImplCopyWith<_$CheckStatusImpl> get copyWith =>
      __$$CheckStatusImplCopyWithImpl<_$CheckStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadBookmarks,
    required TResult Function(String category, Article article) addBookmark,
    required TResult Function(String url) removeBookmark,
    required TResult Function(String url) checkStatus,
  }) {
    return checkStatus(url);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadBookmarks,
    TResult? Function(String category, Article article)? addBookmark,
    TResult? Function(String url)? removeBookmark,
    TResult? Function(String url)? checkStatus,
  }) {
    return checkStatus?.call(url);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadBookmarks,
    TResult Function(String category, Article article)? addBookmark,
    TResult Function(String url)? removeBookmark,
    TResult Function(String url)? checkStatus,
    required TResult orElse(),
  }) {
    if (checkStatus != null) {
      return checkStatus(url);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadBookmarks value) loadBookmarks,
    required TResult Function(_AddBookmark value) addBookmark,
    required TResult Function(_RemoveBookmark value) removeBookmark,
    required TResult Function(_CheckStatus value) checkStatus,
  }) {
    return checkStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadBookmarks value)? loadBookmarks,
    TResult? Function(_AddBookmark value)? addBookmark,
    TResult? Function(_RemoveBookmark value)? removeBookmark,
    TResult? Function(_CheckStatus value)? checkStatus,
  }) {
    return checkStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadBookmarks value)? loadBookmarks,
    TResult Function(_AddBookmark value)? addBookmark,
    TResult Function(_RemoveBookmark value)? removeBookmark,
    TResult Function(_CheckStatus value)? checkStatus,
    required TResult orElse(),
  }) {
    if (checkStatus != null) {
      return checkStatus(this);
    }
    return orElse();
  }
}

abstract class _CheckStatus implements BookmarkEvent {
  const factory _CheckStatus(final String url) = _$CheckStatusImpl;

  String get url;

  /// Create a copy of BookmarkEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckStatusImplCopyWith<_$CheckStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookmarkState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Article> articles, bool? isBookmarked)
    success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Article> articles, bool? isBookmarked)? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Article> articles, bool? isBookmarked)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkStateCopyWith<$Res> {
  factory $BookmarkStateCopyWith(
    BookmarkState value,
    $Res Function(BookmarkState) then,
  ) = _$BookmarkStateCopyWithImpl<$Res, BookmarkState>;
}

/// @nodoc
class _$BookmarkStateCopyWithImpl<$Res, $Val extends BookmarkState>
    implements $BookmarkStateCopyWith<$Res> {
  _$BookmarkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'BookmarkState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Article> articles, bool? isBookmarked)
    success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Article> articles, bool? isBookmarked)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Article> articles, bool? isBookmarked)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements BookmarkState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'BookmarkState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Article> articles, bool? isBookmarked)
    success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Article> articles, bool? isBookmarked)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Article> articles, bool? isBookmarked)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements BookmarkState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
    _$SuccessImpl value,
    $Res Function(_$SuccessImpl) then,
  ) = __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Article> articles, bool? isBookmarked});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
    _$SuccessImpl _value,
    $Res Function(_$SuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? articles = null, Object? isBookmarked = freezed}) {
    return _then(
      _$SuccessImpl(
        articles: null == articles
            ? _value._articles
            : articles // ignore: cast_nullable_to_non_nullable
                  as List<Article>,
        isBookmarked: freezed == isBookmarked
            ? _value.isBookmarked
            : isBookmarked // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl({
    final List<Article> articles = const [],
    this.isBookmarked,
  }) : _articles = articles;

  final List<Article> _articles;
  @override
  @JsonKey()
  List<Article> get articles {
    if (_articles is EqualUnmodifiableListView) return _articles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_articles);
  }

  @override
  final bool? isBookmarked;

  @override
  String toString() {
    return 'BookmarkState.success(articles: $articles, isBookmarked: $isBookmarked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            const DeepCollectionEquality().equals(other._articles, _articles) &&
            (identical(other.isBookmarked, isBookmarked) ||
                other.isBookmarked == isBookmarked));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_articles),
    isBookmarked,
  );

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Article> articles, bool? isBookmarked)
    success,
    required TResult Function(String message) error,
  }) {
    return success(articles, isBookmarked);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Article> articles, bool? isBookmarked)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(articles, isBookmarked);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Article> articles, bool? isBookmarked)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(articles, isBookmarked);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements BookmarkState {
  const factory _Success({
    final List<Article> articles,
    final bool? isBookmarked,
  }) = _$SuccessImpl;

  List<Article> get articles;
  bool? get isBookmarked;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'BookmarkState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Article> articles, bool? isBookmarked)
    success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Article> articles, bool? isBookmarked)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Article> articles, bool? isBookmarked)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements BookmarkState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
