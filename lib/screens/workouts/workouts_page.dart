import 'package:flutter/material.dart';
import 'package:workon_app/screens/social/widgets/explore_widget.dart';
import 'package:workon_app/screens/social/widgets/general_feed_widget.dart';
import 'package:workon_app/screens/social/widgets/my_feed_widget.dart';
import 'package:workon_app/screens/workouts/widgets/free_workouts_widget.dart';
import 'package:workon_app/screens/workouts/widgets/my_workouts_widget.dart';
import 'package:workon_app/screens/workouts/widgets/premium_workouts_widget.dart';
import 'package:workon_app/widgets/main_card.dart';
import 'package:workon_app/widgets/page_base_widget.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  int selectedButtonIndex = 1;
  @override
  Widget build(BuildContext context) {
    return PageBaseWidget(
      title: "Treinos",
      subtitle: "Escolha seu plano de treino",
      child: Column(
        spacing: 20,
        children: [
          MainCard(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 0),
            BGcolor: Color(0xFF18181B),
            haveBorder: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        selectedButtonIndex == 1
                            ? Color(0xFF27272A)
                            : Color(0xFF18181B),
                      ),

                      visualDensity: VisualDensity.compact,
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButtonIndex = 1;
                      });
                    },
                    child: Text(
                      'Gratuitos',
                      style: TextStyle(
                        color: selectedButtonIndex == 1
                            ? Color(0xFFFF6900)
                            : Color(0xFF989898),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        selectedButtonIndex == 2
                            ? Color(0xFF27272A)
                            : Color(0xFF18181B),
                      ),

                      visualDensity: VisualDensity.compact,
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButtonIndex = 2;
                      });
                    },
                    child: Text(
                      'Meus',
                      style: TextStyle(
                        color: selectedButtonIndex == 2
                            ? Color(0xFFFF6900)
                            : Color(0xFF989898),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        selectedButtonIndex == 3
                            ? Color(0xFF27272A)
                            : Color(0xFF18181B),
                      ),

                      visualDensity: VisualDensity.compact,
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButtonIndex = 3;
                      });
                    },
                    child: Text(
                      'Comprar',
                      style: TextStyle(
                        color: selectedButtonIndex == 3
                            ? Color(0xFFFF6900)
                            : Color(0xFF989898),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          selectedButtonIndex == 1
              ? FreeWorkoutsWidget()
              : selectedButtonIndex == 2
              ? MyWorkoutsWidget()
              : PremiumWorkoutsWidget(),
        ],
      ),
    );
  }
}
