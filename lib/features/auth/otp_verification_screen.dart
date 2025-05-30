import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  
  const OtpVerificationScreen({
    super.key,
    required this.phone,
    required this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Check if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    String otp = _controllers.map((controller) => controller.text).join();
    
    // For testing purposes, accept any 6-digit code
    if (otp.length == 6) {
      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال رمز التحقق كاملاً'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال رمز التحقق مرة أخرى'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تحقق من رقم الجوال'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Icon(
                Icons.sms,
                size: 80,
                color: Color(0xFF12947f),
              ),
              const SizedBox(height: 24),
              const Text(
                'تحقق من رقم الجوال',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'أدخل رمز التحقق المرسل إلى\n${widget.phone}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF12947f),
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF12947f),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'تحقق',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _resendCode,
                child: const Text(
                  'إعادة إرسال الرمز',
                  style: TextStyle(
                    color: Color(0xFF12947f),
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'لم تستلم الرمز؟ تأكد من رقم الجوال أو جرب مرة أخرى',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
