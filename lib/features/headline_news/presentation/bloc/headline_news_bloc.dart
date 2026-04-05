import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_chat_app/constants/api_endpoints.dart';
import 'package:news_chat_app/constants/config.dart';
import 'package:news_chat_app/constants/custom_http.dart';
import 'package:news_chat_app/constants/database_helper.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';

part 'headline_news_event.dart';
part 'headline_news_state.dart';
part 'headline_news_bloc.freezed.dart';

class HeadlineNewsBloc extends Bloc<HeadlineNewsEvent, HeadlineNewsState> {
  HeadlineNewsBloc() : super(_Initial()) {
    on<_GetHeadlineNews>((event, emit) async {
      emit(const _Loading());

      log('🔐 HeadlineNewsBloc: Starting process...');

      try {
        final categoryQuery = event.category.toLowerCase();

        final response = await CustomHttp().request(
          endpoint:
              "${ApiEndpoints.headlineNews}?q=$categoryQuery&language=id&sortBy=publishedAt&page=1&pageSize=10&apikey=${Config.apiKey}",
          method: HttpMethod.get,
          authType: TokenAuth.no,
          fromJson: (json) => HeadlineNewsResponseModel.fromMap(json),
        );

        await response.fold(
          (l) async {
            log('❌ error HeadlineNewsBloc: $l — trying offline cache...');
            final cachedArticles = await DatabaseHelper().getCachedNews(event.category);
            if (cachedArticles.isNotEmpty) {
              log('📦 Serving from cache for category: ${event.category}');
              final offlineModel = HeadlineNewsResponseModel(
                status: 'ok',
                totalResults: cachedArticles.length,
                articles: cachedArticles,
              );
              emit(_Success(offlineModel));
            } else {
              emit(_Error(message: 'No internet connection and no cached data available.'));
            }
          },
          (r) async {
            if (r.isSuccess) {
              log('✅ HeadlineNewsBloc: successful — caching ${r.articles?.length ?? 0} articles');
              // Cache to SQLite
              if (r.articles != null && r.articles!.isNotEmpty) {
                await DatabaseHelper().cacheNews(event.category, r.articles!);
              }
              emit(_Success(r));
            } else {
              log('❌ Empty HeadlineNewsBloc');
              emit(_Empty());
            }
          },
        );
      } on SocketException {
        log('📡 No internet — loading from cache for category: ${event.category}');
        final cachedArticles = await DatabaseHelper().getCachedNews(event.category);
        if (cachedArticles.isNotEmpty) {
          final offlineModel = HeadlineNewsResponseModel(
            status: 'ok',
            totalResults: cachedArticles.length,
            articles: cachedArticles,
          );
          emit(_Success(offlineModel));
        } else {
          emit(const _Error(message: 'No internet connection and no cached data available.'));
        }
      } catch (e) {
        log('❌ HeadlineNewsBloc unexpected error: $e');
        // Try to serve from cache as last resort
        try {
          final cachedArticles = await DatabaseHelper().getCachedNews(event.category);
          if (cachedArticles.isNotEmpty) {
            final offlineModel = HeadlineNewsResponseModel(
              status: 'ok',
              totalResults: cachedArticles.length,
              articles: cachedArticles,
            );
            emit(_Success(offlineModel));
            return;
          }
        } catch (_) {}
        emit(_Error(message: e.toString()));
      }
    });
  }
}
