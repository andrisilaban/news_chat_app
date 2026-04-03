part of 'headline_news_bloc.dart';

@freezed
class HeadlineNewsEvent with _$HeadlineNewsEvent {
  const factory HeadlineNewsEvent.started() = _Started;
}