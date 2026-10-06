-- AGENT 1: Backend Database Schema & Spatial Engine
-- Location: backend/schema.sql
-- Database: Supabase PostgreSQL 15 + PostGIS + pgvector

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

-- User Roles
DROP TYPE IF EXISTS user_role CASCADE;
CREATE TYPE user_role AS ENUM ('SCHOOL_ADMIN', 'DRIVER', 'PARENT');

-- Event Types
DROP TYPE IF EXISTS event_type CASCADE;
CREATE TYPE event_type AS ENUM ('ARRIVED_AT_STOP', 'BOARDED', 'DROPPED_OFF', 'UNAUTHORIZED_ATTEMPT', 'MANUAL_PIN_OVERRIDE');

-- Profiles
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    role user_role NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Buses
CREATE TABLE IF NOT EXISTS buses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bus_number VARCHAR(50) UNIQUE NOT NULL,
    license_plate VARCHAR(50) NOT NULL,
    driver_id UUID REFERENCES profiles(id),
    capacity INT DEFAULT 40,
    is_active BOOLEAN DEFAULT TRUE
);

-- Students
CREATE TABLE IF NOT EXISTS students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_official_id VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    class_section VARCHAR(50) NOT NULL,
    parent_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    bus_id UUID REFERENCES buses(id),
    pickup_location GEOMETRY(Point, 4326),
    manual_pin VARCHAR(6) DEFAULT '123456',
    face_embedding vector(128),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transit Events
CREATE TABLE IF NOT EXISTS transit_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID REFERENCES students(id),
    bus_id UUID REFERENCES buses(id) NOT NULL,
    driver_id UUID REFERENCES profiles(id) NOT NULL,
    event_type event_type NOT NULL,
    face_confidence_score FLOAT,
    distance_meters FLOAT,
    location GEOMETRY(Point, 4326) NOT NULL,
    event_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PostGIS Distance Check Function (Haversine Spatial)
CREATE OR REPLACE FUNCTION check_stop_geofence(
    bus_lat FLOAT,
    bus_lng FLOAT,
    stop_lat FLOAT,
    stop_lng FLOAT,
    radius_meters INT DEFAULT 50
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN ST_DWithin(
        ST_SetSRID(ST_MakePoint(bus_lng, bus_lat), 4326)::geography,
        ST_SetSRID(ST_MakePoint(stop_lng, stop_lat), 4326)::geography,
        radius_meters
    );
END;
$$ LANGUAGE plpgsql;

-- Cosine Similarity vector match function for pgvector embeddings
CREATE OR REPLACE FUNCTION match_face_embedding(
    query_embedding vector(128),
    match_threshold FLOAT DEFAULT 0.75
) RETURNS TABLE (
    student_id UUID,
    full_name VARCHAR(100),
    similarity FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id AS student_id,
        s.full_name,
        (1 - (s.face_embedding <=> query_embedding))::FLOAT AS similarity
    FROM students s
    WHERE (1 - (s.face_embedding <=> query_embedding)) >= match_threshold
    ORDER BY similarity DESC;
END;
$$ LANGUAGE plpgsql;
