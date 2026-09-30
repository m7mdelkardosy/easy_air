import 'package:flutter/material.dart';

class PassengerFormCard extends StatelessWidget {
  final int index;
  final TextEditingController nameController;
  final TextEditingController passportController;

  const PassengerFormCard({
    super.key,
    required this.index,
    required this.nameController,
    required this.passportController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان المسافر (Passenger 1 / Passenger 2)
          Row(
            children: [
              const Icon(Icons.person, color: Color(0xFFFFB73F), size: 20),
              const SizedBox(width: 8),
              Text(
                'Passenger ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101C2E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // حقل الاسم الكامل
          TextFormField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter passenger name';
              }
              if (value.trim().split(' ').length < 2) {
                return 'Please enter first & last name';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Full Name (as in Passport)',
              prefixIcon: const Icon(Icons.badge_outlined, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // حقل رقم الباسبور (اختياري)
          TextFormField(
            controller: passportController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Passport Number (Optional)',
              prefixIcon: const Icon(Icons.card_membership_outlined, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}