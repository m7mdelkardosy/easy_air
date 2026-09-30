import 'package:easyair_app/screens/login/login_screen.dart';
import 'package:easyair_app/shared/custom_txtfield.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easyair_app/services/auth_service.dart';
import 'package:easyair_app/screens/main_layout.dart';
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
bool isLoading = false;
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(
          context,
        ).unfocus(); // إخفاء لوحة المفاتيح عند الضغط في أي مكان
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.scale(
                  scale: 1.0,
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
              ),
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
                        fontFamily:
                            'Moves', // استخدمنا الفونت اللي ضفناه في pubspec.yaml
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Start your journey',
                                  style: TextStyle(
                                    fontFamily:
                                        'Moves', // استخدمنا الفونت اللي ضفناه في pubspec.yaml
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6.0),
                                Transform.rotate(
                                  angle: 0.4,
                                  child: const Icon(
                                    Icons.flight,
                                    size: 28.0,
                                    color: Color.fromARGB(255, 1, 12, 32),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'Full Name',
                              prefixIcon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            CustomTextField(
                              textInputAction: TextInputAction.next,

                              controller: emailController,
                              hintText: 'Email',
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
                            ),
                            SizedBox(height: 16.0),

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
                            // SizedBox(height: 16.0),
                            CustomTextField(
                              textInputAction: TextInputAction.next,

                              controller: passwordController,
                              hintText: 'Password',
                              prefixIcon: Icons.lock,
                              isPassword: true,
                              validator: (value) {
                                // 1. نتأكد إن الحقل مش فاضي
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                // 2. الشرط الأول: الطول لا يقل عن 8 حروف
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }

                                // 3. الشرط الثاني: يحتوي على حروف (كبيرة أو صغيرة)
                                final hasLetters = RegExp(r'[a-zA-Z]');
                                if (!hasLetters.hasMatch(value)) {
                                  return 'Password must contain at least one letter';
                                }

                                // 4. الشرط الثالث: يحتوي على أرقام
                                final hasDigits = RegExp(r'[0-9]');
                                if (!hasDigits.hasMatch(value)) {
                                  return 'Password must contain numbers and special character (e.g. @, #, &)';
                                }

                                // 5. الشرط الرابع: يحتوي على رموز خاصة (مثل @، #، $، %، إلخ)
                                final hasSpecialCharacters = RegExp(
                                  r'[!@#$%^&*(),.?":{}|<>]',
                                );
                                if (!hasSpecialCharacters.hasMatch(value)) {
                                  return 'Password must contain numbers and special character (e.g. @, #, &)';
                                }

                                return null; // الباسورد قوي وممتاز ومطابق لكل الشروط!
                              },
                            ),
                            SizedBox(height: 16.0),
                            CustomTextField(
                              controller: confirmPasswordController,
                              textInputAction: TextInputAction.done,
                              hintText: 'Confirm Password',
                              prefixIcon: Icons.lock,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.0),
                            ElevatedButton(
  onPressed: isLoading
      ? null // بيقفل الزرار وأنت بتسجل عشان يمنع الضغط المزدوج
      : () async {
          // 1. التفتيش على الحقول (Validation)
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true; // شغل علامة التحميل
            });

            try {
              // 2. التسجيل أونلاين في الفايربيز 🚀
              await AuthService.instance.signUpWithEmail(
                email: emailController.text.trim(),
                password: passwordController.text.trim(), 
                name: nameController.text.trim(),
                phone: phoneController.text.trim(),
              );

              if (!mounted) return;

              // 3. إظهار رسالة نجاح
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account created successfully! 🎉'),
                  backgroundColor: Colors.green,
                ),
              );

              // 4. الانتقال للشاشة الرئيسية مباشرة
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainLayout()),
                (route) => false, // بيمسح صفحة اللوجين والتسجيل من الـ Back
              );

            } catch (errorMessage) {
              if (!mounted) return;

              // 5. لو حصل خطأ (مثلاً الإيميل متسجل قبل كده)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage.toString()),
                  backgroundColor: Colors.red,
                ),
              );
            } finally {
              if (mounted) {
                setState(() {
                  isLoading = false; // إيقاف علامة التحميل
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
          'Create Account',
          style: TextStyle(
            fontSize: 15.0,
            color: Color(0xFF0A1628),
            fontWeight: FontWeight.bold,
          ),
        ),
),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.8,
                                    indent: 20.0,
                                    endIndent: 10.0,
                                  ),
                                ),
                                Text(
                                  'OR',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.8,
                                    indent: 10.0,
                                    endIndent: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 130,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/images/1.png',
                                      width: 25,
                                    ),
                                    label: Text(
                                      'Google',
                                      style: TextStyle(
                                        fontSize: 15,

                                        color: const Color.fromARGB(
                                          255,
                                          14,
                                          19,
                                          44,
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        230,
                                        230,
                                        233,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                SizedBox(
                                  height: 30,
                                  width: 130,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Image.asset(
                                      'assets/images/apple.png',
                                      width: 25,
                                    ),
                                    label: Text(
                                      'Apple',
                                      style: TextStyle(
                                        fontSize: 15,

                                        color: const Color.fromARGB(
                                          255,
                                          14,
                                          19,
                                          44,
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        230,
                                        230,
                                        233,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(), // 👍 بنفتح شاشة التسجيل
                                      ),
                                    );
                                  },

                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        183,
                                        63,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // هنا هتضيف Form Fields اللي عايزها
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
}
