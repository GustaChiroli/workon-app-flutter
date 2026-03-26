import 'package:flutter/material.dart';

class RestScreen extends StatefulWidget {
  final int restSeconds;
  const RestScreen({super.key, required this.restSeconds});

  @override
  State<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  int seconds = 10;

  @override
  void initState() {
    super.initState();
    seconds = widget.restSeconds;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (seconds == 0) {
        Navigator.pop(context);
        return false;
      }

      setState(() {
        seconds--;
      });

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = seconds / widget.restSeconds;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Descanso",
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),

            const SizedBox(height: 30),

            Text(
              "$seconds",
              style: const TextStyle(
                fontSize: 48,
                color: Color(0xFFFF6900),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 250,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: const Color(0xFF3A3A3A),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6900)),
              ),
            ),
            SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(0xFFFF6900),
                  ),
                  onPressed: () => {Navigator.pop(context)},
                  child: const Text(
                    'Pular',
                    style: TextStyle(color: Color(0xFF000000)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
