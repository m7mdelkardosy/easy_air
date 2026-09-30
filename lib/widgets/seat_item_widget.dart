import 'package:flutter/material.dart';
import 'package:easyair_app/models/seat_model.dart';

class SeatItemWidget extends StatelessWidget {
  final SeatModel seat;
  final VoidCallback onTap;

  const SeatItemWidget({
    super.key,
    required this.seat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون الكرسي والأيقونة حسب حالته
    Color bgColor;
    Color borderColor;
    Widget? icon;

    switch (seat.status) {
      case SeatStatus.taken:
        bgColor = const Color(0xFF334155); // رمادي غامق محجوز
        borderColor = Colors.transparent;
        icon = const Icon(Icons.close, size: 16, color: Colors.white38);
        break;
      case SeatStatus.available:
        bgColor = Colors.white; // أبيض فاضي
        borderColor = Colors.grey.shade300;
        break;
      case SeatStatus.premium:
        bgColor = const Color(0xFFE9D5FF); // بنفسجي ممتاز
        borderColor = const Color(0xFFA855F7);
        icon = const Icon(Icons.star, size: 14, color: Color(0xFFA855F7));
        break;
      case SeatStatus.selected:
        bgColor = const Color(0xFFFFB73F); // برتقالي اختياري
        borderColor = const Color(0xFFFFB73F);
        icon = const Icon(Icons.check, size: 18, color: Color(0xFF0A1628));
        break;
    }

    return GestureDetector(
      onTap: seat.status == SeatStatus.taken ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: seat.status == SeatStatus.selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB73F).withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Center(child: icon),
      ),
    );
  }
}