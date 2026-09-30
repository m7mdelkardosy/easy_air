import 'package:easyair_app/screens/login/register_screen.dart';
import 'package:easyair_app/shared/custom_txtfield.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easyair_app/services/auth_service.dart';
import 'package:easyair_app/screens/main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. المتغيرات والـ Controllers بقوا جوه الـ State (أصح واحترافي)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // 2. المتغير اللي بيحدد طريقة الدخول الحالية (الديفولت إيميل)
  bool isEmailLogin = true;

  @override
  void dispose() {
    // 3. بنمسح الكنترولرز من الميموري لما نقفل الشاشة
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: SafeArea(
          child: Stack(
            children: [
              // خلفية الطيارة
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tayara.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              // لوجو واسم التطبيق فوق
              Positioned(
                top: 24.0,
                left: 24.0,
                child: Row(
                  children: const [
                    Icon(Icons.flight_takeoff, color: Colors.white, size: 42.0),
                    SizedBox(width: 12.0),
                    Text(
                      'Easy- Air',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            'Moves', // استخدمنا الفونت اللي ضفناه في pubspec.yaml
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              // الحاوية البيضاء اللي فيها الفورم
              Positioned(
                top: size.height * 0.15,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 15,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  'Start your journey ',
                                  style: TextStyle(
                                    fontFamily:
                                        'Moves', // استخدمنا الفونت اللي ضفناه في pubspec.yaml
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 0.4, // زاوية بسيطة عشان يبقى شكله حيوي
                                  child: const Icon(
                                    Icons.flight,
                                    size: 28.0,
                                    color: Color.fromARGB(255, 1, 12, 32),
                                  ),
                                ),
                                // Icon(Icons.flight, size: 28.0),
                              ],
                            ),
                            const SizedBox(height: 10.0),

                            // ⭐ شريط التبديل الاحترافي (Email / Phone Toggle) ⭐
                            Row(
                              children: [
                                // اختيار البريد الإلكتروني
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEmailLogin = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: isEmailLogin
                                                ? const Color(
                                                    0xFFFFB73F,
                                                  ) // اللون البرتقالي لو نشط
                                                : Colors.grey.shade300,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isEmailLogin
                                                ? const Color(0xFF0A1628)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // اختيار رقم الهاتف
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEmailLogin = false;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: !isEmailLogin
                                                ? const Color(0xFFFFB73F)
                                                : Colors.grey.shade300,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Phone Number',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: !isEmailLogin
                                                ? const Color(0xFF0A1628)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),

                            // ⭐ هنا بنعرض الفيلد بناءً على الاختيار ⭐
                            if (isEmailLogin)
                              CustomTextField(
                                controller: emailController,
                                hintText: 'Email Address',
                                prefixIcon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }

                                  final emailRegex = RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                  );

                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Please enter a valid email address (e.g., name@gmail.com)';
                                  }

                                  return null; // الإيميل صح ومفيش مشاكل
                                },
                              )
                            else
                              // ... جوه الـ else بتاع الـ Phone:
                              IntlPhoneField(
                                textInputAction: TextInputAction.next,

                                controller: phoneController,
                                initialCountryCode:
                                    'EG', // 🇪🇬 الكود الافتراضي لمصر (ممكن تخليه أي بلد تانية)
                                disableLengthCheck:
                                    false, // بيعمل التحقق من طول الرقم تلقائي حسب البلد!
                                dropdownIconPosition: IconPosition
                                    .trailing, // سهم القائمة المنسدلة على اليمين
                                // شكل وتصميم الحقل عشان يطابق الـ CustomTextField بتاعنا
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0A1628),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                ),

                                // لما المستخدم يكتب رقم التليفون
                                onChanged: (phone) {
                                  // phone.completeNumber -> هيديك الرقم كامل بالرمز (مثلا: +201012345678)
                                  debugPrint(phone.completeNumber);
                                },
                              ),

                            const SizedBox(height: 16.0),

                            // حقل الباسورد ثابت في الحالتين
                            CustomTextField(
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              hintText: 'Password',
                              prefixIcon: Icons.lock,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24.0),
                            // زرار الـ Login
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null // مقفول أثناء التحميل
                                  : () async {
                                      // 1. التفتيش على الحقول (Validation)
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true; // شغل التحميل
                                        });

                                        try {
                                          // 2. تسجيل الدخول عبر الفايربيز 🚀
                                          // نحدد الإيميل (سواء المكتوب في حقل الإيميل أو التليفون)
                                          String inputEmail = isEmailLogin
                                              ? emailController.text.trim()
                                              : phoneController.text.trim();

                                          await AuthService.instance
                                              .loginWithEmail(
                                                email: inputEmail,
                                                password: passwordController
                                                    .text
                                                    .trim(),
                                              );

                                          if (!mounted) return;

                                          // 3. رسالة نجاح سريعة
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Welcome back! 👋'),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );

                                          // 4. الانتقال للشاشة الرئيسية
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainLayout(),
                                            ),
                                            (route) => false,
                                          );
                                        } catch (errorMessage) {
                                          if (!mounted) return;

                                          // 5. لو الباسورد غلط أو الإيميل مش موجود
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                errorMessage.toString(),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB73F),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF0A1628),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFF0A1628),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16.0),

                            // خط الـ OR وباقي الأزرار
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 0.8,
                                    indent: 20.0,
                                    endIndent: 10.0,
                                  ),
                                ),
                                const Text(
                                  'OR',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 0.8,
                                    indent: 10.0,
                                    endIndent: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),

                            // أزرار جوجل وأبل
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _socialButton('assets/images/1.png', 'Google'),
                                const SizedBox(width: 16.0),
                                _socialButton(
                                  'assets/images/apple.png',
                                  'Apple',
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),

                            // الرجوع للـ Register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(), // 👍 بنفتح شاشة التسجيل
                                      ),
                                    );
                                  },

                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Color(0xFFFFB73F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ودجت صغيرة لأزرار السوشيال ميديا عشان نقلل السطور
  Widget _socialButton(String imagePath, String label) {
    return SizedBox(
      height: 45, // خليت الطول أوسع شوية عشان يبقى مريح للضغط
      width: 140,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(imagePath, width: 22),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF0E132C)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE6E6E9),
          elevation: 0, // شيلت الـ shadow عشان الشكل فلات وشيك
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
