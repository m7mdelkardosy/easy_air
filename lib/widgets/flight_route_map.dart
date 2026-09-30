import 'dart:math' as math; // 👈 عشان نحسب زاوية دوران الطيارة
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FlightRouteMap extends StatelessWidget {
  final String fromCode;
  final String toCode;

  const FlightRouteMap({
    super.key,
    required this.fromCode,
    required this.toCode,
  });

  LatLng _getCoordinates(String code) {
    final Map<String, LatLng> airportCoords = {
      'CAI': const LatLng(30.1219, 31.4056),
      'DXB': const LatLng(25.2532, 55.3657),
      'JED': const LatLng(21.6796, 39.1565),
      'RUH': const LatLng(24.9576, 46.6988),
      'IST': const LatLng(41.2753, 28.7519),
      'LHR': const LatLng(51.4700, -0.4543),
      'JFK': const LatLng(40.6413, -73.7781),
    };

    return airportCoords[code] ?? const LatLng(30.1219, 31.4056);
  }

  // 📐 دالة رياضية بسيطة بتحسب زاوية اتجاه الطيارة نحو الوجهة
  double _calculateBearing(LatLng start, LatLng end) {
    final double dy = end.latitude - start.latitude;
    final double dx = end.longitude - start.longitude;
    return math.atan2(dx, dy); // بترجع الزاوية بالـ Radians
  }

  @override
  Widget build(BuildContext context) {
    final LatLng fromLatLng = _getCoordinates(fromCode);
    final LatLng toLatLng = _getCoordinates(toCode);

    // نقطة المنتصف بين البلدين
    final LatLng centerLatLng = LatLng(
      (fromLatLng.latitude + toLatLng.latitude) / 2,
      (fromLatLng.longitude + toLatLng.longitude) / 2,
    );

    // حساب اتجاه الطيارة
    final double planeAngle = _calculateBearing(fromLatLng, toLatLng);

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(initialCenter: centerLatLng, initialZoom: 3.2),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
              additionalOptions: const {
                'accessToken':
                    'pk.eyJ1IjoidGhqbXoiLCJhIjoiY211ZDQyNGxzMjMwNjJ5czcwbHRmM2xmMiJ9._gw0MeLgFxllunPU-_w7xQ',
              },
              userAgentPackageName: 'com.easyair.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [fromLatLng, toLatLng],
                  strokeWidth: 3.5,
                  color: const Color(0xFFFFB73F),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                // 1. دبوس بداية الرحلة (CAI مثلاً)
                _buildMarker(fromLatLng, fromCode, Colors.blue),

                // 2. دبوس نهاية الرحلة (LHR / DXB مثلاً)
                _buildMarker(toLatLng, toCode, Colors.redAccent),

                // ✈️ 3. طيارة في منتصف الخط متجهة نحو الوصول!
                Marker(
                  point: centerLatLng,
                  width: 40,
                  height: 40,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF101C2E), // خلفية كحلي شيك
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: planeAngle, // 👈 لف الطيارة في اتجاه الوجهة
                      child: const Icon(
                        Icons.flight,
                        color: Color(0xFFFFB73F), // طيارة برتقالي
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Marker _buildMarker(LatLng point, String code, Color color) {
    return Marker(
      point: point,
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF101C2E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.location_on, color: color, size: 28),
        ],
      ),
    );
  }
}
