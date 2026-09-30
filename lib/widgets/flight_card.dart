import 'package:flutter/material.dart';
import 'package:easyair_app/models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onTap;

  const FlightCard({super.key, required this.flight, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EDF5), width: 1.5),
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
            // ─── الصف العلوي: اسم الشركة + Direct ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.airline,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101C2E),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: flight.isDirect
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    flight.isDirect ? 'Direct' : 'Stop',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: flight.isDirect
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ─── الصف الأوسط: الأوقات + المدة ───
            Row(
              children: [
                // وقت الإقلاع + كود المطار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.departureTime,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101C2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.fromCode,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A94A6),
                        ),
                      ),
                    ],
                  ),
                ),

                // المدة + خط الطيارة في النص
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        flight.duration,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A94A6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: const Color(0xFFD0D7E2),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),

                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.flight,
                                size: 18,
                                color: Color.fromARGB(255, 15, 88, 197),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: const Color(0xFFD0D7E2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // وقت الوصول + كود المطار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        flight.arrivalTime,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101C2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.toCode,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A94A6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ─── الصف السفلي: per person + السعر ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'per person',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
                ),
                Text(
                  '\$${flight.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFB73F),
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
