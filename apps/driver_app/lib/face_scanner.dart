// AGENT 2: MobileFaceNet Face Scanner Engine
// Location: apps/driver_app/lib/face_scanner.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class FaceScannerEngine {
  final String backendBaseUrl;

  FaceScannerEngine({this.backendBaseUrl = 'http://localhost:4000/api'});

  /// Simulates biometric scanning & calls Agent 1 Backend API (/verify-boarding)
  Future<Map<String, dynamic>> scanAndVerifyStudent({
    required String studentId,
    required double faceConfidenceScore,
    required String scannedBusId,
    required double busLat,
    required double busLng,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$backendBaseUrl/verify-boarding'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'studentId': studentId,
          'faceScore': faceConfidenceScore,
          'scannedBusId': scannedBusId,
          'busLat': busLat,
          'busLng': busLng,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'API Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Offline fallback simulation
      final isFaceMatch = faceConfidenceScore >= 0.75;
      return {
        'success': isFaceMatch,
        'student': 'Rohan Verma (Offline Match)',
        'verification': {
          'verified': isFaceMatch,
          'faceMatch': isFaceMatch,
          'busMatch': true,
          'geofenceMatch': true,
          'flagReason': isFaceMatch ? null : 'BIOMETRIC_MATCH_FAILED',
        },
      };
    }
  }
}
