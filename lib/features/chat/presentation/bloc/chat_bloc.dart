import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_chat_app/constants/database_helper.dart';
import 'package:news_chat_app/features/chat/models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const _Initial()) {
    on<_LoadHistory>(_onLoadHistory);
    on<_SendMessage>(_onSendMessage);
    on<_SendImage>(_onSendImage);
    on<_ReceiveBotReply>(_onReceiveBotReply);

    // Load history immediately on creation
    add(const ChatEvent.loadHistory());
  }

  Future<void> _onLoadHistory(_LoadHistory event, Emitter<ChatState> emit) async {
    final messages = await DatabaseHelper().getChatMessages();
    emit(_Loaded(messages: messages, isBotTyping: false));
  }

  Future<void> _onSendMessage(_SendMessage event, Emitter<ChatState> emit) async {
    if (event.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    await DatabaseHelper().insertChatMessage(newMessage);
    _appendMessageAndTriggerBot(newMessage, emit);
  }

  Future<void> _onSendImage(_SendImage event, Emitter<ChatState> emit) async {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: event.imagePath,
      isUser: true,
      timestamp: DateTime.now(),
    );

    await DatabaseHelper().insertChatMessage(newMessage);
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
      // Find the last message sent by the user to determine the context
      final lastUserMessage = currentState.messages.lastWhere(
        (m) => m.isUser,
        orElse: () => ChatMessage(id: '', timestamp: DateTime.now(), isUser: true, text: ''),
      ).text?.toLowerCase() ?? '';

      String replyText = "Maaf, saya tidak begitu mengerti. Boleh diperjelas atau ada hal lain terkait pesanan yang bisa saya bantu?";

      // Rule-based NLP Matching
      if (lastUserMessage.contains("hello, i need help with my order") || lastUserMessage == "hello") {
        replyText = "Sure, could you please provide your order number?";
      } else if (lastUserMessage.contains("0123456")) {
        replyText = "Thanks! I'll check the details for you.";
      } else if (lastUserMessage.contains("halo") || lastUserMessage.contains("hai")) {
        replyText = "Halo! Selamat datang di Chat Support. Ada yang bisa kami bantu hari ini?";
      } else if (lastUserMessage.contains("pesan") || lastUserMessage.contains("order") || lastUserMessage.contains("lacak")) {
        replyText = "Tentu, boleh minta nomor pesanan atau nomor resi Anda agar kami bisa segera melacaknya?";
      } else if (RegExp(r'\d{4,}').hasMatch(lastUserMessage)) {
        replyText = "Terima kasih! Kami sedang memproses pengecekan untuk pesanan tersebut. Detailnya akan segera kami tampilkan.";
      } else if (lastUserMessage.contains("harga") || lastUserMessage.contains("biaya")) {
        replyText = "Untuk harga dan detail lebih lanjut, silakan merujuk pada halaman produk spesifik di menu aplikasi. Ada produk tertentu yang sedang dicari?";
      } else if (lastUserMessage.contains("bantu") || lastUserMessage.contains("komplain") || lastUserMessage.contains("rusak")) {
        replyText = "Kami mohon maaf atas ketidaknyamanannya. Bisa tolong lampirkan foto kendalanya? Agen kami juga akan segera mengambil alih percakapan ini.";
      }

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: replyText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Persist bot reply too
      await DatabaseHelper().insertChatMessage(botMessage);

      final newMessages = List<ChatMessage>.from(currentState.messages)..add(botMessage);

      // Emit new state with isBotTyping = false
      emit(_Loaded(messages: newMessages, isBotTyping: false));
    }
  }
}

