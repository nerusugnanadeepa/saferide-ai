# Multi-Agent Workspace Guidelines & Branch Workflow
## SafeRide AI — Hardware-Free Student Safety System
**Target Repository**: `https://github.com/nerusugnanadeepa/saferide-ai`

---

## 1. Governance & Orchestration Architecture

This repository operates under a **4+1 Multi-Agent Execution Framework**. Each agent has strict domain ownership, dedicated git feature branches, and predefined input/output API contracts.

```
                   ┌───────────────────────────────────────────────┐
                   │           LEAD MONITORING AGENT               │
                   │  - PR Reviews & Conflict Resolution           │
                   │  - Integration Testing & CI Verification      │
                   │  - Branch: main                               │
                   └───────────────────────┬───────────────────────┘
                                           │
    ┌──────────────────────────┬───────────┴───────────┬──────────────────────────┐
    │                          │                       │                          │
    ▼                          ▼                       ▼                          ▼
┌───────────────────────┐  ┌───────────────────────┐  ┌───────────────────────┐  ┌───────────────────────┐
│       AGENT 1         │  │       AGENT 2         │  │       AGENT 3         │  │       AGENT 4         │
│  Backend & DB Core    │  │ Driver App & Vision   │  │ Parent App & FCM      │  │ School Admin Portal   │
│                       │  │                       │  │                       │  │                       │
│ Branch:               │  │ Branch:               │  │ Branch:               │  │ Branch:               │
│ feature/agent-1-      │  │ feature/agent-2-      │  │ feature/agent-3-      │  │ feature/agent-4-      │
│ backend-db            │  │ driver-geofence-vision│  │ parent-fcm-location   │  │ school-admin-dashboard│
└───────────────────────┘  └───────────────────────┘  └───────────────────────┘  └───────────────────────┘
```

---

## 2. Agent Responsibilities & Work Boundaries

### 👑 Lead Monitoring Agent (`main`)
- **Primary Goal**: Maintain code health, review PRs from Agents 1–4, and execute CI/CD validation.
- **Rules**:
  1. Never write raw feature code directly on `main` without a Pull Request.
  2. Verify all API schema contracts before approving merges.
  3. Run integration smoke tests across all 3 user app views.

### ⚙️ Agent 1: Backend & Database Core (`feature/agent-1-backend-db`)
- **Primary Goal**: Deliver PostgreSQL/Supabase schemas, spatial PostGIS queries, `pgvector` similarity functions, and REST API definitions.
- **Key Files**:
  - `backend/schema.sql`
  - `backend/api_routes.js`
  - `backend/multi_factor_matrix.js`

### 🚌 Agent 2: Driver Mobile App & Vision Engine (`feature/agent-2-driver-geofence-vision`)
- **Primary Goal**: Build Driver App UI, Haversine GPS geofence triggers, MobileFaceNet scanning interface, and Manual PIN fallback modal.
- **Key Files**:
  - `src/driver_app/view.js`
  - `src/driver_app/geofence_engine.js`
  - `src/driver_app/face_scanner.js`

### 📱 Agent 3: Parent Mobile App & FCM Alert Service (`feature/agent-3-parent-fcm-location`)
- **Primary Goal**: Build Parent App UI, Interactive Map for GPS pickup registration, and FCM Alert handlers for Alert #1 and Alert #2.
- **Key Files**:
  - `src/parent_app/view.js`
  - `src/parent_app/pickup_register.js`
  - `src/parent_app/notification_listener.js`

### 🏫 Agent 4: School Admin Management Portal (`feature/agent-4-school-admin-dashboard`)
- **Primary Goal**: Build Web Admin Dashboard, Student Biometric Enrollment view, Live Fleet Surveillance map, and Exception Alert table.
- **Key Files**:
  - `src/admin_portal/dashboard.js`
  - `src/admin_portal/enrollment.js`
  - `src/admin_portal/fleet_monitor.js`

---

## 3. Git Branch & Commit Policy

1. **Branch Names**:
   - `feature/agent-1-backend-db`
   - `feature/agent-2-driver-geofence-vision`
   - `feature/agent-3-parent-fcm-location`
   - `feature/agent-4-school-admin-dashboard`

2. **Commit Conventions**:
   - `feat(agent-1): add postgis geofence distance function`
   - `feat(agent-2): implement haversine stop trigger`
   - `feat(agent-3): build interactive pickup map picker`
   - `feat(agent-4): render real-time fleet exception logs`
   - `docs(lead): update architecture diagram and agents md`

---

## 4. Multi-Factor Safety Logic Specification

All agents must strictly follow the **Multi-Factor Matrix Verification Formula**:

$$\text{Boarding Valid} = (\text{CosineSim}(\vec{V}_{live}, \vec{V}_{reg}) \ge 0.75) \land (\text{Bus}_{scanned} == \text{Bus}_{assigned}) \land (\text{Distance}_{stop} \le 50\text{m})$$

If any condition evaluates to `FALSE`, log an `UNAUTHORIZED_ATTEMPT` or `EXCEPTION` event.
