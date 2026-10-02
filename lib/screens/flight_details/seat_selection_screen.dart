import 'package:easyair_app/screens/passenger_details_screen.dart';
import 'package:easyair_app/services/booking_service.dart';
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
  bool isLoadingSeats = true;
  List<String> bookedSeatsFromDb = [];

  @override
  void initState() {
    super.initState();
    _loadBookedSeatsAndGenerate();
  }

  // توليد خريطة كراسي وهمية للتجربة
  // 📥 1. جلب الكراسي المحجوزة من الفايربيز الأول
  Future<void> _loadBookedSeatsAndGenerate() async {
    try {
      final seats = await BookingService.instance.getBookedSeatsForFlight(
        flightNumber: widget.flight.id,
        date: widget.flight.date,
      );
      bookedSeatsFromDb = seats;
    } catch (e) {
      print('Failed to load seats: $e');
    } finally {
      if (mounted) {
        setState(() {
          _generateSeats(); // 👈 بناء الكراسي بعد معرفة المحجوز
          isLoadingSeats = false;
        });
      }
    }
  }

  // 💺 2. رسم الكراسي (تحديد المحجوز بناءً على الداتابيز الحقيقية!)
  void _generateSeats() {
    seatRows = List.generate(8, (rowIndex) {
      int rowNumber = 12 + rowIndex;
      List<String> cols = ['A', 'B', 'C', 'D', 'E', 'F'];

      return cols.map((col) {
        String id = '$rowNumber$col';
        SeatStatus status = SeatStatus.available;

        // 🎯 السحر هنا: لو رقم الكرسي ده اتصادف إنه محجوز في الفايربيز ➔ خليه taken!
        if (bookedSeatsFromDb.contains(id)) {
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
        0xFFF5F7FB,
      ), // خلفية كحلي غامق شيك زي الطيارة
      appBar: AppBar(
        backgroundColor:  Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF101C2E),
        title: const Text(
          'Select Seat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoadingSeats
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB73F)),
            )
          : Column(
              children: [
                // 1. الهيدر العلوى (بيانات الرحلة)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
  'FLIGHT ${widget.flight.id}',
  style: const TextStyle(color: Colors.grey, fontSize: 12),
),
                          const SizedBox(height: 2),
                         Text(
  '${widget.flight.fromCode} → ${widget.flight.toCode}',
  style: const TextStyle(
    color: Color(0xFF101C2E),
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
  color: const Color(0xFFEEF3FA),
  borderRadius: BorderRadius.circular(8),
),
child: const Text(
  'Boeing 787',
  style: TextStyle(color: Color(0xFF101C2E), fontSize: 12),
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
                 _buildLegend(const Color(0xFFD0D7E2), 'Taken'),
_buildLegend(Colors.white, 'Available'),
_buildLegend(const Color(0xFFDCEBFF), 'Premium'),
_buildLegend(const Color(0xFFFFB73F), 'Selected'),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. خريطة الكراسي (Airplane Interior)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 12,
      offset: const Offset(0, -2),
    ),
  ],
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
  color: Colors.white,
  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  boxShadow: [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, -2),
    ),
  ],
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
  color: Color(0xFF8A94A6),
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
  color: Color(0xFF101C2E),
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
                 backgroundColor: const Color(0xFFFFB73F),
disabledBackgroundColor: const Color(0xFFE6EAF0), // الرمادي الشيك وهو مقفول
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
    ? const Color(0xFF0A1628)
    : const Color(0xFF9AA3B2),
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
  style: const TextStyle(color: Color(0xFF5B677A), fontSize: 12),
),
      ],
    );
  }
}
