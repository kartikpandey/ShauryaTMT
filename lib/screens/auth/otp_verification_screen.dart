import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../utils/validators.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isResendAvailable = false;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendCountdown = 30;
    _isResendAvailable = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
          if (_resendCountdown <= 0) {
            _isResendAvailable = true;
          }
        });
      }
      return _resendCountdown > 0;
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.phone_iphone,
                      color: AppColors.primaryOrange,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Verification Code',
                        style: AppTextStyles.headlineMedium(context),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the 6-digit code sent to',
                        style: AppTextStyles.bodyMedium(
                          context,
                        ).copyWith(color: AppColors.textHint),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+91 ${widget.phoneNumber}',
                        style: AppTextStyles.titleMedium(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // OTP Input
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      hintText: '000000',
                      prefixIcon: const Icon(Icons.pin_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.numericLarge(context),
                    validator: AppValidators.validateOTP,
                  ),
                ),

                const SizedBox(height: 32),

                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomButton(
                      label: 'Verify & Login',
                      onPressed: _handleVerification,
                      isLoading: authProvider.isLoading,
                      isEnabled: !authProvider.isLoading,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Resend OTP
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Didn't receive code?",
                        style: AppTextStyles.bodyMedium(
                          context,
                        ).copyWith(color: AppColors.textHint),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed:
                            _isResendAvailable
                                ? () {
                                  _startResendCountdown();
                                  context.read<AuthProvider>().sendOTP(
                                    widget.phoneNumber,
                                  );
                                }
                                : null,
                        child: Text(
                          _isResendAvailable
                              ? 'Resend Code'
                              : 'Resend in $_resendCountdown s',
                          style: AppTextStyles.labelMedium(context).copyWith(
                            color:
                                _isResendAvailable
                                    ? AppColors.primaryOrange
                                    : AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleVerification() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthProvider>().loginWithOTP(
        widget.phoneNumber,
        _otpController.text,
      );
    }
  }
}
