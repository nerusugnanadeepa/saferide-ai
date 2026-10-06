// AGENT 4: School Management Web Portal Dashboard
// Location: apps/school_admin/src/pages/dashboard.jsx
// Stack: Next.js / React

import React from 'react';

export default function AdminDashboard() {
  return (
    <div style={{ padding: '2rem', fontFamily: 'sans-serif', background: '#0b0f19', color: '#fff', minHeight: '100vh' }}>
      <h1>School Management Fleet Safety Dashboard</h1>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1rem', margin: '2rem 0' }}>
        <div style={{ background: '#161f31', padding: '1rem', borderRadius: '12px' }}>
          <h3>Active Fleet Buses</h3>
          <h2>14 / 14</h2>
        </div>
        <div style={{ background: '#161f31', padding: '1rem', borderRadius: '12px' }}>
          <h3>Boarded Students Today</h3>
          <h2 style={{ color: '#10b981' }}>482</h2>
        </div>
        <div style={{ background: '#161f31', padding: '1rem', borderRadius: '12px' }}>
          <h3>Safety Exceptions</h3>
          <h2 style={{ color: '#ef4444' }}>1</h2>
        </div>
      </div>
    </div>
  );
}
