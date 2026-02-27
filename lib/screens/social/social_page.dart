import 'package:flutter/material.dart';
import 'package:workon_app/screens/social/widgets/my_feed_widget.dart';
import 'package:workon_app/widgets/main_card.dart';
import 'package:workon_app/widgets/page_base_widget.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  int selectedButtonIndex = 1;
  @override
  Widget build(BuildContext context) {
    return PageBaseWidget(
      title: "Social",
      subtitle: "Connect with your friends",
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
                    child: const Text(
                      'Feed',
                      style: TextStyle(color: Color(0xFFF14A25)),
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
                    child: const Text(
                      'Exporer',
                      style: TextStyle(color: Color(0xFFF14A25)),
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
                    child: const Text(
                      'My Feed',
                      style: TextStyle(color: Color(0xFFF14A25)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          selectedButtonIndex == 1
              ? Row(children: [Text("tela 1")])
              : selectedButtonIndex == 2
              ? Row(children: [Text("tela 2")])
              : MyFeedWidget(),
        ],
      ),
    );
  }
}
