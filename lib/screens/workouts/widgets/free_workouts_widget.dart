import 'package:flutter/material.dart';
import 'package:workon_app/enums/difficulty.dart';
import 'package:workon_app/model/workout/workout_group_model.dart';
import 'package:workon_app/screens/workouts/widgets/workout_started_widget.dart';
import 'package:workon_app/services/workout/workouts_service.dart';
import 'package:workon_app/widgets/main_card.dart';

class FreeWorkoutsWidget extends StatefulWidget {
  const FreeWorkoutsWidget({super.key});

  @override
  State<FreeWorkoutsWidget> createState() => _FreeWorkoutsWidgetState();
}

class _FreeWorkoutsWidgetState extends State<FreeWorkoutsWidget> {
  List<WorkoutGroup> _workouts = [];

  void initState() {
    super.initState();
    // _getMyPosts();
    // _getImageuser();
    _getFreeWorkouts();
  }

  Future<void> _getFreeWorkouts() async {
    final workoutsService = WorkoutsService();
    try {
      final response = await workoutsService.getFreeWorkouts();
      if (response != null && response.isNotEmpty) {
        setState(() {
          _workouts = response;
        });
      }
      print('\n\n\n\n\n AQUI: ${_workouts.first.name} \n\n\n\n\n');
    } catch (e) {
      print("Error saving profile changes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        ..._workouts.map((item) {
          return MainCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF472816),
                      ),
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Icon(
                        Icons.fitness_center_outlined,
                        color: Color(0xFFFF6900),
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF27272A),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 0,
                              ),
                              child: Text(
                                DifficultyExtension.fromString(
                                  item.difficulty,
                                ).toPtBr(),
                                style: TextStyle(
                                  color: Color(0xFFD95800),

                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.workouts.first.description ??
                                  "no description for this workout",
                              style: TextStyle(color: Color(0xFF9F9FA9)),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: Color(0xFF71717B),
                            size: 19,
                          ),
                          Text(
                            item.estimatedDurationMinutes.toString(),
                            style: TextStyle(
                              color: Color(0xFF71717B),
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 7),
                          Icon(
                            Icons.fitness_center_outlined,
                            color: Color(0xFF71717B),
                            size: 19,
                          ),
                          Text(
                            item.workouts.length.toString(),
                            style: TextStyle(
                              color: Color(0xFF71717B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color(0xFFFF6900),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WorkoutStartedWidget(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Começar Treino',
                                style: TextStyle(color: Color(0xFF000000)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
