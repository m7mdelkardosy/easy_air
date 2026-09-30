import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easyair_app/models/booking_model.dart';
import 'package:easyair_app/models/flight_model.dart';

class BookingService {
  BookingService._privateConstructor();
  static final BookingService instance = BookingService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🎯 1. إنشاء وحفظ الحجز أونلاين في Cloud Firestore
  Future<BookingModel> createAndSaveBooking({
    required FlightModel flight,
    required int passengerCount,
    required String selectedClass,
    required double totalPrice,
    required List<String> selectedSeats,
    required List<String> passengerNames,
    required String paymentMethod,
  }) async {
    // جلب الـ UID بتاع المستخدم اللي عامل لوجين حالياً
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw 'User must be logged in to book';

    // توليد رقم حجز فريد
    final bookingId = 'EA${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    // بناء كائن الحجز
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

    // ☁️ السحر هنا: رفع الحجز للفايربيز أونلاين تحت حساب المستخدم بالضبط!
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .set(booking.toJson());

    return booking;
  }

  // ☁️ 2. جلب كل الحجوزات أونلاين من الفايربيز
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

  // 3. جلب الرحلات القادمة
  Future<List<BookingModel>> getUpcomingBookings() async {
    final all = await getAllBookings();
    return all.where((b) => b.status == 'upcoming').toList();
  }

  // 4. جلب الرحلات السابقة
  Future<List<BookingModel>> getPastBookings() async {
    final all = await getAllBookings();
    return all.where((b) => b.status == 'completed' || b.status == 'cancelled').toList();
  }
}