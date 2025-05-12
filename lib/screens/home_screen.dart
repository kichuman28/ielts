import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_navbar.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // Home Page Content
            _buildHomeContent(context, authProvider),

            // Courses Page Content
            _buildEmptyStateWidget(
              'Courses Coming Soon',
              'We are working hard to bring you the best IELTS courses.',
              Icons.book,
            ),

            // Practice Page Content
            _buildEmptyStateWidget(
              'Practice Coming Soon',
              'Interactive practice sessions will be available soon.',
              Icons.chat,
            ),

            // Stats Page Content
            _buildEmptyStateWidget(
              'Stats Coming Soon',
              'Track your progress with detailed statistics.',
              Icons.leaderboard,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildEmptyStateWidget(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppConstants.lightAccentColor,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, AuthProvider authProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                            backgroundImage: _buildUserProfileImage(
                                authProvider.userPhotoUrl!),
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
            // Main content title
            const Text(
              'IELTS Practice Modules',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Module grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }

  ImageProvider _buildUserProfileImage(String url) {
    return NetworkImage(url);
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
