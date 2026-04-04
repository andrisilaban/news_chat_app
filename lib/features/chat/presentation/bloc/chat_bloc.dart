import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_chat_app/features/chat/models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const _Initial()) {
    on<_SendMessage>(_onSendMessage);
    on<_SendImage>(_onSendImage);
    on<_ReceiveBotReply>(_onReceiveBotReply);
  }

  void _onSendMessage(_SendMessage event, Emitter<ChatState> emit) {
    if (event.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _appendMessageAndTriggerBot(newMessage, emit);
  }

  void _onSendImage(_SendImage event, Emitter<ChatState> emit) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: event.imagePath,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _appendMessageAndTriggerBot(newMessage, emit);
  }

  void _appendMessageAndTriggerBot(ChatMessage message, Emitter<ChatState> emit) {
    final currentState = state;
    List<ChatMessage> currentMessages = [];

    if (currentState is _Loaded) {
      currentMessages = List.from(currentState.messages);
    }

    currentMessages.add(message);

    // Emit new state with isBotTyping = true
    emit(_Loaded(messages: currentMessages, isBotTyping: true));

    // Queue bot reply
    add(const ChatEvent.receiveBotReply());
  }

  Future<void> _onReceiveBotReply(_ReceiveBotReply event, Emitter<ChatState> emit) async {
    // Delay for realism
    await Future.delayed(const Duration(seconds: 2));

    final currentState = state;
    if (currentState is _Loaded) {
      final mockReplies = [
        "Sure, could you please provide your order number?",
        "Thanks! I'll check the details for you.",
        "I understand. Let me transfer you to a human agent.",
        "Is there anything else I can help you with today?",
        "Please wait a moment while I retrieve that information."
      ];
      
      final replyText = mockReplies[Random().nextInt(mockReplies.length)];

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: replyText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      final newMessages = List<ChatMessage>.from(currentState.messages)..add(botMessage);

      // Emit new state with isBotTyping = false
      emit(_Loaded(messages: newMessages, isBotTyping: false));
    }
  }
}
