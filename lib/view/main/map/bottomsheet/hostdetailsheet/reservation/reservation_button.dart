import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const ReservationButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 62,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDADADA),
            foregroundColor: Colors.black,
            elevation: 8, // 그림자 깊이
            shadowColor: const Color(0x26000000), // #000000 15%
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            AppLocalizations.of(context)!.reservation,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              height: 1,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
