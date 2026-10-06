// AGENT 1: Backend Server Entry Point
// Location: backend/server.js

const express = require('express');
const http = require('http');
const cors = require('cors');
const { Server } = require('socket.io');
const apiRoutes = require('./api_routes');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: { origin: '*', methods: ['GET', 'POST'] }
});

const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

// Attach API routes
app.use('/api', apiRoutes);

// Socket.io for Real-time GPS Location & Notification Feeds
io.on('connection', (socket) => {
    console.log(`[SafeRide Socket] Client Connected: ${socket.id}`);

    socket.on('driver:location-update', (data) => {
        // Broadcast telemetry to parent app & admin dashboard
        io.emit('telemetry:bus-location', data);
    });

    socket.on('driver:student-scanned', (data) => {
        io.emit('telemetry:boarding-event', data);
    });

    socket.on('disconnect', () => {
        console.log(`[SafeRide Socket] Client Disconnected: ${socket.id}`);
    });
});

server.listen(PORT, () => {
    console.log(`=======================================================`);
    console.log(`🚀 SafeRide AI Backend API Server running on port ${PORT}`);
    console.log(`👉 Health check: http://localhost:${PORT}/api/health`);
    console.log(`=======================================================`);
});
