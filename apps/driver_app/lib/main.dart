// AGENT 2: Driver Mobile App & Vision Engine Main Entry
// Location: apps/driver_app/lib/main.dart
// Stack: Flutter + Geofence Engine + Face Scanner + Manual PIN

import 'package:flutter/material.dart';
import 'geofence_engine.dart';
import 'face_scanner.dart';
import 'manual_pin_modal.dart';

void main() {
  runApp(const DriverScannerApp());
}

class DriverScannerApp extends StatelessWidget {
  const DriverScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRide AI - Driver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F3EA),
        cardColor: const Color(0xFFFFFDF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF718B75),
          primary: const Color(0xFF718B75),
          secondary: const Color(0xFFA65D45),
          surface: const Color(0xFFFFFDF8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFDF8),
          foregroundColor: Color(0xFF292824),
          elevation: 1,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF292824)),
          bodyMedium: TextStyle(color: Color(0xFF292824)),
        ),
      ),
      home: const DriverHomeScreen(),
    );
  }
}

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final FaceScannerEngine _scannerEngine = FaceScannerEngine();
  
  double _simulatedDistance = 14.0; // Meters to stop
  final double _faceConfidence = 0.94; // Cosine similarity
  final String _selectedBusId = 'bus-12';
  final double _busLat = 17.4455;
  final double _busLng = 78.3815;

  String _statusMessage = 'READY FOR BOARDING';
  Color _statusColor = Colors.cyan;
  bool _isProcessing = false;
  Map<String, dynamic>? _lastVerificationResult;

  void _triggerFaceScan(bool forceWrongBus) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'PROCESSING BIOMETRIC MATCH...';
      _statusColor = Colors.amber;
    });

    final busId = forceWrongBus ? 'bus-99' : _selectedBusId;
    final result = await _scannerEngine.scanAndVerifyStudent(
      studentId: 'STU-9941',
      faceConfidenceScore: _faceConfidence,
      scannedBusId: busId,
      busLat: _busLat,
      busLng: _busLng,
    );

    setState(() {
      _isProcessing = false;
      _lastVerificationResult = result;
      final bool verified = result['success'] == true;
      
      if (verified) {
        _statusMessage = 'VERIFIED: Rohan Verma (Boarded)';
        _statusColor = Colors.greenAccent;
      } else {
        final flag = result['verification']?['flagReason'] ?? 'UNAUTHORIZED_ATTEMPT';
        _statusMessage = 'FLAGGED EXCEPTION: $flag';
        _statusColor = Colors.redAccent;
      }
    });
  }

  void _openManualPinModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManualPinModal(
        busId: _selectedBusId,
        busLat: _busLat,
        busLng: _busLng,
        onVerificationComplete: (result) {
          setState(() {
            _lastVerificationResult = result;
            final bool verified = result['success'] == true;
            if (verified) {
              _statusMessage = 'VERIFIED via PIN: ${result['student']}';
              _statusColor = Colors.greenAccent;
            } else {
              _statusMessage = 'PIN VERIFICATION FAILED';
              _statusColor = Colors.redAccent;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool withinGeofence = GeofenceEngine.isWithinStopGeofence(_simulatedDistance);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.directions_bus, color: Colors.amber),
            SizedBox(width: 10),
            Text('Driver App — Bus #12 (Agent 2)'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Chip(
              backgroundColor: withinGeofence ? Colors.green[900] : Colors.red[900],
              avatar: Icon(
                withinGeofence ? Icons.location_on : Icons.location_off,
                color: Colors.white,
                size: 16,
              ),
              label: Text(
                withinGeofence ? 'Geofence Active (14m)' : 'Outside Geofence',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Camera Viewfinder Box
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _statusColor, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_front, size: 56, color: _statusColor),
                      const SizedBox(height: 12),
                      Text(
                        _statusMessage,
                        style: TextStyle(color: _statusColor, fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Cosine Similarity Score: ${(_faceConfidence * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  if (_isProcessing)
                    Container(
                      color: Colors.black54,
                      child: const Center(child: CircularProgressIndicator(color: Colors.amber)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls & Simulation Sliders
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Live Geofence Telemetry & Controls', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Stop Geofence Distance: ${_simulatedDistance.toStringAsFixed(0)}m'),
                        Text(withinGeofence ? 'MATCH' : 'OUT OF BOUNDS', 
                          style: TextStyle(color: withinGeofence ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    Slider(
                      value: _simulatedDistance,
                      min: 0,
                      max: 150,
                      activeColor: Colors.amber,
                      onChanged: (val) => setState(() => _simulatedDistance = val),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Scan Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _triggerFaceScan(false),
                    icon: const Icon(Icons.face, color: Colors.white),
                    label: const Text('Scan Face (Valid)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _triggerFaceScan(true),
                    icon: const Icon(Icons.warning, color: Colors.white),
                    label: const Text('Simulate Wrong Bus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Manual PIN Fallback Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.amber, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _openManualPinModal,
              icon: const Icon(Icons.key, color: Colors.amber),
              label: const Text('Manual PIN Fallback Modal', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ),

            if (_lastVerificationResult != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Backend Response Details (Agent 1 API):', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text(
                      _lastVerificationResult.toString(),
                      style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'monospace', fontSize: 11),
                    ),
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
