// AGENT 4: School Management Web Portal Dashboard
// Location: apps/school_admin/src/pages/dashboard.jsx
// Stack: Next.js / React

import React from 'react';

export default function AdminDashboard() {
  return (
    <div style={{ padding: '2rem', fontFamily: "'Outfit', sans-serif", background: '#F7F3EA', color: '#292824', minHeight: '100vh' }}>
      <div style={{ background: '#FFFDF8', padding: '1.5rem 2rem', borderRadius: '20px', border: '1px solid rgba(113, 139, 117, 0.2)', boxShadow: '0 10px 30px rgba(41, 40, 36, 0.06)', marginBottom: '2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#718B75', textTransform: 'uppercase', letterSpacing: '0.5px' }}>SafeRide AI Platform</span>
          <h1 style={{ fontWeight: 800, fontSize: '1.75rem', margin: '0.25rem 0 0 0', color: '#292824' }}>
            Student Safety Dashboard
          </h1>
        </div>
        <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
          <span style={{ background: 'rgba(113, 139, 117, 0.12)', color: '#718B75', padding: '8px 16px', borderRadius: '14px', fontWeight: 700, fontSize: '0.9rem' }}>
            🚌 Bus #12 &bull; On Route 🟢 (ETA: 08 min)
          </span>
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.5rem', marginBottom: '2rem' }}>
        <div style={{ background: '#FFFDF8', padding: '1.5rem', borderRadius: '20px', border: '1px solid rgba(113, 139, 117, 0.2)', boxShadow: '0 10px 30px rgba(41, 40, 36, 0.06)' }}>
          <h3 style={{ color: '#636058', fontSize: '0.88rem', fontWeight: 600, marginBottom: '0.5rem' }}>✅ Boarded Today</h3>
          <h2 style={{ fontSize: '2.2rem', fontWeight: 800, color: '#718B75' }}>24 Students</h2>
        </div>
        <div style={{ background: '#FFFDF8', padding: '1.5rem', borderRadius: '20px', border: '1px solid rgba(113, 139, 117, 0.2)', boxShadow: '0 10px 30px rgba(41, 40, 36, 0.06)' }}>
          <h3 style={{ color: '#636058', fontSize: '0.88rem', fontWeight: 600, marginBottom: '0.5rem' }}>🟢 Verification Status</h3>
          <h2 style={{ fontSize: '2.2rem', fontWeight: 800, color: '#718B75' }}>24 Verified</h2>
        </div>
        <div style={{ background: '#FFFDF8', padding: '1.5rem', borderRadius: '20px', border: '1px solid rgba(113, 139, 117, 0.2)', boxShadow: '0 10px 30px rgba(41, 40, 36, 0.06)' }}>
          <h3 style={{ color: '#636058', fontSize: '0.88rem', fontWeight: 600, marginBottom: '0.5rem' }}>⚠️ Exception Log</h3>
          <h2 style={{ fontSize: '2.2rem', fontWeight: 800, color: '#A65D45' }}>1 Exception</h2>
        </div>
      </div>
    </div>
  );
}

