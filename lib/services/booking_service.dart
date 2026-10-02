import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easyair_app/models/booking_model.dart';
import 'package:easyair_app/models/flight_model.dart';

class BookingService {
  BookingService._privateConstructor();
  static final BookingService instance = BookingService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 💺 1. جلب الكراسي المحجوزة أونلاين بدقة وبدون أي Indexes!
  Future<List<String>> getBookedSeatsForFlight({
    required String flightNumber,
    required String date,
  }) async {
    try {
      // معرف المستند الخاص بالرحلة في اليوم ده (مثل: FL-101_15/8/2025)
      final docId = '${flightNumber}_${date.replaceAll('/', '-')}';

      final doc = await _db.collection('flight_seats').doc(docId).get();

      if (doc.exists && doc.data() != null) {
        final List<dynamic> seats = doc.data()!['seats'] ?? [];
        print('✅ Booked seats loaded: $seats');
        return seats.map((e) => e.toString()).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error fetching seats: $e');
      return [];
    }
  }

  // 🎯 2. حفظ الحجز + تحديث خريطة كراسي الطيارة في نفس الوقت!
  Future<BookingModel> createAndSaveBooking({
    required FlightModel flight,
    required int passengerCount,
    required String selectedClass,
    required double totalPrice,
    required List<String> selectedSeats,
    required List<String> passengerNames,
    required String paymentMethod,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw 'User must be logged in to book';

    final bookingId =
        'EA${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final booking = BookingModel(
      id: bookingId,
      flightNumber: flight.id,
      fromCode: flight.fromCode,
      toCode: flight.toCode,
      departTime: flight.departureTime,
      arriveTime: flight.arrivalTime,
      duration: flight.duration,
      date: flight.date,
      selectedClass: selectedClass,
      passengerCount: passengerCount,
      seats: selectedSeats,
      passengerNames: passengerNames,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      status: 'upcoming',
    );

    // أ. حفظ التذكرة جوه حساب المستخدم
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .set(booking.toJson());

    // ب. 🎯 تسجيل الكراسي جوه خريطة الطيارة (لتثبيتها كـ Taken للمسافرين التانيين)
    final docId = '${flight.id}_${flight.date.replaceAll('/', '-')}';
    await _db.collection('flight_seats').doc(docId).set({
      'seats': FieldValue.arrayUnion(selectedSeats), // بيزود الكراسي بدون تكرار
    }, SetOptions(merge: true));

    return booking;
  }

  // 3. جلب كل الحجوزات للمستخدم
  Future<List<BookingModel>> getAllBookings() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<BookingModel>> getUpcomingBookings() async {
    final all = await getAllBookings();
    final now = DateTime.now();
    // النهاردة بدون الساعات عشان نقارن الأيام بالضبط
    final today = DateTime(now.year, now.month, now.day);

    return all.where((b) {
      final flightDate = _parseDate(b.date);
      // لو تاريخ الرحلة يساوي النهاردة أو بعد النهاردة -> Upcoming
      return flightDate.isAfter(today) || flightDate.isAtSameMomentAs(today);
    }).toList();
  }

  Future<List<BookingModel>> getPastBookings() async {
    final all = await getAllBookings();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return all.where((b) {
      final flightDate = _parseDate(b.date);
      // لو تاريخ الرحلة قبل النهاردة -> Past
      return flightDate.isBefore(today);
    }).toList();
  }

  // 🛠️ دالة مساعدة بتحول نص التاريخ (مثل "15/8/2025") لكائن DateTime يقدر دارت يقارنه
  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return DateTime.now(); // افتراضي
  }
}
