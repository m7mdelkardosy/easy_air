import 'package:easyair_app/screens/booking_confirmation_screen.dart';
import 'package:easyair_app/widgets/credit_filter.dart';
import 'package:flutter/material.dart';
import 'package:easyair_app/widgets/order_summary_card.dart';
import 'package:easyair_app/widgets/credit_card_widget.dart';
import 'package:easyair_app/widgets/fawry_payment_widget.dart';
import 'package:flutter/services.dart';
import 'package:easyair_app/services/booking_service.dart';
import 'package:easyair_app/models/flight_model.dart';

class CheckoutScreen extends StatefulWidget {
  final FlightModel flight; // 👈 الرحلة الحقيقية
  final int passengerCount;
  final String selectedClass;
  final double totalPrice;
  final List<String> selectedSeats;
  final List<String> passengerNames;

  const CheckoutScreen({
    super.key,
    required this.flight,
    required this.passengerCount,
    required this.selectedClass,
    required this.totalPrice,
    required this.selectedSeats,
    required this.passengerNames,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedPaymentMethod = 0; // 0 = Card, 1 = Fawry
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final cardNumberController = TextEditingController();
  final cardNameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final fawryPhoneController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    cardNameController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    fawryPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF101C2E),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. كارت ملخص الطلب النضيف
            OrderSummaryCard(
              fromCode: widget.flight.fromCode,
              toCode: widget.flight.toCode,
              date: widget.flight.date,
              passengerCount: widget.passengerCount,
              selectedClass: widget.selectedClass,
              totalPrice: widget.totalPrice,
              selectedSeats: widget.selectedSeats,
            ),

            const SizedBox(height: 20),

            // 2. أزرار الاختيار (Card / Fawry)
            Row(
              children: [
                Expanded(child: _buildTab(0, 'Card', Icons.credit_card)),
                const SizedBox(width: 12),
                Expanded(child: _buildTab(1, 'myFawry', Icons.receipt_long)),
              ],
            ),

            const SizedBox(height: 20),

            // 3. المحتوى بناءً على الاختيار
            if (selectedPaymentMethod == 0)
              _buildCardForm()
            else
              FawryPaymentWidget(phoneController: fawryPhoneController),
          ],
        ),
      ),

      // 4. زرار الدفع
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              _processPayment(); // 👈 تأكد إن الدالة بتتنادى هنا بين الأقواس
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB73F),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Pay \$${widget.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
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

  // ودجت صغيرة لتبويب الاختيار
  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEBF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF0066CC) : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF0066CC) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // فورم الدفع بالفيزا
  Widget _buildCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CreditCardWidget(
            cardNumber: cardNumberController.text,
            cardHolder: cardNameController.text,
            expiryDate: expiryController.text,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // أرقام بس
              LengthLimitingTextInputFormatter(16), // أقصى حد 16 رقم
              CardNumberFormatter(), // رص كل 4 أرقام بمسافة
            ],
            onChanged: (_) => setState(() {}),

            // 👇 2. التفتيش: بيشيل المسافات ويتأكد إنهم 16 رقم بالضبط!
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              }
              String cleanNumber = value.replaceAll(' ', '');
              if (cleanNumber.length < 16) {
                return 'Card number must be exactly 16 digits';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Card Number',
              prefixIcon: const Icon(Icons.credit_card),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: cardNameController,
            onChanged: (_) => setState(() {}),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter cardholder name' : null,
            decoration: InputDecoration(
              hintText: 'Cardholder Name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: expiryController,
                  keyboardType: TextInputType.number,
                  maxLength: 5, // 4 أرقام + السلاش /
                  validator: (v) {
                    if (v == null || v.length < 5 || !v.contains('/')) {
                      return 'MM/YY';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'MM/YY',
                    counterText: '',
                    prefixIcon: const Icon(Icons.calendar_today, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: cvvController,
                  obscureText: true,
                  maxLength: 3,
                  validator: (v) => (v == null || v.length < 3) ? 'CVV' : null,
                  decoration: InputDecoration(
                    hintText: 'CVV',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🚀 تنفيذ الدفع والانتقال المباشر للتذاكر
  Future<void> _processPayment() async {
    // 1. التفتيش على المدخلات
    if (selectedPaymentMethod == 0 && !_formKey.currentState!.validate()) {
      return;
    }
    if (selectedPaymentMethod == 1 && fawryPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your Fawry phone number!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. 🪄 سحر الـ Clean Code: سطر واحد بس بيعمل ويحفظ الحجز جوه الـ Service!
    final booking = await BookingService.instance.createAndSaveBooking(
      flight: widget.flight,
      passengerCount: widget.passengerCount,
      selectedClass: widget.selectedClass,
      totalPrice: widget.totalPrice,
      selectedSeats: widget.selectedSeats,
      passengerNames: widget.passengerNames,
      paymentMethod: selectedPaymentMethod == 0 ? 'Card' : 'Fawry',
    );

    if (!mounted) return;

    // 3. الانتقال المباشر لشاشة التأكيد
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          flightNumber: booking.flightNumber,
          fromCode: booking.fromCode,
          toCode: booking.toCode,
          departTime: booking.departTime,
          arriveTime: booking.arriveTime,
          date: booking.date,
          selectedClass: booking.selectedClass,
          selectedSeats: booking.seats,
          passengerNames: booking.passengerNames,
        ),
      ),
    );
  }
}
