import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../utils/validators.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _useOTPLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Logo & Branding
                _buildHeader(context),
                const SizedBox(height: 40),

                // Login Form
                _useOTPLogin
                    ? _buildOTPForm(context)
                    : _buildEmailPasswordForm(context),

                const SizedBox(height: 24),

                // Toggle login method
                _buildToggleLoginMethod(context),

                const SizedBox(height: 24),

                // Forgot Password
                if (!_useOTPLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.bodySmall(
                          context,
                        ).copyWith(color: AppColors.primaryOrange),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomButton(
                      label: 'Login',
                      onPressed:
                          _useOTPLogin
                              ? _handleOTPLogin
                              : _handleEmailPasswordLogin,
                      isLoading: authProvider.isLoading,
                      isEnabled: !authProvider.isLoading,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Biometric Login
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: AppColors.primaryOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Login with Biometric',
                              style: AppTextStyles.titleMedium(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Sign Up Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: AppTextStyles.bodyMedium(context),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.business,
            color: AppColors.primaryOrange,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text('Welcome Back', style: AppTextStyles.displayMedium(context)),
        const SizedBox(height: 8),
        Text(
          'Manage your B2B distribution seamlessly',
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }

  Widget _buildEmailPasswordForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: AppValidators.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            obscureText: _obscurePassword,
          ),
        ],
      ),
    );
  }

  Widget _buildOTPForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              prefixText: '+91 ',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: AppValidators.validatePhoneNumber,
          ),
          const SizedBox(height: 8),
          Text(
            'We will send you an OTP for verification',
            style: AppTextStyles.labelSmall(
              context,
            ).copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleLoginMethod(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() => _useOTPLogin = !_useOTPLogin);
          _formKey.currentState?.reset();
        },
        child: Text(
          _useOTPLogin
              ? 'Login with Email & Password'
              : 'Login with OTP Instead',
          style: AppTextStyles.labelMedium(
            context,
          ).copyWith(color: AppColors.primaryOrange),
        ),
      ),
    );
  }

  Future<void> _handleEmailPasswordLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!success && mounted) {
      final message =
          authProvider.errorMessage ?? 'Login failed. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _handleOTPLogin() {
    // TODO: Temporarily bypassing validation for testing
    // if (_formKey.currentState!.validate()) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                OTPVerificationScreen(phoneNumber: _phoneController.text),
      ),
    );
    // }
  }
}
