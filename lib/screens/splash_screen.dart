import 'package:easyair_app/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _planeController;
  late Animation<double> _planeAnimation;

  @override
  void initState() {
    super.initState();

    // أنيميشن الطيارة من الشمال لليمين
    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _planeAnimation = Tween<double>(begin: -65, end: 65).animate(
      CurvedAnimation(parent: _planeController, curve: Curves.easeInOut),
    );

    _planeController.forward();

    // بعد 2.8 ثانية ندخل للتطبيق
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const AuthGate(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _planeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B1524), // كحلي غامق
                Color(0xFF152A45),
                Color(0xFF1C3A5F),
              ],
            ),
          ),
          child: Stack(
            children: [
              // ===== دوائر ديكور خلفية =====
              Positioned(
                top: -60,
                right: -40,
                child: _glowCircle(
                  180,
                  const Color(0xFFFFB73F).withOpacity(0.08),
                ),
              ),
              Positioned(
                bottom: 80,
                left: -50,
                child: _glowCircle(
                  160,
                  const Color(0xFF4DA3FF).withOpacity(0.08),
                ),
              ),

              // ===== المحتوى الأساسي =====
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // اللوجو + الأيقونة
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: ZoomIn(
                        duration: const Duration(milliseconds: 900),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFB73F),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFFB73F,
                                ).withOpacity(0.35),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flight_takeoff_rounded,
                            size: 54,
                            color: Color(0xFF0A1628),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // اسم التطبيق
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 200),
                      child: const Text(
                        'EasyAir',
                        style: TextStyle(
                          fontFamily: 'Moves',
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // جملة تحت الاسم
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 350),
                      child: Text(
                        'Fly smarter. Book faster.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // خط الطيران المتحرك
                    FadeIn(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 500),
                      child: SizedBox(
                        width: size.width * 0.40,
                        height: 40,
                        child: AnimatedBuilder(
                          animation: _planeAnimation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // الخط المتقطع
                                Container(
                                  height: 2,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: List.generate(
                                      18,
                                      (i) => Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          height: 2,
                                          color: Colors.white.withOpacity(0.25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // الطيارة المتحركة
                                Transform.translate(
                                  offset: Offset(_planeAnimation.value, 0),
                                  child: const RotatedBox(
                                    quarterTurns:
                                        1, // 👈 بيلف الطيارة 90 درجة أفقياً لليمين
                                    child: Icon(
                                      Icons.flight,
                                      color: Color(0xFFFFB73F),
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Loading تحت =====
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFFFFB73F).withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Preparing your journey...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
