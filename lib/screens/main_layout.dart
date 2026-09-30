import 'package:easyair_app/screens/login/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:easyair_app/screens/home_screen.dart';
import 'package:easyair_app/screens/flight_details/my_bookings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // دي لستة الشاشات اللي هنتنقل بينها
  final List<Widget> _screens = [
    const HomeScreen(),
    const MyBookingsScreen(), // شاشة حجوزاتي (مؤقتاً هنحط كونتينر فاضي لحد ما نعملها)
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // بيعرض الشاشة حسب الرقم المختار

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // لما يضغط على أيقونة بيغير الشاشة
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFFB73F), // برتقالي للمختار
        unselectedItemColor: Colors.grey, // رمادي للي مش مختار
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // عشان الأيقونات تفضل ثابتة
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
