enum SeatStatus { taken, available, premium, selected }

class SeatModel {
  final String id;          // مثلاً "14A"
  final int row;            // رقم الصف "14"
  final String col;         // رمز العمود "A", "B", "C"...
  SeatStatus status;
  final double extraPrice;  // تكلفة إضافية للكرسي الممتاز (مثلاً 25$)

  SeatModel({
    required this.id,
    required this.row,
    required this.col,
    required this.status,
    this.extraPrice = 0.0,
  });
}