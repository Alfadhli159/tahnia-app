import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String verificationId; // أضف هذا المتغير

  const OtpVerificationScreen({
    Key? key,
    required this.phone,
    required this.verificationId, // أضف هذا السطر
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تحقق من الجوال'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            children: [
              Text(
                'تم إرسال رمز تحقق إلى جوالك (${widget.phone})',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 16),
                decoration: const InputDecoration(
                  hintText: '••••••',
                  border: OutlineInputBorder(),
                  labelText: 'رمز التحقق',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // هنا مكان التحقق الحقيقي من OTP بالاعتماد على verificationId و otp
                    // مثال وهمي فقط للعرض، يجب استبداله بمنطق Firebase لاحقًا
                    if (_otpController.text == '123456') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم التحقق بنجاح!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('رمز غير صحيح'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF12947f),
                  ),
                  child: const Text(
                    'تحقق',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
