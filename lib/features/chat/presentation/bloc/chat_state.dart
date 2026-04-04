part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loaded({
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isBotTyping,
  }) = _Loaded;
}
