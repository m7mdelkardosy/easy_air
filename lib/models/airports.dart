class AirportModel {
  final String name;
  final String city;
  final String country;
  final String code;

  AirportModel({
    required this.name,
    required this.city,
    required this.country,
    required this.code,
  });

  // دالة بتاخد الـ JSON وتحوله لكائن (Object) من الكلاس ده
  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      name: json['name'],
      city: json['city'],
      country: json['country'],
      code: json['code'],
    );
  }
}