import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import 'home_screen.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();
    
    // Wait and start text animation
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    
    // Wait and check authentication
    await Future.delayed(const Duration(seconds: 2));
    _fadeController.forward();
    
    // Navigate to appropriate screen
    await Future.delayed(const Duration(milliseconds: 500));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: FadeTransition(
        opacity: _fadeController,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.backgroundGreen,
                AppTheme.surfaceGreen,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and App Name
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: Curves.elasticOut.transform(_logoController.value),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.eco,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // App Name
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textController.value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - _textController.value)),
                              child: Column(
                                children: [
                                  Text(
                                    'PlantDoctor',
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: AppTheme.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'AI-Powered Plant Care',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Loading Indicator
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Animated dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              final delay = index * 0.2;
                              final animationValue = (_logoController.value - delay).clamp(0.0, 1.0);
                              
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: Transform.scale(
                                  scale: 0.5 + (0.5 * animationValue),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Analyzing your plants...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
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
}