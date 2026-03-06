import 'package:flutter/material.dart';
import 'package:workon_app/model/user_model.dart';
import 'package:workon_app/services/follow/follow_service.dart';
import 'package:workon_app/services/users/users_services.dart';
import 'package:workon_app/storage/user_logged_storage.dart';
import 'package:workon_app/widgets/main_card.dart';

class ExploreWidget extends StatefulWidget {
  const ExploreWidget({super.key});

  @override
  State<ExploreWidget> createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  final TextEditingController _emailController = TextEditingController();
  UserLoggedStorage _userIdStorage = UserLoggedStorage();
  UserModel? _user;
  bool _isFollowing = false;
  bool _isLoadingFollow = false;

  Future<void> getUserByEmail(String email) async {
    final postsService = UsersServices();
    try {
      final response = await postsService.getUserByEmail(context, email);
      if (response != null) {
        final currentUserId = await _userIdStorage.getUser();

        final isFollowing =
            response.followers?.any((f) => f.follower.id == currentUserId) ??
            false;

        setState(() {
          _user = response;
          _isFollowing = isFollowing;
        });
      }
    } catch (e) {
      print("Error saving profile changes: $e");
    }
  }

  Future<void> toggleFollow() async {
    if (_user == null) return;

    setState(() {
      _isLoadingFollow = true;
    });

    final followServices = FollowServices();

    try {
      if (!_isFollowing) {
        await followServices.createFollow(_user!.id, context);
      } else {
        await followServices.deleteFollow(_user!.id, context);
      }

      setState(() {
        _isFollowing = !_isFollowing;
      });
    } catch (e) {
      print("Erro ao seguir/unfollow: $e");
    }

    setState(() {
      _isLoadingFollow = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    getUserByEmail(value.trim());
                  }
                },
                controller: _emailController,
                style: const TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                  fillColor: const Color(0xFF18181B),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFFFF6900),
                      size: 25,
                    ),
                    onPressed: () {
                      final email = _emailController.text.trim();

                      if (email.isNotEmpty) {
                        getUserByEmail(email);
                      }
                    },
                  ),

                  isDense: true,
                  filled: true,
                  hintText: 'Busque Amigos...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF27272A)),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (_user != null)
          Row(
            children: [
              Expanded(
                child: MainCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: _user?.imageUrl != null
                            ? NetworkImage(_user!.imageUrl!)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user!.name ?? 'Unknown User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _user!.email,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _isLoadingFollow ? null : toggleFollow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFollowing
                                  ? Color(0xFF27272A)
                                  : const Color(0xFFFF6900),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Color(0xFF3F3F47)),
                              ),
                            ),
                            child: _isLoadingFollow
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    spacing: 16,
                                    children: [
                                      Icon(
                                        _isFollowing
                                            ? Icons.person_remove_alt_1_outlined
                                            : Icons.person_add_alt_1_outlined,
                                        color: _isFollowing
                                            ? Color(0xFFA8A8AD)
                                            : Color(0xFF171717),
                                        size: 20,
                                      ),
                                      Text(
                                        _isFollowing ? "Seguindo" : "Seguir",
                                        style: TextStyle(
                                          color: _isFollowing
                                              ? Color(0xFFA8A8AD)
                                              : Color(0xFF171717),
                                          fontSize: 17,
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
          ),
      ],
    );
  }
}
