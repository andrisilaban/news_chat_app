import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'headline_news_event.dart';
part 'headline_news_state.dart';
part 'headline_news_bloc.freezed.dart';

class HeadlineNewsBloc extends Bloc<HeadlineNewsEvent, HeadlineNewsState> {
  HeadlineNewsBloc() : super(_Initial()) {
    on<HeadlineNewsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
