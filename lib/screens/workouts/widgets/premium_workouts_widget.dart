import 'package:flutter/material.dart';
import 'package:workon_app/widgets/main_card.dart';

class PremiumWorkoutsWidget extends StatefulWidget {
  const PremiumWorkoutsWidget({super.key});

  @override
  State<PremiumWorkoutsWidget> createState() => _PremiumWorkoutsWidgetState();
}

class _PremiumWorkoutsWidgetState extends State<PremiumWorkoutsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: const Text(
                  'Criar Novo Treino',
                  style: TextStyle(color: Color(0xFF000000)),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFFFF6900),
                  iconColor: Color(0xFF000000),
                  iconAlignment: IconAlignment.start,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        MainCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 17),
                    Icon(
                      Icons.fitness_center_outlined,
                      color: Color(0xFF3F3F46),
                      size: 55,
                    ),
                    SizedBox(height: 30),
                    const Text(
                      'Nenhum Treino Premium Ainda',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 30),
                    const Text(
                      'Treinos premium criados por personais certificados vão aparecer aqui',
                      style: TextStyle(color: Color(0xFF9F9F9C), fontSize: 15),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
        MainCard(
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
                          child: const Text(
                            'Full Body Strength',
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
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 0,
                            ),
                            child: Text(
                              'Intermediate',
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
                            'Complete workout targeting all major muscle groups',
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
                          '45 min',
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
                          '8 exercicios',
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
                            onPressed: () {},
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
        ),
      ],
    );
  }
}
