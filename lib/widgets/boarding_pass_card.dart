import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BoardingPassCard extends StatelessWidget {
  final String flightNumber;
  final String selectedClass;
  final String fromCode;
  final String toCode;
  final String departTime;
  final String arriveTime;
  final String passengerName;
  final String date;
  final String seat;
  final String pnr;
  final String terminal;
  final String gate;
  final String zone;

  const BoardingPassCard({
    super.key,
    required this.flightNumber,
    required this.selectedClass,
    required this.fromCode,
    required this.toCode,
    required this.departTime,
    required this.arriveTime,
    required this.passengerName,
    required this.date,
    required this.seat,
    required this.pnr,
    this.terminal = '3',
    this.gate = 'B7',
    this.zone = '2',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ===== الهيدر =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF101C2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FLIGHT',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                    Text(
                      flightNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB73F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedClass,
                    style: const TextStyle(
                      color: Color(0xFF0A1628),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== المسار =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fromCode,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101C2E),
                        ),
                      ),
                      Text(
                        departTime,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Column(
                  children: [
                    Icon(Icons.flight_takeoff, color: Color(0xFFFFB73F)),
                    SizedBox(height: 4),
                    Text('Direct', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        toCode,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101C2E),
                        ),
                      ),
                      Text(
                        arriveTime,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ===== بيانات المسافر =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _infoItem('PASSENGER', passengerName),
                ),
                Expanded(
                  child: _infoItem('DATE', date),
                ),
              ],
            ),
          ),

          // ===== Terminal / Gate / Seat / Zone =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniBox('TERMINAL', terminal),
                _miniBox('GATE', gate),
                _miniBox('SEAT', seat),
                _miniBox('ZONE', zone),
              ],
            ),
          ),

          // ===== QR =====
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: QrImageView(
              data: 'EASYAIR|$pnr|$seat|$fromCode-$toCode|$passengerName',
              version: QrVersions.auto,
              size: 140,
              backgroundColor: Colors.white,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'PNR: $pnr',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF101C2E),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101C2E),
          ),
        ),
      ],
    );
  }

  Widget _miniBox(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101C2E),
          ),
        ),
      ],
    );
  }
}