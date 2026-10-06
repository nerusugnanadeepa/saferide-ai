// AGENT 1: Backend API Routes
// Location: backend/api_routes.js

const express = require('express');
const router = express.Router();
const { evaluateMultiFactorMatrix } = require('./multi_factor_matrix');

// In-Memory state store for live demo & multi-agent integration
const state = {
    buses: [
        { id: 'bus-12', number: 'Bus #12', driver: 'Rajesh Kumar', lat: 17.4455, lng: 78.3815, speed: 28, status: 'EN_ROUTE' },
        { id: 'bus-08', number: 'Bus #08', driver: 'Suresh Nair', lat: 17.4380, lng: 78.3910, speed: 0, status: 'AT_STOP' }
    ],
    students: [
        { id: 'stu-101', name: 'Rohan Verma', studentCode: 'STU-9941', class: 'Grade 5-A', busId: 'bus-12', stopLat: 17.4452, stopLng: 78.3812, pin: '123456', boarded: false },
        { id: 'stu-102', name: 'Ananya Sharma', studentCode: 'STU-9942', class: 'Grade 4-B', busId: 'bus-12', stopLat: 17.4452, stopLng: 78.3812, pin: '654321', boarded: false },
        { id: 'stu-103', name: 'Kabir Patel', studentCode: 'STU-9943', class: 'Grade 5-A', busId: 'bus-08', stopLat: 17.4380, stopLng: 78.3910, pin: '112233', boarded: false }
    ],
    events: [
        { id: 'evt-1', studentName: 'Rohan Verma', busId: 'bus-12', eventType: 'BOARDED', faceScore: 0.94, distanceMeters: 14, timestamp: new Date(Date.now() - 3600000).toISOString() }
    ]
};

// Helper function: Haversine distance in meters
function calculateHaversineDistance(lat1, lon1, lat2, lon2) {
    const R = 6371e3; // metres
    const φ1 = lat1 * Math.PI / 180;
    const φ2 = lat2 * Math.PI / 180;
    const Δφ = (lat2 - lat1) * Math.PI / 180;
    const Δλ = (lon2 - lon1) * Math.PI / 180;

    const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return Math.round(R * c);
}

// 1. Health check
router.get('/health', (req, res) => {
    res.json({ status: 'ONLINE', service: 'SafeRide AI API Core', timestamp: new Date().toISOString() });
});

// 2. Get Student Roster
router.get('/students', (req, res) => {
    res.json({ students: state.students });
});

// 3. Multi-Factor Face Verification Endpoint (Driver Scans Face)
router.post('/verify-boarding', (req, res) => {
    const { studentId, faceScore, scannedBusId, busLat, busLng } = req.body;
    const student = state.students.find(s => s.id === studentId || s.studentCode === studentId) || state.students[0];

    const distanceMeters = calculateHaversineDistance(
        busLat || 17.4455,
        busLng || 78.3815,
        student.stopLat,
        student.stopLng
    );

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

// 4. Manual PIN Fallback Verification (Agent 2 Driver App Modal)
router.post('/verify-pin', (req, res) => {
    const { studentCode, pin, scannedBusId, busLat, busLng } = req.body;
    const student = state.students.find(s => s.studentCode === studentCode || s.id === studentCode);

    if (!student) {
        return res.status(404).json({ success: false, message: 'Student ID not found' });
    }

    const pinMatch = student.pin === pin;
    const distanceMeters = calculateHaversineDistance(
        busLat || 17.4455,
        busLng || 78.3815,
        student.stopLat,
        student.stopLng
    );

    const result = evaluateMultiFactorMatrix({
        faceScore: null,
        scannedBusId: scannedBusId || 'bus-12',
        assignedBusId: student.busId,
        distanceMeters: distanceMeters,
        manualPinVerified: pinMatch
    });

    const eventRecord = {
        id: `evt-${Date.now()}`,
        studentId: student.id,
        studentName: student.name,
        busId: scannedBusId || 'bus-12',
        eventType: result.verified ? 'MANUAL_PIN_OVERRIDE' : 'UNAUTHORIZED_ATTEMPT',
        faceScore: null,
        distanceMeters,
        verificationDetails: result,
        timestamp: new Date().toISOString()
    };

    state.events.unshift(eventRecord);
    if (result.verified) student.boarded = true;

    res.json({
        success: result.verified,
        student: student.name,
        pinMatch,
        verification: result,
        event: eventRecord
    });
});

// 5. Driver GPS Location Stream
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

// 6. Admin Fleet & Exceptions
router.get('/admin/exceptions', (req, res) => {
    const exceptions = state.events.filter(e => e.eventType === 'UNAUTHORIZED_ATTEMPT');
    res.json({ exceptionsCount: exceptions.length, exceptions });
});

router.get('/fleet', (req, res) => {
    res.json({ buses: state.buses, students: state.students, recentEvents: state.events.slice(0, 15) });
});

module.exports = router;
