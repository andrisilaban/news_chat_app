part of 'headline_news_bloc.dart';

@freezed
class HeadlineNewsState with _$HeadlineNewsState {
  const factory HeadlineNewsState.initial() = _Initial;
  const factory HeadlineNewsState.loading() = _Loading;
  const factory HeadlineNewsState.success(HeadlineNewsResponseModel bill) =
      _Success;
  const factory HeadlineNewsState.empty() = _Empty;
  const factory HeadlineNewsState.error({required String message}) = _Error;
}
