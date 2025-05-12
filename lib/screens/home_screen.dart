import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // If user is not authenticated, redirect to login screen
    if (!authProvider.isAuthenticated) {
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile section
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      // User profile image
                      authProvider.userPhotoUrl != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(authProvider.userPhotoUrl!),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: AppConstants.lightAccentColor,
                              child: const Icon(Icons.person,
                                  size: 35, color: Colors.white),
                            ),
                      const SizedBox(width: 16),
                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${authProvider.userName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (authProvider.userEmail.isNotEmpty)
                              Text(
                                authProvider.userEmail,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Main content - replace with your app's actual content
              const Text(
                'IELTS Practice Modules',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: const [
                    _ModuleCard(
                      title: 'Listening',
                      icon: Icons.headset,
                      color: AppConstants.primaryColor,
                    ),
                    _ModuleCard(
                      title: 'Reading',
                      icon: Icons.menu_book,
                      color: AppConstants.secondaryColor,
                    ),
                    _ModuleCard(
                      title: 'Writing',
                      icon: Icons.edit,
                      color: AppConstants.accentColor,
                    ),
                    _ModuleCard(
                      title: 'Speaking',
                      icon: Icons.mic,
                      color: AppConstants.lightAccentColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Module card widget for the home screen
class _ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ModuleCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius * 1.5),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the respective module
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title module selected')),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius * 1.5),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
