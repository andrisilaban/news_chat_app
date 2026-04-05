import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_chat_app/constants/database_helper.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';
part 'bookmark_bloc.freezed.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(const _Initial()) {
    on<_LoadBookmarks>(_onLoadBookmarks);
    on<_AddBookmark>(_onAddBookmark);
    on<_RemoveBookmark>(_onRemoveBookmark);
    on<_CheckStatus>(_onCheckStatus);
  }

  Future<void> _onLoadBookmarks(_LoadBookmarks event, Emitter<BookmarkState> emit) async {
    final currentState = state;
    // Only show loading if we haven't loaded anything yet
    if (currentState is! _Success) {
      emit(const _Loading());
    }

    try {
      final List<Map<String, dynamic>> maps = await DatabaseHelper().getBookmarks();
      final List<Article> articles = maps.map((map) => _mapToArticle(map)).toList();

      if (currentState is _Success) {
        emit(currentState.copyWith(articles: articles));
      } else {
        emit(_Success(articles: articles));
      }
    } catch (e) {
      emit(_Error(e.toString()));
    }
  }

  Future<void> _onAddBookmark(_AddBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await DatabaseHelper().insertBookmark(event.category, event.article);
      
      final currentState = state;
      if (currentState is _Success) {
        // Immediate UI feedback
        emit(currentState.copyWith(isBookmarked: true));
      } else {
        emit(const _Success(isBookmarked: true));
      }
      
      add(const BookmarkEvent.loadBookmarks());
    } catch (e) {
      emit(_Error(e.toString()));
    }
  }

  Future<void> _onRemoveBookmark(_RemoveBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await DatabaseHelper().deleteBookmark(event.url);
      
      final currentState = state;
      if (currentState is _Success) {
        // Immediate UI feedback
        emit(currentState.copyWith(isBookmarked: false));
      } else {
        emit(const _Success(isBookmarked: false));
      }
      
      add(const BookmarkEvent.loadBookmarks());
    } catch (e) {
      emit(_Error(e.toString()));
    }
  }

  Future<void> _onCheckStatus(_CheckStatus event, Emitter<BookmarkState> emit) async {
    try {
      final isBookmarkedResult = await DatabaseHelper().isBookmarked(event.url);
      final currentState = state;
      if (currentState is _Success) {
        emit(currentState.copyWith(isBookmarked: isBookmarkedResult));
      } else {
        emit(_Success(isBookmarked: isBookmarkedResult));
      }
    } catch (e) {
      emit(_Error(e.toString()));
    }
  }

  Article _mapToArticle(Map<String, dynamic> map) {
    return Article(
      author: map['author'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt: map['publishedAt'],
      content: map['content'],
      source: map['source_name'] != null ? Source(name: map['source_name']) : null,
    );
  }
}
