import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../utils/pdf_utils.dart';

class PdfService {
  // Singleton pattern
  static final PdfService _instance = PdfService._internal();

  factory PdfService() {
    return _instance;
  }

  PdfService._internal();

  // Keep track of PDF files being viewed
  final Map<String, String> _activePdfs = {};

  // Download and prepare PDF for viewing
  Future<String> prepareForViewing(String url, String userId) async {
    try {
      // Convert Google Drive URL if needed
      final directUrl = PdfUtils.getGoogleDriveDirectUrl(url);

      // Generate a unique key for this PDF/user combination
      final String pdfKey = '${Uri.parse(url).pathSegments.last}_$userId';

      // Check if we already have this PDF
      if (_activePdfs.containsKey(pdfKey)) {
        return _activePdfs[pdfKey]!;
      }

      // Download the PDF to local storage
      final localPath = await _downloadPdf(directUrl, pdfKey);

      // Save for future reference
      _activePdfs[pdfKey] = localPath;

      // Log this viewing for analytics (could connect to Firestore in future)
      _logPdfAccess(url, userId);

      return localPath;
    } catch (e) {
      print('Error preparing PDF: $e');
      rethrow;
    }
  }

  // Private method to download the PDF
  Future<String> _downloadPdf(String url, String filename) async {
    try {
      // Get app's temp directory
      final directory = await getTemporaryDirectory();
      final folderPath = '${directory.path}/secure_pdfs';

      // Create folder if it doesn't exist
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      // Define file path
      final filePath = '$folderPath/$filename.pdf';
      final file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        return filePath;
      }

      // Download file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Write to file
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      rethrow;
    }
  }

  // Log PDF access for analytics
  void _logPdfAccess(String url, String userId) {
    // In future: connect to Firestore to log access
    // For now, just print
    print('User $userId accessed PDF $url at ${DateTime.now()}');
  }

  // Clear all cached PDFs
  Future<void> clearCache() async {
    try {
      final directory = await getTemporaryDirectory();
      final folderPath = '${directory.path}/secure_pdfs';

      final folder = Directory(folderPath);
      if (await folder.exists()) {
        await folder.delete(recursive: true);
      }

      _activePdfs.clear();
    } catch (e) {
      print('Error clearing PDF cache: $e');
    }
  }

  // Get a list of all cached PDFs
  Future<List<String>> getCachedPdfs() async {
    try {
      final directory = await getTemporaryDirectory();
      final folderPath = '${directory.path}/secure_pdfs';

      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        return [];
      }

      final List<FileSystemEntity> files = await folder.list().toList();
      return files.whereType<File>().map((file) => file.path).toList();
    } catch (e) {
      print('Error getting cached PDFs: $e');
      return [];
    }
  }
}
