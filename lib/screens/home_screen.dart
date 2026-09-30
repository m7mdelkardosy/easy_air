import 'dart:convert';

import 'package:easyair_app/models/airports.dart';
import 'package:easyair_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AirportModel> airportsList = [];
  AirportModel? selectedFromAirport;
  AirportModel? selectedToAirport;
  DateTime? selectedDepartureDate;
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAirports();
  }

  Future<void> loadAirports() async {
    final String response = await rootBundle.loadString(
      'assets/data/airports.json',
    );

    final List<dynamic> data = json.decode(response) as List<dynamic>;

    setState(() {
      airportsList = data.map((item) => AirportModel.fromJson(item)).toList();
    });
  }

  Future<void> _selectDepartureDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDepartureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    );

    if (picked != null) {
      setState(() {
        selectedDepartureDate = picked;
        dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 2. 👇 استبدل النص القديم بـ StreamBuilder الذكي ده:
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(), // 📡 بيسمع لأي تغيير في بيانات المستند لايف
      builder: (context, snapshot) {
        String userName = 'Traveler';

        // لو البيانات رجعت من Firestore بنجاح
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          userName = data?['name'] ?? 'Traveler';
        } else if (user?.displayName != null && user!.displayName!.isNotEmpty) {
          userName = user.displayName!;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 540,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 200,
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 30,
                                left: 24,
                                right: 24,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF101C2E),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(36),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Morning,\n$userName!',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Where are we flying today?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFBBC7DF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 150,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 380,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'Flights',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF101C2E),
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -15),
                                    child: Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Autocomplete<AirportModel>(
                                      displayStringForOption:
                                          (AirportModel option) =>
                                              '${option.city} (${option.code})',
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                            if (textEditingValue.text.isEmpty) {
                                              return const Iterable<
                                                AirportModel
                                              >.empty();
                                            }

                                            final query = textEditingValue.text
                                                .toLowerCase();
                                            return airportsList.where((
                                              airport,
                                            ) {
                                              return airport.city
                                                      .toLowerCase()
                                                      .contains(query) ||
                                                  airport.code
                                                      .toLowerCase()
                                                      .contains(query) ||
                                                  airport.name
                                                      .toLowerCase()
                                                      .contains(query);
                                            });
                                          },
                                      onSelected: (AirportModel selection) {
                                        setState(() {
                                          selectedFromAirport = selection;
                                        });
                                      },
                                      fieldViewBuilder:
                                          (
                                            context,
                                            controller,
                                            focusNode,
                                            onFieldSubmitted,
                                          ) {
                                            return TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                hintText: 'From (City or Code)',
                                                prefixIcon: const Icon(
                                                  Icons.flight_takeoff,
                                                  color: Color.fromARGB(
                                                    255,
                                                    170,
                                                    168,
                                                    164,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Autocomplete<AirportModel>(
                                      displayStringForOption:
                                          (AirportModel option) =>
                                              '${option.city} (${option.code})',
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                            if (textEditingValue.text.isEmpty) {
                                              return const Iterable<
                                                AirportModel
                                              >.empty();
                                            }

                                            final query = textEditingValue.text
                                                .toLowerCase();
                                            return airportsList.where((
                                              airport,
                                            ) {
                                              if (selectedFromAirport != null &&
                                                  airport.code ==
                                                      selectedFromAirport!
                                                          .code) {
                                                return false;
                                              }

                                              return airport.name
                                                      .toLowerCase()
                                                      .contains(query) ||
                                                  airport.city
                                                      .toLowerCase()
                                                      .contains(query) ||
                                                  airport.country
                                                      .toLowerCase()
                                                      .contains(query) ||
                                                  airport.code
                                                      .toLowerCase()
                                                      .contains(query);
                                            });
                                          },
                                      onSelected: (AirportModel selection) {
                                        setState(() {
                                          selectedToAirport = selection;
                                        });
                                      },
                                      fieldViewBuilder:
                                          (
                                            context,
                                            controller,
                                            focusNode,
                                            onFieldSubmitted,
                                          ) {
                                            return TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'To (City, Airport, or Code)',
                                                prefixIcon: const Icon(
                                                  Icons.flight_land,
                                                  color: Color.fromARGB(
                                                    255,
                                                    170,
                                                    168,
                                                    164,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: TextFormField(
                                      controller: dateController,
                                      readOnly: true,
                                      onTap: () =>
                                          _selectDepartureDate(context),
                                      decoration: InputDecoration(
                                        hintText: 'Departure Date',
                                        prefixIcon: const Icon(
                                          Icons.calendar_month,
                                          color: Colors.blueAccent,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // اللوجيك: نتأكد إن البيانات اتختارت قبل ما ننقل الشاشة
                                          if (selectedFromAirport == null ||
                                              selectedToAirport == null ||
                                              selectedDepartureDate == null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please select From, To, and Departure Date!',
                                                ),
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            return;
                                          }

                                          // الانتقال لشاشة النتائج مع بعث البيانات
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchResultsScreen(
                                                    fromCode:
                                                        selectedFromAirport!
                                                            .code,
                                                    toCode:
                                                        selectedToAirport!.code,
                                                    selectedDate:
                                                        selectedDepartureDate!,
                                                  ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFFFB73F,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Search Flights',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF0A1628),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Powered by EasyAir',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101C2E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
