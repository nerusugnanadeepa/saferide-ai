// AGENT 1: Backend API Routes
// Location: backend/api_routes.js

const express = require('express');
const router = express.Router();
const { evaluateMultiFactorMatrix } = require('./multi_factor_matrix');

// In-Memory state store for live demo telemetry & fleet events
const state = {
    buses: [
        { id: 'bus-12', number: 'Bus #12', driver: 'Rajesh Kumar', lat: 17.4455, lng: 78.3815, speed: 28, status: 'EN_ROUTE' },
        { id: 'bus-08', number: 'Bus #08', driver: 'Suresh Nair', lat: 17.4380, lng: 78.3910, speed: 0, status: 'AT_STOP' }
    ],
    students: [
        { id: 'stu-101', name: 'Rohan Verma', class: 'Grade 5-A', busId: 'bus-12', stopLat: 17.4452, stopLng: 78.3812, parentPhone: '+91 9876543210', boarded: false }
    ],
    events: [
        { id: 'evt-1', studentName: 'Rohan Verma', busId: 'bus-12', eventType: 'BOARDED', faceScore: 0.94, distanceMeters: 14, timestamp: new Date(Date.now() - 3600000).toISOString() }
    ]
};

// 1. Health check
router.get('/health', (req, res) => {
    res.json({ status: 'ONLINE', service: 'SafeRide AI API Core', timestamp: new Date().toISOString() });
});

// 2. Multi-Factor Verification Endpoint (Driver Scans Student Face)
router.post('/verify-boarding', (req, res) => {
    const { studentId, faceScore, scannedBusId, busLat, busLng } = req.body;
    const student = state.students.find(s => s.id === (studentId || 'stu-101')) || state.students[0];

    // Haversine distance calculation (in meters)
    const R = 6371e3; // Earth radius in meters
    const φ1 = (busLat || 17.4455) * Math.PI / 180;
    const φ2 = student.stopLat * Math.PI / 180;
    const Δφ = (student.stopLat - (busLat || 17.4455)) * Math.PI / 180;
    const Δλ = (student.stopLng - (busLng || 78.3815)) * Math.PI / 180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const distanceMeters = Math.round(R * c);

    const result = evaluateMultiFactorMatrix({
        faceScore: faceScore !== undefined ? parseFloat(faceScore) : 0.92,
        scannedBusId: scannedBusId || 'bus-12',
        assignedBusId: student.busId,
        distanceMeters: distanceMeters
    });

    const eventRecord = {
        id: `evt-${Date.now()}`,
        studentId: student.id,
        studentName: student.name,
        busId: scannedBusId || 'bus-12',
        eventType: result.verified ? 'BOARDED' : 'UNAUTHORIZED_ATTEMPT',
        faceScore: faceScore || 0.92,
        distanceMeters,
        verificationDetails: result,
        timestamp: new Date().toISOString()
    };

    state.events.unshift(eventRecord);
    if (result.verified) student.boarded = true;

    res.json({
        success: result.verified,
        student: student.name,
        verification: result,
        event: eventRecord
    });
});

// 3. Live Fleet Location Update (Driver GPS Stream)
router.post('/location-stream', (req, res) => {
    const { busId, lat, lng, speed } = req.body;
    const bus = state.buses.find(b => b.id === busId);
    if (bus) {
        bus.lat = lat;
        bus.lng = lng;
        if (speed !== undefined) bus.speed = speed;
    }
    res.json({ success: true, bus });
});

// 4. Admin Exception Logs Endpoint
router.get('/admin/exceptions', (req, res) => {
    const exceptions = state.events.filter(e => e.eventType === 'UNAUTHORIZED_ATTEMPT');
    res.json({ exceptionsCount: exceptions.length, exceptions });
});

// 5. Get All Fleet Data
router.get('/fleet', (req, res) => {
    res.json({ buses: state.buses, students: state.students, recentEvents: state.events.slice(0, 10) });
});

module.exports = router;
