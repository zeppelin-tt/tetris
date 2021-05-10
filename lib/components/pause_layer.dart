import 'package:flutter/material.dart';

class GlassOverlay extends StatelessWidget {
  final bool pauseEnable;
  final double glassHeight;

  const GlassOverlay({
    required this.pauseEnable,
    required this.glassHeight,
  });

  @override
  Widget build(BuildContext context) {
    final rectSize = glassHeight / 21;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: rectSize * 10.28,
      height: glassHeight - rectSize * .86,
      decoration: BoxDecoration(
        color: pauseEnable ? Colors.black.withOpacity(.8) : Colors.transparent,
        border: const Border(
          left: BorderSide(color: Colors.yellow, width: 2.0),
          right: BorderSide(color: Colors.yellow, width: 2.0),
          bottom: BorderSide(color: Colors.yellow, width: 2.0),
        ),
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          style: pauseEnable ? const TextStyle(color: Colors.yellow, fontSize: 56.0) : const TextStyle(color: Colors.transparent, fontSize: 4.0),
          duration: const Duration(milliseconds: 500),
          child: const Text('Pause'),
        ),
      ),
    );
  }
}
