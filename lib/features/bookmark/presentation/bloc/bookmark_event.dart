part of 'bookmark_bloc.dart';

@freezed
class BookmarkEvent with _$BookmarkEvent {
  const factory BookmarkEvent.loadBookmarks() = _LoadBookmarks;
  const factory BookmarkEvent.addBookmark(String category, Article article) = _AddBookmark;
  const factory BookmarkEvent.removeBookmark(String url) = _RemoveBookmark;
  const factory BookmarkEvent.checkStatus(String url) = _CheckStatus;
}
