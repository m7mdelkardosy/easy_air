import 'package:flutter/material.dart';

class PassengerCounter extends StatelessWidget {
  final int count;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const PassengerCounter({
    super.key,
    required this.count,
    required this.onChanged,
    this.min = 1,
    this.max = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.person_outline, color: Color(0xFF101C2E)),
              SizedBox(width: 8),
              Text(
                'Passengers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101C2E),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: count > min
                    ? () => onChanged(count - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: count > min ? const Color(0xFF101C2E) : Colors.grey,
              ),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101C2E),
                ),
              ),
              IconButton(
                onPressed: count < max
                    ? () => onChanged(count + 1)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: count < max ? const Color(0xFFFFB73F) : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}