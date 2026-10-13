import 'package:easy_localization/easy_localization.dart';
import 'package:easyair_app/screens/flight_details/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:easyair_app/models/flight_model.dart';
import 'package:easyair_app/widgets/flight_route_map.dart'; // 👈 استيراد الخريطة
import 'package:easyair_app/widgets/class_selection_card.dart'; // 👈 استيراد الكارت
import 'package:easyair_app/widgets/passenger_counter.dart';

class FlightDetailsScreen extends StatefulWidget {
  final FlightModel flight;

  const FlightDetailsScreen({super.key, required this.flight});

  @override
  State<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  int selectedClassIndex = 0;
  int passengerCount = 1;

  late final List<Map<String, dynamic>> classes = [
    {
      'name': 'economy'.tr(),
      'subtitle': 'standard_legroom'.tr(),
      'price': widget.flight.price,
      'features': ['cabin_bag_1', 'no_checked_bag'],
    },
    {
      'name': 'business'.tr(),
      'subtitle': 'lounge_access'.tr(),
      'price': widget.flight.price * 2.5,
      'features': ['cabin_bag_2', 'checked_bag_2'],
    },
    {
      'name': 'first_class'.tr(),
      'subtitle': 'private_suite'.tr(),
      'price': widget.flight.price * 7,
      'features': ['cabin_bag_2', 'checked_bag_3'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final num basePrice = classes[selectedClassIndex]['price'];
    final num totalPrice = basePrice * passengerCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'EasyAir',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF101C2E),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. الخريطة النضيفة (سطر واحد!)
          FlightRouteMap(
            fromCode: widget.flight.fromCode,
            toCode: widget.flight.toCode,
          ),

          const SizedBox(height: 20),
          // عداد المسافرين المفصول
          PassengerCounter(
            count: passengerCount,
            onChanged: (value) {
              setState(() {
                passengerCount = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // 2. عنوان الدرجات
          Text(
            'select_your_class'.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 3. قائمة الكروت النضيفة
          ...List.generate(classes.length, (index) {
            final classData = classes[index];
            return ClassSelectionCard(
              title: classData['name'],
              subtitle: classData['subtitle'],
              price: classData['price'],
              features: List<String>.from(classData['features']),
              isSelected: selectedClassIndex == index,
              onTap: () {
                setState(() {
                  selectedClassIndex = index;
                });
              },
            );
          }),
        ],
      ),

      // 4. الشريط السفلي السريع
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total_price'.tr(),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  'total_for_passengers'.tr(
                    namedArgs: {'count': passengerCount.toString()},
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // 2. سطر عرض السعر الإجمالي (المبلغ)
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101C2E),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // 1. حساب السعر الأساسي (سعر الكلاس × عدد المسافرين)
                final double calculatedBasePrice =
                    (classes[selectedClassIndex]['price'] as double) *
                    passengerCount;

                // 2. الانتقال لشاشة الكراسي وتمرير البيانات
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeatSelectionScreen(
                      flight: widget.flight, // 👈 بنبعت الرحلة الحقيقية كاملة!
                      passengerCount: passengerCount,
                      selectedClass: classes[selectedClassIndex]['name'],
                      basePrice: calculatedBasePrice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB73F),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'continue'.tr(),
                style: TextStyle(
                  color: Color(0xFF0A1628),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
