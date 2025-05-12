import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../services/pdf_service.dart';
import 'secure_pdf_viewer.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final PdfService _pdfService = PdfService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'IELTS Courses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a course to begin your IELTS preparation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),

                // Reading Course
                _buildCourseSection(
                  context,
                  title: 'Reading Section',
                  description:
                      'Learn techniques to excel in the IELTS Reading test',
                  icon: Icons.menu_book,
                  color: AppConstants.secondaryColor,
                  lessons: [
                    _LessonItem(
                      title: 'Lesson 1: Introduction to IELTS Reading',
                      duration: '25 min',
                      pdfUrl:
                          'https://drive.google.com/file/d/11A6PlYg1Nf8ztznAuv3i_kTwytpoYcsR/view?usp=sharing',
                    ),
                    _LessonItem(
                      title: 'Lesson 2: Skimming and Scanning',
                      duration: '30 min',
                      pdfUrl: 'https://drive.google.com/file/d/11A6PlYg1Nf8ztznAuv3i_kTwytpoYcsR/view?usp=sharing',
                      isLocked: true,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Listening Course
                _buildCourseSection(
                  context,
                  title: 'Listening Section',
                  description:
                      'Master strategies for the IELTS Listening module',
                  icon: Icons.headset,
                  color: AppConstants.primaryColor,
                  lessons: [
                    _LessonItem(
                      title: 'Lesson 1: Introduction to IELTS Listening',
                      duration: '20 min',
                      pdfUrl: '',
                      isLocked: true,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Writing Course
                _buildCourseSection(
                  context,
                  title: 'Writing Section',
                  description: 'Learn how to write effective essays for IELTS',
                  icon: Icons.edit,
                  color: AppConstants.accentColor,
                  lessons: [
                    _LessonItem(
                      title: 'Lesson 1: Introduction to IELTS Writing',
                      duration: '35 min',
                      pdfUrl: '',
                      isLocked: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Cache management
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _clearPdfCache();
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear PDF Cache'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Loading overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildCourseSection(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<_LessonItem> lessons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course header
          Container(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.defaultRadius),
                topRight: Radius.circular(AppConstants.defaultRadius),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 36,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
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

          // Lessons list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lessons.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return _buildLessonItem(context, lesson, color);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(
      BuildContext context, _LessonItem lesson, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      title: Text(
        lesson.title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lesson.isLocked ? Colors.grey : Colors.black87,
        ),
      ),
      subtitle: Text(
        'Duration: ${lesson.duration}',
        style: TextStyle(
          color: lesson.isLocked ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
      trailing: lesson.isLocked
          ? const Icon(Icons.lock, color: Colors.grey)
          : Icon(Icons.arrow_forward_ios, color: color, size: 16),
      onTap: () {
        if (lesson.isLocked) {
          _showLockedContentDialog(context);
        } else if (lesson.pdfUrl.isNotEmpty) {
          _openSecurePdf(context, lesson);
        }
      },
    );
  }

  Future<void> _openSecurePdf(BuildContext context, _LessonItem lesson) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecurePdfViewer(
            title: lesson.title,
            pdfUrl: lesson.pdfUrl,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening document: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearPdfCache() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _pdfService.clearCache();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF cache cleared'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing cache: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLockedContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Content'),
        content: const Text(
          'This lesson is part of our premium content. Please upgrade your account to access this material.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.accentColor,
            ),
            child: const Text('UPGRADE'),
          ),
        ],
      ),
    );
  }
}

class _LessonItem {
  final String title;
  final String duration;
  final String pdfUrl;
  final bool isLocked;

  _LessonItem({
    required this.title,
    required this.duration,
    required this.pdfUrl,
    this.isLocked = false,
  });
}
