import 'package:flutter/material.dart';
import 'package:workon_app/model/post/post_model.dart';
import 'package:workon_app/services/post/post_services.dart';
import 'package:workon_app/widgets/main_card.dart';

class MyFeedWidget extends StatefulWidget {
  const MyFeedWidget({super.key});

  @override
  State<MyFeedWidget> createState() => _MyFeedWidgetState();
}

class _MyFeedWidgetState extends State<MyFeedWidget> {
  bool isLiked = false;
  List<PostModel> _posts = [];
  void initState() {
    super.initState();
    _getMyPosts();
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 30) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  Future<void> _getMyPosts() async {
    final postsService = PostsServices();
    try {
      final response = await postsService.getMyPosts(context);
      if (response != [] && response != null) {
        setState(() {
          _posts = response;
        });
      }
      print("Saved: ${response.first.caption}");
    } catch (e) {
      print("Error saving profile changes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        MainCard(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFFF6900),
                child: Icon(Icons.person, size: 28, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 4, // cresce até 4 linhas
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'No que você está pensando?',
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.image, color: Color(0xFF71717B)),
              ),
            ],
          ),
        ),
        ..._posts.map((item) {
          return MainCard(
            child: Column(
              spacing: 25,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFFF6900),
                      child: Icon(Icons.person, size: 28, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.user.fullName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${timeAgo(item.updatedAt)}',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.caption,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 231, 231, 235),
                      ),
                      softWrap: true,
                    ),

                    // 👇 IMAGEM AQUI
                    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
                Divider(height: 1, thickness: 1, color: Color(0xFF27272A)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            child: Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isLiked
                                  ? Color(0xFFFB2C36)
                                  : Color(0xFFE0E0E4),
                              size: 18,
                            ),
                          ),
                          Text(
                            item.count.likes.toString(),
                            style: TextStyle(
                              color: isLiked
                                  ? Color(0xFFFB2C36)
                                  : Color(0xFFE0E0E4),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            child: Icon(
                              isLiked
                                  ? Icons.chat_bubble_outline_outlined
                                  : Icons.chat_bubble_outlined,
                              color: Color(0xFFE0E0E4),
                              size: 18,
                            ),
                          ),
                          Text(
                            item.count.comments.toString(),
                            style: TextStyle(
                              color: Color(0xFFE0E0E4),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
