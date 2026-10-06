// AGENT 1: Multi-Factor Matrix Logic Engine
// Location: backend/multi_factor_matrix.js

/**
 * Multi-Factor Verification Formula:
 * Boarding Valid = (Face match >= 0.75 OR Manual PIN verified) AND (Bus scanned == Bus assigned) AND (Stop distance <= 50m)
 */
function evaluateMultiFactorMatrix({ faceScore, scannedBusId, assignedBusId, distanceMeters, manualPinVerified = false }) {
    const faceMatch = (faceScore !== undefined && faceScore !== null) ? faceScore >= 0.75 : false;
    const identityVerified = faceMatch || manualPinVerified;
    const busMatch = scannedBusId === assignedBusId;
    const geofenceMatch = distanceMeters <= 50;

    const isValid = identityVerified && busMatch && geofenceMatch;

    let flagReason = null;
    if (!busMatch) {
        flagReason = 'UNASSIGNED_BUS_ATTEMPT';
    } else if (!geofenceMatch) {
        flagReason = 'OUTSIDE_REGISTERED_STOP_GEOFENCE';
    } else if (!identityVerified) {
        flagReason = 'BIOMETRIC_MATCH_FAILED';
    }

    return {
        verified: isValid,
        faceMatch,
        manualPinVerified,
        busMatch,
        geofenceMatch,
        distanceMeters,
        flagReason,
        verificationMethod: manualPinVerified ? 'MANUAL_PIN' : (faceMatch ? 'BIOMETRIC_FACE' : 'REJECTED'),
        timestamp: new Date().toISOString()
    };
}

module.exports = { evaluateMultiFactorMatrix };
