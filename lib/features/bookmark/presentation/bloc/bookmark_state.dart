part of 'bookmark_bloc.dart';

@freezed
class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial() = _Initial;
  const factory BookmarkState.loading() = _Loading;
  const factory BookmarkState.success({
    @Default([]) List<Article> articles,
    bool? isBookmarked,
  }) = _Success;
  const factory BookmarkState.error(String message) = _Error;
}
