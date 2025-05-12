import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfUtils {
  // Converts a Google Drive sharing URL to a direct download URL
  static String getGoogleDriveDirectUrl(String url) {
    // Check if this is a Google Drive URL
    if (url.contains('drive.google.com/file/d/')) {
      // Extract the file ID
      final RegExp regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');
      final Match? match = regExp.firstMatch(url);

      if (match != null && match.groupCount >= 1) {
        final String fileId = match.group(1)!;
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }

    // Return the original URL if not a Google Drive URL
    return url;
  }

  // Downloads a PDF file to the local cache and returns the file path
  static Future<String> downloadPdfToCache(String url) async {
    try {
      // First check if URL is a Google Drive URL and convert if needed
      final downloadUrl = getGoogleDriveDirectUrl(url);

      // Get the app's temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Generate a filename based on the URL
      final String fileName = Uri.parse(url).pathSegments.last;
      final String filePath = '${tempDir.path}/$fileName.pdf';

      // Check if file already exists in cache
      final File file = File(filePath);
      if (await file.exists()) {
        return filePath;
      }

      // Download the file
      final http.Response response = await http.get(Uri.parse(downloadUrl));

      // Save the downloaded file
      await file.writeAsBytes(response.bodyBytes);

      return filePath;
    } catch (e) {
      print('Error downloading PDF: $e');
      rethrow;
    }
  }

  // Method to clear the PDF cache
  static Future<void> clearPdfCache() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final Directory cacheDir = Directory('${tempDir.path}/pdf_cache');

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing PDF cache: $e');
    }
  }
}
