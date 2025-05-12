import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/google_sign_in_button.dart';
import '../constants/app_constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // If user is already authenticated, redirect to home screen
    if (authProvider.isAuthenticated) {
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppConstants.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultMargin * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App logo or image
                    const Icon(
                      Icons.school,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    // App title
                    Text(
                      AppConstants.appName,
                      style: AppConstants.headingStyle,
                    ),
                    const SizedBox(height: 12),
                    // App subtitle
                    Text(
                      'Prepare for your IELTS exam with ease',
                      textAlign: TextAlign.center,
                      style: AppConstants.subheadingStyle,
                    ),
                    const SizedBox(height: 48),
                    // Google Sign In Button
                    const GoogleSignInButton(),
                    const SizedBox(height: 24),
                    // Terms and conditions text
                    const Text(
                      'By signing in, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
