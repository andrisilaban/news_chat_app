part of 'headline_news_bloc.dart';

@freezed
class HeadlineNewsEvent with _$HeadlineNewsEvent {
  const factory HeadlineNewsEvent.started() = _Started;
  const factory HeadlineNewsEvent.getHeadlineNews({required String category}) =
      _GetHeadlineNews;
}
