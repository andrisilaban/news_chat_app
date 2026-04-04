import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
// No intl import

import 'package:news_chat_app/features/chat/models/chat_message.dart';
import 'package:news_chat_app/features/chat/presentation/bloc/chat_bloc.dart';

class ChatView extends HookWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final scrollController = useScrollController();

    void scrollToBottom() {
      if (scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }

    void sendMessage() {
      final text = textController.text.trim();
      if (text.isNotEmpty) {
        context.read<ChatBloc>().add(ChatEvent.sendMessage(text));
        textController.clear();
        scrollToBottom();
      }
    }

    Future<void> pickAndSendImage() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        
        if (result != null && result.files.single.path != null && context.mounted) {
          context.read<ChatBloc>().add(ChatEvent.sendImage(result.files.single.path!));
          scrollToBottom();
        }
      } catch (e) {
        debugPrint('Error picking file: $e');
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // light gray background like reference
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chat Support',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Online · Typically replies in minutes',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'), 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                state.maybeWhen(
                  loaded: (messages, isBotTyping) => scrollToBottom(),
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (messages, isBotTyping) {
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
                      itemCount: messages.length + (isBotTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && isBotTyping) {
                          return const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Text('Bot is typing...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                            ),
                          );
                        }
                        return _buildChatBubble(context, messages[index]);
                      },
                    );
                  },
                  orElse: () => const Center(child: Text("Start a conversation", style: TextStyle(color: Colors.grey))),
                );
              },
            ),
          ),
          
          // Input Controller
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Image Picker Button
                  GestureDetector(
                    onTap: pickAndSendImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.image_outlined, color: Colors.grey.shade600, size: 28),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Text Field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: textController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Write your message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Send Button
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFE85D25)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(BuildContext context, ChatMessage message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: message.imagePath != null 
              ? EdgeInsets.zero 
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.imagePath != null 
                 ? Colors.transparent 
                 : (isUser ? const Color(0xFF7C3AED) : const Color(0xFFF3F4F6)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
            ),
            child: _buildBubbleContent(context, message, isUser),
          ),
          const SizedBox(height: 6),
          Text(
            _formatTime(message.timestamp),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleContent(BuildContext context, ChatMessage message, bool isUser) {
    if (message.imagePath != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                body: Center(
                  child: InteractiveViewer(
                    child: Image.file(File(message.imagePath!)),
                  ),
                ),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          child: Image.file(
            File(message.imagePath!),
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    
    return Text(
      message.text ?? '',
      style: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 15,
        height: 1.4,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
