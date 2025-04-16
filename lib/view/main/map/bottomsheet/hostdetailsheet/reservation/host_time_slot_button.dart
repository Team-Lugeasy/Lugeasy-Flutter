import 'package:flutter/material.dart';

enum TimeSlotState { enabled, disabled, selected }

class TimeSlotButton extends StatelessWidget {
  final String label;
  final TimeSlotState state;
  final VoidCallback? onTap;

  const TimeSlotButton({
    super.key,
    required this.label,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BorderSide border;

    switch (state) {
      case TimeSlotState.selected:
        bgColor = Colors.black;
        textColor = Colors.white;
        border = BorderSide.none;
        break;
      case TimeSlotState.disabled:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey;
        border = BorderSide(color: Colors.grey[300]!);
        break;
      case TimeSlotState.enabled:
      default:
        bgColor = Colors.white;
        textColor = Colors.black;
        border = BorderSide(color: Colors.black);
    }

    return GestureDetector(
      onTap: state != TimeSlotState.disabled ? onTap : null,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.fromBorderSide(border),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
