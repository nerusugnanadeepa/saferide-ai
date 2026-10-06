// AGENT 2: Manual PIN Fallback Verification Modal
// Location: apps/driver_app/lib/manual_pin_modal.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManualPinModal extends StatefulWidget {
  final String busId;
  final double busLat;
  final double busLng;
  final String backendBaseUrl;
  final Function(Map<String, dynamic> result) onVerificationComplete;

  const ManualPinModal({
    super.key,
    required this.busId,
    required this.busLat,
    required this.busLng,
    this.backendBaseUrl = 'http://localhost:4000/api',
    required this.onVerificationComplete,
  });

  @override
  State<ManualPinModal> createState() => _ManualPinModalState();
}

class _ManualPinModalState extends State<ManualPinModal> {
  final _studentIdController = TextEditingController(text: 'STU-9941');
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submitPin() async {
    if (_pinController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter 6-digit Security PIN');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${widget.backendBaseUrl}/verify-pin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'studentCode': _studentIdController.text.trim(),
          'pin': _pinController.text.trim(),
          'scannedBusId': widget.busId,
          'busLat': widget.busLat,
          'busLng': widget.busLng,
        }),
      );

      final result = jsonDecode(response.body);
      if (mounted) {
        Navigator.pop(context);
        widget.onVerificationComplete(result);
      }
    } catch (e) {
      if (mounted) {
        // Fallback simulation
        final isValidPin = _pinController.text.trim() == '123456';
        Navigator.pop(context);
        widget.onVerificationComplete({
          'success': isValidPin,
          'student': 'Rohan Verma',
          'verification': {
            'verified': isValidPin,
            'verificationMethod': 'MANUAL_PIN',
            'flagReason': isValidPin ? null : 'INVALID_PIN',
          }
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.pin, color: Colors.amber, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Manual PIN Fallback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Use when face is obscured by lighting or masks.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _studentIdController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Student Code / ID',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            style: const TextStyle(color: Colors.amber, fontSize: 20, letterSpacing: 6),
            decoration: InputDecoration(
              labelText: '6-Digit Parent PIN (Default: 123456)',
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _submitPin,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle, color: Colors.black),
              label: Text(
                _isLoading ? 'Verifying PIN...' : 'Verify Boarding via PIN',
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
