import 'package:easyair_app/screens/passenger_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:easyair_app/models/seat_model.dart';
import 'package:easyair_app/widgets/seat_item_widget.dart';
import 'package:easyair_app/models/flight_model.dart';

class SeatSelectionScreen extends StatefulWidget {
  final FlightModel flight; // 👈 استلام الرحلة
  final int passengerCount;
  final String selectedClass;
  final double basePrice;
  const SeatSelectionScreen({
    super.key,
    required this.flight,
    required this.passengerCount,
    required this.selectedClass,
    required this.basePrice,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late List<List<SeatModel>> seatRows;
  List<SeatModel> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _generateMockSeats();
  }

  // توليد خريطة كراسي وهمية للتجربة
  void _generateMockSeats() {
    seatRows = List.generate(8, (rowIndex) {
      int rowNumber = 12 + rowIndex;
      List<String> cols = ['A', 'B', 'C', 'D', 'E', 'F'];

      return cols.map((col) {
        String id = '$rowNumber$col';
        SeatStatus status = SeatStatus.available;

        // شوية كراسي محجوزة وممتازة عشوائياً للشكل
        if ((rowIndex + col.codeUnitAt(0)) % 3 == 0) {
          status = SeatStatus.taken;
        } else if (rowIndex == 0 || col == 'A' || col == 'F') {
          status = SeatStatus.premium;
        }

        return SeatModel(
          id: id,
          row: rowNumber,
          col: col,
          status: status,
          extraPrice: status == SeatStatus.premium ? 25.0 : 0.0,
        );
      }).toList();
    });
  }

  // لوجيك الضغط على كرسي
  void _toggleSeat(SeatModel seat) {
    setState(() {
      if (seat.status == SeatStatus.selected) {
        // لو مختار ونقر عليه تاني -> إلغاء الاختيار
        seat.status = seat.extraPrice > 0
            ? SeatStatus.premium
            : SeatStatus.available;
        selectedSeats.remove(seat);
      } else {
        // فحص عدد المسافرين
        if (selectedSeats.length >= widget.passengerCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can only select ${widget.passengerCount} seats for your passengers.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        // إضافة الاختيار
        seat.status = SeatStatus.selected;
        selectedSeats.add(seat);
      }
    });
  }

  // حساب التكلفة الإضافية للكراسي الممتازة المفتارة
  double get totalExtraPrice {
    return selectedSeats.fold(0.0, (sum, seat) => sum + seat.extraPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0F172A,
      ), // خلفية كحلي غامق شيك زي الطيارة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Select Seat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. الهيدر العلوى (بيانات الرحلة)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FLIGHT ${widget.flight.flightNumber}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.flight.fromCode} ➔ ${widget.flight.toCode}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Boeing 787',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 2. دليل الألوان (Legend)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegend(const Color(0xFF334155), 'Taken'),
              _buildLegend(Colors.white, 'Available'),
              _buildLegend(const Color(0xFFE9D5FF), 'Premium'),
              _buildLegend(const Color(0xFFFFB73F), 'Selected'),
            ],
          ),

          const SizedBox(height: 20),

          // 3. خريطة الكراسي (Airplane Interior)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView.builder(
                itemCount: seatRows.length,
                itemBuilder: (context, rowIndex) {
                  final row = seatRows[rowIndex];
                  final rowNum = row.first.row;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 3 كراسي شمال (A, B, C)
                        SeatItemWidget(
                          seat: row[0],
                          onTap: () => _toggleSeat(row[0]),
                        ),
                        const SizedBox(width: 8),
                        SeatItemWidget(
                          seat: row[1],
                          onTap: () => _toggleSeat(row[1]),
                        ),
                        const SizedBox(width: 8),
                        SeatItemWidget(
                          seat: row[2],
                          onTap: () => _toggleSeat(row[2]),
                        ),

                        // الممر ورقم الصف في النص
                        SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              '$rowNum',
                              style: const TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // 3 كراسي يمين (D, E, F)
                        SeatItemWidget(
                          seat: row[3],
                          onTap: () => _toggleSeat(row[3]),
                        ),
                        const SizedBox(width: 8),
                        SeatItemWidget(
                          seat: row[4],
                          onTap: () => _toggleSeat(row[4]),
                        ),
                        const SizedBox(width: 8),
                        SeatItemWidget(
                          seat: row[5],
                          onTap: () => _toggleSeat(row[5]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // 4. الشريط السفلي تأكيد الحجز
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedSeats.isEmpty
                            ? 'Select ${widget.passengerCount} Seats'
                            : 'Seats: ${selectedSeats.map((s) => s.id).join(', ')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${selectedSeats.length}/${widget.passengerCount} Selected',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (totalExtraPrice > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'UPGRADE',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+\$${totalExtraPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: selectedSeats.length == widget.passengerCount
                    ? () {
                        // 🧮 الحسبة الحقيقية النهائية:
                        final double finalPrice =
                            widget.basePrice + totalExtraPrice;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PassengerDetailsScreen(
                              flight:
                                  widget.flight, // 👈 تمرير الرحلة للـ Checkout
                              passengerCount: widget.passengerCount,
                              selectedClass: widget.selectedClass,
                              totalPrice: finalPrice,
                              selectedSeats: selectedSeats
                                  .map((s) => s.id)
                                  .toList(),
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFFFB73F,
                  ), // الأصفر المميز لما يفتح
                  disabledBackgroundColor: const Color(
                    0xFF334155,
                  ), // الرمادي الشيك وهو مقفول
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Confirm Seats (${selectedSeats.length}/${widget.passengerCount})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedSeats.length == widget.passengerCount
                        ? const Color(
                            0xFF0A1628,
                          ) // كحلي غامق لما يكتمل الاختيار
                        : Colors.white38, // أبيض باهت وهو مقفول
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ودجت صغيرة لدليل الألوان فوق
  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
