import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_chat_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:news_chat_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:news_chat_app/features/chat/presentation/chat_view.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';

class HeadlineNewsDetailView extends HookWidget {
  final Article article;
  final String category;

  const HeadlineNewsDetailView({
    super.key,
    required this.article,
    required this.category,
  });

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString.substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<BookmarkBloc>().add(BookmarkEvent.checkStatus(article.url ?? ''));
      return null;
    }, [article.url]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: article.urlToImage != null
                ? Image.network(
                    article.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),

          // 2. Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 32,
                      bottom: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          article.title ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Subtitle Row (Source • Date) & Category Pill
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${article.source?.name ?? "Unknown"} • ${_formatDate(article.publishedAt)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE85D25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Body content
                        Text(
                          article.description ?? 'No description available.',
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          article.content ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),

                        // Extra space at bottom for floating action button
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Top Action Buttons (Back & Bookmark)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
                BlocBuilder<BookmarkBloc, BookmarkState>(
                  builder: (context, state) {
                    final isBookmarked = state.maybeWhen(
                      success: (articles, isBookmarked) => isBookmarked ?? false,
                      orElse: () => false,
                    );

                    return GestureDetector(
                      onTap: () {
                        if (isBookmarked) {
                          context.read<BookmarkBloc>().add(
                                BookmarkEvent.removeBookmark(article.url ?? ''),
                              );
                        } else {
                          context.read<BookmarkBloc>().add(
                                BookmarkEvent.addBookmark(category, article),
                              );
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? const Color(0xFFE85D25) : Colors.black,
                          size: 22,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // 4. Floating Action Button
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF8B5CF6), // Purple
              Color(0xFFE85D25), // Pinkish Orange
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ChatBloc(),
                  child: const ChatView(),
                ),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: const Icon(Icons.chat_bubble, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
