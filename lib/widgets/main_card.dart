import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? BGcolor;
  final bool? haveBorder;

  const MainCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.BGcolor = const Color(0xFF1C1C1E),
    this.haveBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: BGcolor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF27272A),
          width: haveBorder ?? false ? 1 : 0,
        ),
      ),
      child: child,
    );
  }
}
