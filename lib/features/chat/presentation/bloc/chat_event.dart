part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.loadHistory() = _LoadHistory;
  const factory ChatEvent.sendMessage(String text) = _SendMessage;
  const factory ChatEvent.sendImage(String imagePath) = _SendImage;
  const factory ChatEvent.receiveBotReply() = _ReceiveBotReply;
}
