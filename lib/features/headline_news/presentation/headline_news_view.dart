import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_chat_app/features/headline_news/presentation/bloc/headline_news_bloc.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';
import 'package:news_chat_app/features/headline_news_detail/presentation/headline_news_detail_view.dart';
import 'package:news_chat_app/features/bookmark_view.dart/presentation/bookmark_view.dart';
import 'package:news_chat_app/features/log_out_view/presentation/log_out_view.dart';

class HeadlineNewsView extends HookWidget {
  const HeadlineNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Latest',
      'Politics',
      'Tech',
      'Sport',
      'Entertainment',
    ];
    final selectedCategoryIndex = useState(0);

    useEffect(() {
      // Defer the add event until after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Read BLoC directly from context
        if (context.mounted) {
          context.read<HeadlineNewsBloc>().add(
            const HeadlineNewsEvent.getHeadlineNews(category: 'Latest'),
          );
        }
      });
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFFF97316), // A warm orange
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 20.0,
                    bottom: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Top News\nIndonesia",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                // White Container for Content
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // Categories List
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final isActive = index == selectedCategoryIndex.value;
                              return GestureDetector(
                                onTap: () {
                                  if (selectedCategoryIndex.value != index) {
                                    selectedCategoryIndex.value = index;
                                    context.read<HeadlineNewsBloc>().add(
                                      HeadlineNewsEvent.getHeadlineNews(
                                        category: categories[index],
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF8B5CF6)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    categories[index],
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: isActive
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // News List
                        Expanded(
                          child:
                              BlocBuilder<HeadlineNewsBloc, HeadlineNewsState>(
                                builder: (context, state) {
                                  return state.maybeWhen(
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF8B5CF6),
                                      ),
                                    ),
                                    success: (model) {
                                      final articles = model.articles ?? [];
                                      if (articles.isEmpty) {
                                        return const Center(
                                          child: Text("No news available"),
                                        );
                                      }
                                      return ListView.separated(
                                        key: const Key('news_list'),
                                        padding: const EdgeInsets.only(
                                          left: 24,
                                          right: 24,
                                          bottom: 20,
                                        ),
                                        itemCount: articles.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 24),
                                        itemBuilder: (context, index) {
                                          final article = articles[index];
                                            return _buildNewsItem(
                                              context, 
                                              article, 
                                              categories[selectedCategoryIndex.value],
                                              index: index,
                                            );
                                        },
                                      );
                                    },
                                    error: (message) =>
                                        Center(child: Text(message)),
                                    orElse: () => const Center(
                                      child: Text("Error loading news"),
                                    ),
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildNewsItem(BuildContext context, Article article, String category, {int? index}) {
    String timeAgo = "Unknown";
    if (article.publishedAt != null) {
      try {
        final parsedDate = DateTime.parse(article.publishedAt!);
        final difference = DateTime.now().difference(parsedDate);
        if (difference.inHours > 0) {
          timeAgo = '${difference.inHours}h ago';
        } else if (difference.inMinutes > 0) {
          timeAgo = '${difference.inMinutes}m ago';
        } else {
          timeAgo = 'Just now';
        }
      } catch (e) {
        timeAgo = article.publishedAt!.substring(0, 10);
      }
    }

    return GestureDetector(
      key: index != null ? Key('news_item_$index') : null,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeadlineNewsDetailView(
              article: article,
              category: category,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 100,
              height: 100,
              color: const Color(0xFFF3F4F6),
              child: article.urlToImage != null
                  ? Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, color: Colors.grey),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          // Title and Subtitle
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.title ?? 'No title',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                      height: 1.3,
                    ),
                  ),
                  Text(
                    '${article.source?.name ?? "Unknown source"} · $timeAgo',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home_filled,
                color: Color(0xFF8B5CF6),
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Color(0xFF9CA3AF),
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkView()),
                );
              },
              key: const Key('bookmark_nav_button'),
              icon: const Icon(
                Icons.bookmark_outline,
                color: Color(0xFF9CA3AF),
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogOutView()),
                );
              },
              icon: const Icon(
                Icons.person_outline,
                color: Color(0xFF9CA3AF),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
