import 'package:flutter/material.dart';
import 'package:easyair_app/models/flight_model.dart';
import 'package:easyair_app/widgets/passenger_form_card.dart';
import 'package:easyair_app/screens/checkout_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final FlightModel flight;
  final int passengerCount;
  final String selectedClass;
  final double totalPrice;
  final List<String> selectedSeats;

  const PassengerDetailsScreen({
    super.key,
    required this.flight,
    required this.passengerCount,
    required this.selectedClass,
    required this.totalPrice,
    required this.selectedSeats,
  });

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // لستة Controllers لكل مسافر
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> passportControllers;

  @override
  void initState() {
    super.initState();
    // بنعمل Controllers بعدد المسافرين المختارين
    nameControllers = List.generate(
      widget.passengerCount,
      (_) => TextEditingController(),
    );
    passportControllers = List.generate(
      widget.passengerCount,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var c in nameControllers) {
      c.dispose();
    }
    for (var c in passportControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _continueToCheckout() {
    // 1. التفتيش: تأكيد إن كل المسافرين اتكتبت أسماؤهم صح
    if (_formKey.currentState!.validate()) {
      // 2. تجميع الأسماء الحقيقية
      final List<String> passengerNames = nameControllers
          .map((c) => c.text.trim())
          .toList();

      // 3. الانتقال لصفحة الـ Checkout ومعانا الأسماء
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            flight: widget.flight,
            passengerCount: widget.passengerCount,
            selectedClass: widget.selectedClass,
            totalPrice: widget.totalPrice,
            selectedSeats: widget.selectedSeats,
            passengerNames: passengerNames, // 👈 ببعت الأسماء الحقيقية هنا
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Passenger Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF101C2E),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ملخص سريع فوق
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF0066CC)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please enter details for ${widget.passengerCount} passenger${widget.passengerCount > 1 ? 's' : ''}.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0066CC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // توليد فورم لكل مسافر
            ...List.generate(
              widget.passengerCount,
              (index) => PassengerFormCard(
                index: index,
                nameController: nameControllers[index],
                passportController: passportControllers[index],
              ),
            ),
          ],
        ),
      ),

      // زرار التوجه للدفع
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _continueToCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB73F),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continue to Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1628),
              ),
            ),
          ),
        ),
      ),
    );
  }
}