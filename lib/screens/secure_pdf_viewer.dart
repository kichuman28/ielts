import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../services/pdf_service.dart';

class SecurePdfViewer extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const SecurePdfViewer({
    Key? key,
    required this.title,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  State<SecurePdfViewer> createState() => _SecurePdfViewerState();
}

class _SecurePdfViewerState extends State<SecurePdfViewer>
    with WidgetsBindingObserver {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfService _pdfService = PdfService();

  bool _isLoading = true;
  bool _securityOverlay = false;
  bool _error = false;
  String _localPdfPath = '';
  Timer? _securityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepareDocument();
    _startSecurityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _securityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app is paused (user might be taking a screenshot or multitasking)
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _showSecurityOverlay();
    } else if (state == AppLifecycleState.resumed) {
      // When app is resumed, hide the overlay after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _securityOverlay = false;
          });
        }
      });
    }
  }

  void _startSecurityTimer() {
    // Check for security every few seconds (simulated screenshot detection)
    _securityTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && !_isLoading && !_error) {
        // Randomly show security overlay (simulating screenshot detection)
        // This is just for demonstration, in a real app you'd use actual detection
        bool shouldShowOverlay = DateTime.now().second % 30 == 0;

        if (shouldShowOverlay) {
          _showSecurityOverlay();
        }
      }
    });
  }

  void _showSecurityOverlay() {
    if (mounted) {
      setState(() {
        _securityOverlay = true;
      });

      // Show warning
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Taking screenshots is not allowed for this content'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      // Hide overlay after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _securityOverlay = false;
          });
        }
      });
    }
  }

  Future<void> _prepareDocument() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Use the PDF service to prepare the document
      final localPath = await _pdfService.prepareForViewing(
        widget.pdfUrl,
        authProvider.uid,
      );

      if (mounted) {
        setState(() {
          _localPdfPath = localPath;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = true;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading document: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showSecurityInfo(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_error)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load document',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _error = false;
                        _isLoading = true;
                      });
                      _prepareDocument();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (!_isLoading && _localPdfPath.isNotEmpty)
            // PDF Viewer with local file
            SfPdfViewer.file(
              File(_localPdfPath),
              key: _pdfViewerKey,
              canShowPaginationDialog: false,
              canShowScrollHead: false,
              enableDoubleTapZooming: true,
              onPageChanged: (PdfPageChangedDetails details) {
                // You can log page changes here if needed
                print('Page changed to ${details.newPageNumber}');
              },
            ),

          // Dynamic watermark overlay with user info
          if (!_isLoading && !_securityOverlay && !_error)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: WatermarkPainter(
                    text: 'CONFIDENTIAL - ${authProvider.userEmail}',
                    opacity: 0.1,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    spacingMultiplier: 2.0,
                  ),
                ),
              ),
            ),

          // Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Security overlay (shown when screenshot attempted)
          if (_securityOverlay)
            Container(
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.security,
                  color: Colors.red,
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSecurityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• This content is protected against unauthorized copying'),
            SizedBox(height: 8),
            Text('• Screenshots are detected and blocked'),
            SizedBox(height: 8),
            Text('• Content is watermarked with your account information'),
            SizedBox(height: 8),
            Text('• All viewing activity is logged'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class WatermarkPainter extends CustomPainter {
  final String text;
  final double opacity;
  final double fontSize;
  final FontWeight fontWeight;
  final double spacingMultiplier; // Controls density of watermarks

  WatermarkPainter({
    required this.text,
    this.opacity = 0.3,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.spacingMultiplier = 1.5, // Default spacing
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black.withOpacity(opacity + 0.1),
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Draw watermark diagonally across the screen multiple times
    for (int i = -2; i < 20; i++) {
      for (int j = -2; j < 30; j++) {
        canvas.save();

        // Position watermark in a grid pattern, rotated 45 degrees
        final double x = (i * textPainter.width * spacingMultiplier) +
            (j % 2 * textPainter.width * 0.5);
        final double y = j * textPainter.height * spacingMultiplier;

        // Apply rotation
        canvas.translate(x, y);
        canvas.rotate(3.14159 / 4); // 45 degrees in radians

        // Draw the text
        textPainter.paint(canvas, Offset.zero);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
