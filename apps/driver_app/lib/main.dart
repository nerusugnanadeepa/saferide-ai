// AGENT 2: Driver Mobile App Main Scanner Entry
// Location: apps/driver_app/lib/main.dart
// Stack: Flutter (Android / iOS)

import 'package:flutter/material.dart';

void main() {
  runApp(const DriverScannerApp());
}

class DriverScannerApp extends StatelessWidget {
  const DriverScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRide AI - Driver App',
      theme: ThemeData.dark(),
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
  double _distanceToStop = 120.0;
  String _scanStatus = "READY";

  void _triggerScan(bool valid) {
    setState(() {
      _scanStatus = valid ? "VERIFIED (Rohan)" : "FLAGGED: WRONG BUS";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver App - Bus #12')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 250,
              color: Colors.black,
              child: Center(
                child: Text('Camera Viewfinder\nStatus: $_scanStatus', 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(color: Colors.cyan, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            Text('Simulated Distance: ${_distanceToStop.toStringAsFixed(0)}m'),
            Slider(
              value: _distanceToStop,
              min: 0,
              max: 200,
              onChanged: (val) => setState(() => _distanceToStop = val),
            ),
            ElevatedButton(
              onPressed: () => _triggerScan(true),
              child: const Text('Scan Student (Valid)'),
            ),
          ],
        ),
      ),
    );
  }
}
