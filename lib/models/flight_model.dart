class FlightModel {
  final String id;
  final String airline;
  final String fromCode;
  final String toCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String date;
  final double price;
  final bool isDirect;

  FlightModel({
    required this.id,
    required this.airline,
    required this.fromCode,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.date,
    required this.price,
    required this.isDirect,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'],
      airline: json['airline'],
      fromCode: json['fromCode'],
      toCode: json['toCode'],
      departureTime: json['departTime'],
      arrivalTime: json['arriveTime'],
      duration: json['duration'],
      date: json['date'],
      price: json['price'].toDouble(),
      isDirect: json['isDirect'],
    );
  }

  String? get flightNumber => null;
}
