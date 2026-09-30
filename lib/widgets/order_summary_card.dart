import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final String fromCode;
  final String toCode;
  final String date;
  final int passengerCount;
  final String selectedClass;
  final double totalPrice;
  final List<String> selectedSeats;

  const OrderSummaryCard({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.date,
    required this.passengerCount,
    required this.selectedClass,
    required this.totalPrice,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ORDER SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066CC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$fromCode ✈ $toCode',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF101C2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$date • $passengerCount Passenger${passengerCount > 1 ? 's' : ''}, $selectedClass',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          if (selectedSeats.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Seats: ${selectedSeats.join(', ')}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFB73F),
              ),
            ),
          ],
        ],
      ),
    );
  }
}