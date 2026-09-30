class BookingModel {
  final String id; // رقم الحجز / PNR
  final String flightNumber;
  final String fromCode;
  final String toCode;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String date;
  final String selectedClass;
  final int passengerCount;
  final List<String> seats;
  final List<String> passengerNames;
  final double totalPrice;
  final String paymentMethod;
  final DateTime createdAt;
  final String status; // upcoming, completed, cancelled

  BookingModel({
    required this.id,
    required this.flightNumber,
    required this.fromCode,
    required this.toCode,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.date,
    required this.selectedClass,
    required this.passengerCount,
    required this.seats,
    required this.passengerNames,
    required this.totalPrice,
    required this.paymentMethod,
    required this.createdAt,
    this.status = 'upcoming',
  });

  // 1. تحويل البيانات من JSON / Firebase لـ Object في Dart
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      fromCode: json['fromCode'] ?? '',
      toCode: json['toCode'] ?? '',
      departTime: json['departTime'] ?? '',
      arriveTime: json['arriveTime'] ?? '',
      duration: json['duration'] ?? '',
      date: json['date'] ?? '',
      selectedClass: json['selectedClass'] ?? 'Economy',
      passengerCount: json['passengerCount'] ?? 1,
      seats: List<String>.from(json['seats'] ?? []),
      passengerNames: List<String>.from(json['passengerNames'] ?? []),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? 'Card',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      status: json['status'] ?? 'upcoming',
    );
  }

  // 2. تحويل الـ Object لـ Map / JSON عشان يتحفظ في Firebase مستقبلاً
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightNumber': flightNumber,
      'fromCode': fromCode,
      'toCode': toCode,
      'departTime': departTime,
      'arriveTime': arriveTime,
      'duration': duration,
      'date': date,
      'selectedClass': selectedClass,
      'passengerCount': passengerCount,
      'seats': seats,
      'passengerNames': passengerNames,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}