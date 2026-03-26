import 'package:flutter/material.dart';
import 'package:workon_app/model/workout/workout_execution_model.dart';
import 'package:workon_app/model/workout/workout_exercise_model.dart';
import 'dart:ui';
import 'package:workon_app/screens/workouts/widgets/WorkoutStatedWidget/exercise_card_widget.dart';
import 'package:workon_app/screens/workouts/widgets/WorkoutStatedWidget/rest_screen_widget.dart';
import 'package:workon_app/services/workout/workouts_service.dart';
import 'package:workon_app/widgets/main_card.dart';

class WorkoutStartedWidget extends StatefulWidget {
  final List<WorkoutExercise> workoutExercises;
  final String workoutId;
  const WorkoutStartedWidget({
    super.key,
    required this.workoutExercises,
    required this.workoutId,
  });

  @override
  State<WorkoutStartedWidget> createState() => _WorkoutStartedWidgetState();
}

class _WorkoutStartedWidgetState extends State<WorkoutStartedWidget> {
  int current = 0;
  late List<WorkoutExecution> executionList;
  @override
  void initState() {
    super.initState();

    executionList = widget.workoutExercises.map((e) {
      final totalSets = e.sets ?? 1;

      return WorkoutExecution(
        exerciseId: e.exercise.id,
        sets: List.generate(totalSets, (index) {
          return SetExecution(
            setNumber: index + 1,
            reps: e.reps,
            durationSeconds: e.durationSeconds,
            weight: 0,
          );
        }),
      );
    }).toList();
  }

  void nextExercise(int? rest) async {
    if (current < widget.workoutExercises.length - 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RestScreen(restSeconds: rest ?? 60)),
      );

      setState(() {
        current++;
      });
    } else {
      print(executionList.toList());
      await WorkoutsService().finishUserWorkout(
        context,
        widget.workoutId,
        executionList,
      );

      Navigator.pop(context);
    }
  }

  void previousExercise() {
    if (current > 0) {
      setState(() {
        current--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (current + 1) / widget.workoutExercises.length;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: const Color(0xFF121212),
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Row(
                children: const [
                  Icon(Icons.fitness_center, color: Color(0xFFFF6900)),
                  SizedBox(width: 10),
                  Text(
                    "WorkOn",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF09090B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Full Body Strength',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.workoutExercises.length} exercícios',
                    style: TextStyle(fontSize: 14, color: Color(0xFF90937C)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: MainCard(
                  BGcolor: const Color(0xFF22120A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progresso',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFFFBD0),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${current + 1}/${widget.workoutExercises.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9F9FA9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFF3A3A3A),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFFF6900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// BOTÕES DE NAVEGAÇÃO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color(0xFFFF6900),
                        ),
                        onPressed: current == 0 ? null : previousExercise,
                        child: const Text(
                          'Anterior',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color(0xFFFF6900),
                        ),
                        onPressed: () => nextExercise(
                          widget.workoutExercises[current].restSeconds,
                        ),
                        child: const Text(
                          'Próximo',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// CARD DO EXERCÍCIO
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ExerciseCard(
                        key: ValueKey(
                          widget.workoutExercises[current].exercise.id,
                        ),
                        data: widget.workoutExercises[current],
                        execution: executionList[current],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
