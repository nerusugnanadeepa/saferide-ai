// AGENT 3: Parent Mobile App Entry
// Location: apps/parent_app/lib/main.dart
// Stack: Flutter (Android / iOS)

import 'package:flutter/material.dart';

void main() {
  runApp(const ParentApp());
}

class ParentApp extends StatelessWidget {
  const ParentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRide AI - Parent App',
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
      ),
      home: const ParentDashboard(),
    );
  }
}

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent App - Rohan Verma')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.red),
                title: Text('Pickup Location'),
                subtitle: Text('Stop #3 - Green Park Colony (Lat: 17.4452, Lng: 78.3812)'),
              ),
            ),
            SizedBox(height: 20),
            Text('Notifications Feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.directions_bus, color: Colors.amber),
              title: Text('Alert #1: Bus Arrived'),
              subtitle: Text('Bus #12 reached your registered pickup stop.'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Alert #2: Boarding Confirmed'),
              subtitle: Text('Rohan safely boarded Bus #12 at 7:42 AM.'),
            ),
          ],
        ),
      ),
    );
  }
}
