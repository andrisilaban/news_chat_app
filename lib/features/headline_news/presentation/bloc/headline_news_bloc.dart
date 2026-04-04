import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_chat_app/constants/api_endpoints.dart';
import 'package:news_chat_app/constants/config.dart';
import 'package:news_chat_app/constants/custom_http.dart';
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

        final preview = response.fold(
          (l) => 'Left: $l',
          (r) =>
              'Right: ${r.toString().contains("Instance") ? (r.toMap()) : r}',
        );

        log('------');
        log('✅✅✅✅ HeadlineNewsBloc preview: $preview');

        await response.fold(
          (l) async {
            log('❌ error HeadlineNewsBloc $preview');
            emit(_Error(message: l));
          },
          (r) async {
            if (r.isSuccess) {
              log('✅ HeadlineNewsBloc: successful');
              emit(_Success(r));
            } else {
              log('❌ Empty HeadlineNewsBloc');
              emit(_Empty());
            }
          },
        );
      } catch (e) {
        emit(_Error(message: e.toString()));
      }
    });
  }
}
