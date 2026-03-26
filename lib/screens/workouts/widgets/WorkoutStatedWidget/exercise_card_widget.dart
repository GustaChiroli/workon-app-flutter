import 'package:flutter/material.dart';
import 'package:workon_app/model/workout/workout_execution_model.dart';
import 'package:workon_app/model/workout/workout_exercise_model.dart';
import 'package:workon_app/widgets/main_card.dart';

class ExerciseCard extends StatefulWidget {
  final WorkoutExercise data;
  final WorkoutExecution execution;

  const ExerciseCard({super.key, required this.data, required this.execution});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late List<WorkoutExecution> executionList;
  late TextEditingController restController;
  // @override
  // void initState() {
  //   super.initState();

  //   setsController = TextEditingController(
  //     text: widget.execution.sets?.toString() ?? '',
  //   );

  //   repsController = TextEditingController(
  //     text: widget.execution.reps?.toString() ?? '',
  //   );

  //   durationController = TextEditingController(
  //     text: widget.execution.durationSeconds?.toString() ?? '',
  //   );

  //   restController = TextEditingController(
  //     text: widget.execution.restSeconds?.toString() ?? '',
  //   );

  //   weightController = TextEditingController(
  //     text: widget.execution.weight?.toString() ?? '',
  //   );

  //   // 🔥 AQUI ESTÁ A CORREÇÃO
  //   _syncInitialValues();
  // }

  // void _syncInitialValues() {
  //   widget.execution.sets ??= int.tryParse(setsController.text);
  //   widget.execution.reps ??= int.tryParse(repsController.text);
  //   widget.execution.durationSeconds ??= int.tryParse(durationController.text);
  //   widget.execution.restSeconds ??= int.tryParse(restController.text);
  //   widget.execution.weight ??= double.tryParse(weightController.text);
  // }

  void _addSet() {
    setState(() {
      widget.execution.sets.add(
        SetExecution(setNumber: widget.execution.sets.length + 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print('\n\n\n\nAQUI: ${widget.data.exercise.description} \n\n\n');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MainCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.exercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF472816),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.data.exercise.muscleGroup,
                style: const TextStyle(
                  color: Color(0xFFFF6900),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                ...widget.execution.sets.map((set) {
                  return _setItem(set);
                }).toList(),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: _addSet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6900),
                  ),
                  child: const Text(
                    "+ Adicionar série",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

            // Row(
            //   children: [
            //     _inputField("Séries", setsController, (v) {
            //       widget.execution.sets = int.tryParse(v);
            //     }),
            //     SizedBox(width: 10),
            //     _inputField("Reps", repsController, (v) {
            //       widget.execution.reps = int.tryParse(v);
            //     }),
            //     SizedBox(width: 10),
            //     _inputField("Tempo", durationController, (v) {
            //       widget.execution.durationSeconds = int.tryParse(v);
            //     }),
            //     SizedBox(width: 10),
            //     _inputField("Descanso", restController, (v) {
            //       widget.execution.restSeconds = int.tryParse(v);
            //     }),
            //   ],
            // ),
            const SizedBox(height: 10),

            const SizedBox(height: 10),

            Text(
              widget.data.exercise.description ?? '',
              style: TextStyle(color: Color(0xFF9F9FA9), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setItem(SetExecution set) {
    final repsController = TextEditingController(
      text: set.reps?.toString() ?? '',
    );

    final weightController = TextEditingController(
      text: set.weight?.toString() ?? '',
    );

    final durationController = TextEditingController(
      text: set.durationSeconds?.toString() ?? '',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MainCard(
        padding: const EdgeInsets.all(8),
        radiusBorder: 10,
        BGcolor: Color(0xFF27272A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Série ${set.setNumber}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _fieldWithLabel(
                    label: "Reps",
                    controller: repsController,
                    onChanged: (v) => set.reps = int.tryParse(v),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _fieldWithLabel(
                    label: "Carga",
                    controller: weightController,
                    onChanged: (v) => set.weight = double.tryParse(v),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _fieldWithLabel(
                    label: "Tempo",
                    controller: durationController,
                    onChanged: (v) => set.durationSeconds = int.tryParse(v),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldWithLabel({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9F9FA9)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFF1F1F22),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Expanded(
      child: MainCard(
        padding: const EdgeInsets.all(8),
        radiusBorder: 10,
        BGcolor: Color(0xFF27272A),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9F9FA9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xFF1F1F22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
