import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TetrisButton extends StatefulWidget {
  final double size;
  final IconData icon;
  final double iconSize;
  final Color color;
  final Color onPressColor;
  final GestureTapCallback onTap;
  final GestureLongPressStartCallback onLongPressStart;
  final GestureLongPressEndCallback onLongPressEnd;
  final GestureTapDownCallback onTapDown;


  @override
  _TetrisButtonState createState() => _TetrisButtonState();

  const TetrisButton({
    @required this.size,
    @required this.icon,
    @required this.iconSize,
    @required this.color,
    @required this.onPressColor,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onTapDown,
  });
}

class _TetrisButtonState extends State<TetrisButton> {
  bool onPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        HapticFeedback.lightImpact();
        setState(() => onPressed = true);
        if (widget.onLongPressStart != null) {
          widget.onLongPressStart(details);
        }
      },
      onLongPressEnd: (details) {
        setState(() => onPressed = false);
        if (widget.onLongPressEnd != null) {
          widget.onLongPressEnd(details);
        }
      },
      onTapDown: (details) {
        HapticFeedback.lightImpact();
        setState(() => onPressed = true);
        if (widget.onTapDown != null) {
          widget.onTapDown(details);
        }
      },
      onTapUp: (_) {
        setState(() => onPressed = false);
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      onTapCancel: () => setState(() => onPressed = false),
      child: ClipOval(
        child: Container(
          height: widget.size,
          width: widget.size,
          color: onPressed ? widget.onPressColor : widget.color,
          child: Center(
            child: Icon(
              widget.icon,
              color: Colors.black,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}