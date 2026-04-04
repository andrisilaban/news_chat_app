import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_chat_app/constants/custom_http.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';

part 'headline_news_event.dart';
part 'headline_news_state.dart';
part 'headline_news_bloc.freezed.dart';

class HeadlineNewsBloc extends Bloc<HeadlineNewsEvent, HeadlineNewsState> {
  HeadlineNewsBloc() : super(_Initial()) {
    on<HeadlineNewsEvent>((event, emit) async {
      emit(_Loading());

      log('🔐 HeadlineNewsBloc: Starting bill process...');

      try {
        final response = await CustomHttp().request(
          endpoint:
              "https://newsapi.org/v2/everything?q=business&language=id&sortBy=publishedAt&page=1&apikey=a08285274bd8432bbe6e98c94b193dd3",
          // endpoint: ApiEndpoints.headlineNews,
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
              if (r.isSuccess) {
                emit(_Success(r));
              } else {
                emit(_Empty());
              }
            } else {
              log('❌ Empty HeadlineNewsBloc: r.message');
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
