import 'package:flutter/material.dart';
import 'package:workon_app/model/user_model.dart';
import 'package:workon_app/services/auth_service.dart';
import 'package:workon_app/services/users/users_services.dart';
import 'package:workon_app/widgets/main_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String? memberSince;
  String monthSince = "";
  bool isLoading = true;
  String selectedGoal = "BUILD_MUSCLE";
  bool isEditing = false;

  Map<String, dynamic> buildPatchBody() {
    final Map<String, dynamic> body = {};

    if (fullNameController.text.trim().isNotEmpty) {
      body['fullName'] = fullNameController.text.trim();
    }

    if (emailController.text.trim().isNotEmpty) {
      body['email'] = emailController.text.trim();
    }

    final weight = double.tryParse(weightController.text);
    if (weight != null) {
      body['weight'] = weight;
    }

    final height = double.tryParse(heightController.text);
    if (height != null) {
      body['height'] = height;
    }

    body['fitnessGoal'] = selectedGoal;

    return body;
  }

  String formatDate(int month) {
    final monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${monthNames[month - 1]}";
  }

  Widget _buildGoalOption(String title) {
    final bool isSelected = selectedGoal == title;

    String formatGoal(String goal) {
      return goal
          .toLowerCase()
          .split('_')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }

    return GestureDetector(
      onTap: () {
        if (isEditing) {
          setState(() {
            selectedGoal = title;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF302018) : const Color(0xFF2A2A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6900)
                : const Color(0xFF3A3A3C),
            width: 1.5,
          ),
        ),
        child: Text(
          formatGoal(title),
          style: TextStyle(
            color: isSelected ? const Color(0xFFFF6900) : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    final usersService = UsersServices();

    final body = buildPatchBody();

    try {
      final response = await usersService.editUser(body, context);
      print("Saved: ${response?.data}");
    } catch (e) {
      print("Error saving profile changes: $e");
    }
  }

  Future<void> _logout() async {
    final authService = AuthService();
    await authService.logout(context);
  }

  Future<void> _profileData() async {
    final usersService = UsersServices();
    final user = await usersService.getMe(context);
    if (user != null) {
      setState(() {
        selectedGoal = user.fitnessGoal ?? "BUILD_MUSCLE";
        fullNameController.text = user.name ?? "";
        emailController.text = user.email;
        weightController.text = user.weight?.toString() ?? "";
        heightController.text = user.height?.toString() ?? "";
        memberSince = user.createdAt;
        if (memberSince != null) {
          monthSince = formatDate(int.parse(memberSince!.substring(5, 7)));
        }

        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _profileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          "Manage your account",
                          style: TextStyle(
                            color: Color(0xFF9F9FA9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MainCard(
                            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Color(0xFFFF6900),
                                      child: Icon(
                                        Icons.person,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fullNameController.text.isNotEmpty
                                                ? fullNameController.text
                                                : "User Name",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            emailController.text,
                                            style: TextStyle(
                                              color: isEditing
                                                  ? Colors.white
                                                  : Colors.white54,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF472816),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFF27272A),
                                                width: 1,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4.0,
                                                    vertical: 0,
                                                  ),
                                              child: Text(
                                                memberSince != null
                                                    ? "Member since $monthSince ${memberSince!.substring(0, 4)}"
                                                    : "Member since --",
                                                style: TextStyle(
                                                  color: Color(0xFFF38707),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 36),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                isEditing
                                                    ? "Save Changes"
                                                    : "Edit Profile",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                // Example action for login button
                                                if (isEditing) {
                                                  _saveProfileChanges();
                                                  print(
                                                    "Saving profile changes...",
                                                  );
                                                }
                                                setState(() {
                                                  isEditing = !isEditing;
                                                });
                                                print("Edit Profile");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFFFF6900,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
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
                    Row(
                      children: [
                        Expanded(
                          child: MainCard(
                            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.person_outline,
                                      color: Color(0xFFFF6900),
                                      size: 19,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Personal Information",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 36),
                                Row(
                                  children: [
                                    Text(
                                      "Full Name",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          234,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                TextFormField(
                                  controller: fullNameController,
                                  style: TextStyle(
                                    color: isEditing
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    filled: true,
                                    enabled: isEditing,
                                    fillColor: const Color(0xFF1C1C1C),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF27272A),
                                      ),
                                    ),

                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(
                                          0xFF27272A,
                                        ), // mesma borda do enabled
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF27272A),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 14),
                                Row(
                                  children: [
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          234,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                TextFormField(
                                  controller: emailController,
                                  enabled: isEditing,
                                  style: TextStyle(
                                    color: isEditing
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF1C1C1C),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF27272A),
                                      ),
                                    ),

                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(
                                          0xFF27272A,
                                        ), // mesma borda do enabled
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF27272A),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14),

                                Row(
                                  children: [
                                    /// WEIGHT - 60%
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Weight",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                234,
                                                255,
                                                255,
                                                255,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          TextFormField(
                                            enabled: isEditing,
                                            controller: weightController,
                                            style: TextStyle(
                                              color: isEditing
                                                  ? Colors.white
                                                  : Colors.white54,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFF1C1C1C,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF27272A),
                                                ),
                                              ),

                                              disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: const BorderSide(
                                                  color: Color(
                                                    0xFF27272A,
                                                  ), // mesma borda do enabled
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF27272A),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Height",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                234,
                                                255,
                                                255,
                                                255,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          TextFormField(
                                            enabled: isEditing,
                                            controller: heightController,
                                            style: TextStyle(
                                              color: isEditing
                                                  ? Colors.white
                                                  : Colors.white54,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFF1C1C1C,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF27272A),
                                                ),
                                              ),

                                              disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: const BorderSide(
                                                  color: Color(
                                                    0xFF27272A,
                                                  ), // mesma borda do enabled
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF27272A),
                                                ),
                                              ),
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
                    Row(
                      children: [
                        Expanded(
                          child: MainCard(
                            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                /// Título
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.adjust,
                                      color: Color(0xFFFF6900),
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Fitness Goal",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                _buildGoalOption("BUILD_MUSCLE"),
                                const SizedBox(height: 12),
                                _buildGoalOption("LOSE_WEIGHT"),
                                const SizedBox(height: 12),
                                _buildGoalOption("STAY_FIT"),
                                const SizedBox(height: 12),
                                _buildGoalOption("INCREASE_STRENGTH"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 24),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _logout();
                              },
                              icon: const Icon(
                                Icons.logout,
                                size: 18,
                                color: Color(0xFFEF4444),
                              ),
                              label: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                side: const BorderSide(
                                  color: Color(
                                    0xFF7F1D1D,
                                  ), // borda vermelha escura
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Color(0xFF111113),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
