// AGENT 1: Multi-Factor Matrix Logic Engine
// Location: backend/multi_factor_matrix.js

function evaluateMultiFactorMatrix({ faceScore, scannedBusId, assignedBusId, distanceMeters }) {
    const faceMatch = faceScore >= 0.75;
    const busMatch = scannedBusId === assignedBusId;
    const geofenceMatch = distanceMeters <= 50;

    const isValid = faceMatch && busMatch && geofenceMatch;

    let flagReason = null;
    if (!busMatch) flagReason = 'UNASSIGNED_BUS_ATTEMPT';
    else if (!geofenceMatch) flagReason = 'OUTSIDE_REGISTERED_STOP_GEOFENCE';
    else if (!faceMatch) flagReason = 'BIOMETRIC_MATCH_FAILED';

    return {
        verified: isValid,
        faceMatch,
        busMatch,
        geofenceMatch,
        flagReason,
        timestamp: new Date().toISOString()
    };
}

module.exports = { evaluateMultiFactorMatrix };
