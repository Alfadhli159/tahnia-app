import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/onboarding/tahnia1.png',
    'assets/images/onboarding/tahnia2.png',
    'assets/images/onboarding/tahnia3.png',
    'assets/images/onboarding/tahnia4.png',
  ];

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white, // خلفية بيضاء
          appBar: AppBar(
            backgroundColor: const Color(0xFF2196F3), // هيدر أزرق
            title: const Text(
              'مرحباً بك في تهنئة',
              style: TextStyle(
                color: Colors.white, // نص أبيض
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: Directionality(
                  textDirection:
                      TextDirection.ltr, // ✅ الحل لعرض الصور بالترتيب الصحيح
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 36.0, horizontal: 8.0),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 12.0),
                    width: _currentIndex == index ? 24 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? const Color(0xFF2196F3) // أزرق
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3), // زر أزرق
                      foregroundColor: Colors.white, // نص أبيض
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      if (_currentIndex == images.length - 1) {
                        Navigator.pushReplacementNamed(context, '/register');
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      _currentIndex == images.length - 1
                          ? "ابدأ الآن"
                          : "التالي",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        color: Colors.white, // نص أبيض
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
