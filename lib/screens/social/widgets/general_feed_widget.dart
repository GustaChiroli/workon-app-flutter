import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workon_app/model/post/comment_model.dart';
import 'package:workon_app/model/post/post_model.dart';
import 'package:workon_app/services/comments/comment_service.dart';
import 'package:workon_app/services/likes/like_service.dart';
import 'package:workon_app/services/post/post_services.dart';
import 'package:workon_app/storage/user_logged_storage.dart';
import 'package:workon_app/widgets/main_card.dart';

class GeneralFeedWidget extends StatefulWidget {
  const GeneralFeedWidget({super.key});

  @override
  State<GeneralFeedWidget> createState() => _GeneralFeedWidgetState();
}

class _GeneralFeedWidgetState extends State<GeneralFeedWidget> {
  final TextEditingController _captionController = TextEditingController();
  Map<String, TextEditingController> commentControllers = {};
  Map<String, String> postLikeIds = {};
  Map<String, bool> loadingLikes = {};
  Map<String, bool> likedPosts = {};
  Map<String, bool> openComments = {};
  String userImageString = "";
  File? _selectedImage;
  List<PostModel> _posts = [];
  Map<String, List<CommentModel>> postComments = {};
  void initState() {
    super.initState();
    _getGeneralPosts();
    _getImageuser();
  }

  @override
  void dispose() {
    for (var controller in commentControllers.values) {
      controller.dispose();
    }
    _captionController.dispose();
    super.dispose();
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (_captionController.text.trim().isEmpty && _selectedImage == null) {
      return;
    }

    final postsService = PostsServices();

    await postsService.createPost(
      context: context,
      caption: _captionController.text.trim(),
      imageFile: _selectedImage,
    );

    _captionController.clear();

    setState(() {
      _selectedImage = null;
    });

    _getGeneralPosts(); // atualiza feed
  }

  Future<void> _createComment(String postId) async {
    final controller = commentControllers[postId];

    if (controller == null || controller.text.trim().isEmpty) {
      return;
    }
    final commentServices = CommentServices();

    await commentServices.createComment(
      context: context,
      content: controller.text.trim(),
      postId: postId,
    );

    controller.clear();

    _getComments(postId); // atualiza feed
    _getGeneralPosts();
  }

  Future<void> _toggleLike(PostModel post) async {
    final isLiked = likedPosts[post.id] ?? false;
    final isLoading = loadingLikes[post.id] ?? false;

    if (isLoading) return;

    setState(() {
      loadingLikes[post.id] = true;
    });

    final likeService = LikeService();
    try {
      if (!isLiked) {
        final likeId = await likeService.createLike(
          context: context,
          postId: post.id,
        );

        setState(() {
          likedPosts[post.id] = true;
          postLikeIds[post.id] = likeId;
        });
      } else {
        final likeId = postLikeIds[post.id];

        if (likeId != null) {
          await likeService.removeLike(likeId);
        }

        setState(() {
          likedPosts[post.id] = false;
          postLikeIds.remove(post.id);
        });
      }

      _getGeneralPosts(); // atualiza contagem
    } catch (e) {
      print(e);
    }

    setState(() {
      loadingLikes[post.id] = false;
    });
  }

  Future<void> _deletePost(String postId) async {
    if (postId.isEmpty) {
      return;
    }
    final postsService = PostsServices();
    await postsService.removePost(postId);
    _getGeneralPosts();
  }

  Future<void> _deleteComment(String commentId, String postId) async {
    if (commentId.isEmpty) {
      return;
    }
    final commentServices = CommentServices();
    await commentServices.removeComment(commentId);
    _getComments(postId);
    _getGeneralPosts();
  }

  Future<void> _getImageuser() async {
    UserLoggedStorage userLoggedStorage = new UserLoggedStorage();
    try {
      final userImage = await userLoggedStorage.getUserImage();
      if (userImage != null && userImage.isNotEmpty) {
        setState(() {
          userImageString = userImage;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getGeneralPosts() async {
    final postsService = PostsServices();
    try {
      final response = await postsService.getGeneralPosts(context);
      if (response != null && response.isNotEmpty) {
        setState(() {
          _posts = response;
        });

        for (var post in response) {
          likedPosts[post.id] = post.likedByMe;

          if (post.likeId != null) {
            postLikeIds[post.id] = post.likeId!;
          }
        }
      }
    } catch (e) {
      print("Error saving profile changes: $e");
    }
  }

  Future<void> _getComments(String postId) async {
    final commentServices = CommentServices();
    try {
      final response = await commentServices.getComments(context, postId);
      if (response != [] && response != null) {
        setState(() {
          postComments[postId] = response;
        });
      }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: userImageString != null
                        ? NetworkImage(userImageString!)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _captionController,
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
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image, color: Color(0xFF71717B)),
                  ),
                  IconButton(
                    onPressed: _createPost,
                    icon: const Icon(Icons.send, color: Color(0xFFFF6900)),
                  ),
                ],
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        ..._posts.map((item) {
          final isLiked = likedPosts[item.id] ?? false;
          final isCommentOpen = openComments[item.id] ?? false;
          return MainCard(
            child: Column(
              spacing: 25,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: item.user.imageUrl != null
                          ? NetworkImage(item.user.imageUrl!)
                          : null,
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
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white54),
                      color: const Color(0xFF18181B),
                      onSelected: (value) {
                        if (value == 'edit') {
                          // _editPost(item);
                        } else if (value == 'delete') {
                          _deletePost(item.id);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Excluir Post',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
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
                            onTap: () => _toggleLike(item),
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
                              final newState = !isCommentOpen;

                              setState(() {
                                openComments[item.id] = newState;
                              });

                              if (newState) {
                                _getComments(item.id);
                              }
                            },
                            child: Icon(
                              isCommentOpen
                                  ? Icons.chat_bubble_outlined
                                  : Icons.chat_bubble_outline_outlined,
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
                if (isCommentOpen) ...[
                  Divider(height: 1, thickness: 1, color: Color(0xFF27272A)),
                  ...(postComments[item.id] ?? []).map((commentItem) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundImage: commentItem.user.imageUrl != null
                                  ? NetworkImage(commentItem.user.imageUrl!)
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF27272A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF27272A),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        commentItem.user.fullName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        commentItem.content,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        softWrap: true,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${timeAgo(commentItem.createdAt)}',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white54,
                                  ),
                                  color: const Color(0xFF18181B),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      // _editPost(item);
                                    } else if (value == 'delete') {
                                      _deleteComment(commentItem.id, item.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Excluir Comentario',
                                            style: TextStyle(
                                              color: Color(0xFFFFFFFF),
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
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentControllers.putIfAbsent(
                            item.id,
                            () => TextEditingController(),
                          ),
                          minLines: 1,
                          maxLines: 4, // cresce até 4 linhas
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            fillColor: Color(0xFF27272A),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF3E3E46)),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),

                            hintText: 'Escreva um comentário...',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _createComment(item.id),
                        icon: const Icon(Icons.send, color: Color(0xFFFF6900)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
