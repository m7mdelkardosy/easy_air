import 'dart:convert';
import 'package:easyair_app/screens/flight_details/flight_details_screen.dart';
import 'package:easyair_app/widgets/flight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easyair_app/models/flight_model.dart';

class SearchResultsScreen extends StatefulWidget {
  // 1. المتغيرات اللي الشاشة دي مستنياها من الـ Home
  final String fromCode;
  final String toCode;
  final DateTime selectedDate;

  const SearchResultsScreen({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.selectedDate,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<FlightModel> filteredFlights = [];
  bool isLoading = true; // عشان نعد أسبقية التحميل (Loading indicator)

  @override
  void initState() {
    super.initState();
    loadAndFilterFlights();
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // 2. دالة قراءة وتفلترة الرحلات
  Future<void> loadAndFilterFlights() async {
    // أ. نقرأ ملف الـ JSON بتاع الرحلات
    final String response = await rootBundle.loadString(
      'assets/data/flights.json',
    );
    final List<dynamic> data = json.decode(response);

    // ب. نحول الـ JSON لـ List of FlightModel
    List<FlightModel> allFlights = data
        .map((item) => FlightModel.fromJson(item))
        .toList();

    // ج. الفلترة السحرية: بنجيب بس الرحلات اللي الـ fromCode والـ toCode بتوعها مظبوطين
    setState(() {
      filteredFlights = allFlights.where((flight) {
        return flight.fromCode == widget.fromCode &&
            flight.toCode == widget.toCode;
      }).toList();

      isLoading = false; // خلصنا تحميل
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      // AppBar مؤقت للتجربة
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 14, 1, 39),
        centerTitle: true, // 👈 عشان الكلام كله يتوسط تحت بعضه
        title: Column(
          mainAxisSize:
              MainAxisSize.min, // عشان الـ Column تاخد أقل مساحة ممكنة بس
          children: [
            // السطر الأول: الطريق (CAI ✈ DXB)
            Text(
              '${widget.fromCode} ✈ ${widget.toCode}',
              style: const TextStyle(
                fontFamily: 'Moves',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 4),

            // السطر الثاني: التاريخ بخط صغير
            Text(
              _formatDate(widget.selectedDate),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFBBC7DF), // لون رمادي فاتح شيك
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredFlights.isEmpty
          ? const Center(
              child: Text(
                'No flights found for this route.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFlights.length,
              itemBuilder: (context, index) {
                final flight = filteredFlights[index];
                return FlightCard(
                  flight: flight,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlightDetailsScreen(flight: flight),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
