import 'package:flutter/material.dart';
import 'package:easyair_app/widgets/boarding_pass_card.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String flightNumber;
  final String fromCode;
  final String toCode;
  final String departTime;
  final String arriveTime;
  final String date;
  final String selectedClass;
  final List<String> selectedSeats;
  final List<String> passengerNames; // لو معندكش أسماء، هنبعت placeholders

  const BookingConfirmationScreen({
    super.key,
    required this.flightNumber,
    required this.fromCode,
    required this.toCode,
    required this.departTime,
    required this.arriveTime,
    required this.date,
    required this.selectedClass,
    required this.selectedSeats,
    List<String>? passengerNames,
  }) : passengerNames = passengerNames ?? const [];

  String _generatePnr(int index) {
    // PNR بسيط وشكله واقعي
    return 'XB${7 + index}BM${2 + index}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF101C2E),
        centerTitle: true,
        title: const Text(
          'EasyAir',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== رسالة النجاح =====
          Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 40),
              ),
              const SizedBox(height: 12),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101C2E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your itinerary to $toCode is ready.',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ===== تذكرة لكل مسافر / كرسي =====
          ...List.generate(selectedSeats.length, (index) {
            final seat = selectedSeats[index];
            final name =
                (passengerNames.length > index &&
                    passengerNames[index].isNotEmpty)
                ? passengerNames[index]
                : 'Passenger ${index + 1}';

            return BoardingPassCard(
              flightNumber: flightNumber,
              selectedClass: selectedClass,
              fromCode: fromCode,
              toCode: toCode,
              departTime: departTime,
              arriveTime: arriveTime,
              passengerName: name,
              date: date,
              seat: seat, // 👈 الكرسي الحقيقي
              pnr: _generatePnr(index),
              terminal: '3', // ثابت مؤقتًا
              gate: 'B7', // ثابت مؤقتًا
              zone: '2', // ثابت مؤقتًا
            );
          }),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB73F),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Back to Home',
              style: TextStyle(
                color: Color(0xFF0A1628),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
