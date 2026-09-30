import 'package:flutter/material.dart';
import 'package:easyair_app/models/booking_model.dart';
import 'package:easyair_app/services/booking_service.dart';
import 'package:easyair_app/screens/booking_confirmation_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 تابات (Upcoming & Past)
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'My Bookings',
            style: TextStyle(
              color: Color(0xFF101C2E),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFFFFB73F), // أصفر برتقالي للتاب النشط
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFFFB73F),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past Flights'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // التاب 1: الرحلات القادمة
            _buildBookingsList(isUpcoming: true),

            // التاب 2: الرحلات القديمة
            _buildBookingsList(isUpcoming: false),
          ],
        ),
      ),
    );
  }

  // ودجت قراءة وجلب الحجوزات من الـ BookingService
  Widget _buildBookingsList({required bool isUpcoming}) {
    return FutureBuilder<List<BookingModel>>(
      future: isUpcoming
          ? BookingService.instance.getUpcomingBookings()
          : BookingService.instance.getPastBookings(),
      builder: (context, snapshot) {
        // 1. حالة التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = snapshot.data ?? [];

        // 2. لو مفيش حجوزات (Empty State)
        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.airplane_ticket_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  isUpcoming ? 'No upcoming flights' : 'No past flights',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101C2E),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'When you book a flight, it will appear here.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // 3. عرض قائمة الحجوزات
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return _buildBookingCard(booking);
          },
        );
      },
    );
  }

  // كارت الرحلة المحجوزة
  Widget _buildBookingCard(BookingModel booking) {
    return GestureDetector(
      onTap: () {
        // لما يضغط على الرحلة المحجوزة بتفتح التذكرة والـ QR كود تاني!
        Navigator.push(
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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PNR: ${booking.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0066CC),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.fromCode,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101C2E),
                      ),
                    ),
                    Text(booking.departTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Icon(Icons.flight_takeoff, color: Color(0xFFFFB73F)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      booking.toCode,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101C2E),
                      ),
                    ),
                    Text(booking.arriveTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${booking.date} • ${booking.selectedClass}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Seats: ${booking.seats.join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101C2E),
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