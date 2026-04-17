CREATE TABLE users (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(120) NOT NULL,
  username VARCHAR(80) UNIQUE NOT NULL,
  email VARCHAR(150),
  password_hash TEXT NOT NULL,
  role VARCHAR(40) NOT NULL,
  phone VARCHAR(30),
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE regions (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(120) NOT NULL,
  city VARCHAR(120),
  state VARCHAR(120),
  country VARCHAR(120) DEFAULT 'India',
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  severity_score DECIMAL(5,2) DEFAULT 0
);

CREATE TABLE reports (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  submitted_by BIGINT NOT NULL REFERENCES users(id),
  region_id BIGINT REFERENCES regions(id),
  incident_location TEXT NOT NULL,
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  resource_category VARCHAR(60) NOT NULL,
  priority VARCHAR(20) NOT NULL,
  description TEXT,
  status VARCHAR(30) DEFAULT 'submitted',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE incidents (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  report_id BIGINT REFERENCES reports(id),
  region_id BIGINT REFERENCES regions(id),
  title VARCHAR(200) NOT NULL,
  incident_type VARCHAR(60),
  priority VARCHAR(20) NOT NULL,
  status VARCHAR(30) DEFAULT 'open',
  assigned_officer_id BIGINT REFERENCES users(id),
  opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP
);

CREATE TABLE volunteers (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(120) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  home_region_id BIGINT REFERENCES regions(id),
  skills TEXT,
  availability_status VARCHAR(30) DEFAULT 'available',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE deployments (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  incident_id BIGINT REFERENCES incidents(id),
  volunteer_id BIGINT REFERENCES volunteers(id),
  region_id BIGINT REFERENCES regions(id),
  assigned_by BIGINT REFERENCES users(id),
  deployment_type VARCHAR(40),
  status VARCHAR(30) DEFAULT 'assigned',
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP
);

CREATE TABLE donors (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  donor_name VARCHAR(150) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  donor_type VARCHAR(30) DEFAULT 'individual'
);

CREATE TABLE donations (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  donor_id BIGINT NOT NULL REFERENCES donors(id),
  donation_type VARCHAR(30) NOT NULL,
  value_numeric DECIMAL(12,2) NOT NULL,
  unit VARCHAR(30),
  notes TEXT,
  target_region_id BIGINT REFERENCES regions(id),
  status VARCHAR(30) DEFAULT 'received',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE data_sources (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  source_name VARCHAR(150) NOT NULL,
  source_type VARCHAR(50) NOT NULL,
  owner_org VARCHAR(150),
  status VARCHAR(30) DEFAULT 'connected',
  records_count INT DEFAULT 0,
  last_sync_at TIMESTAMP
);

CREATE TABLE community_needs (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  region_id BIGINT NOT NULL REFERENCES regions(id),
  data_source_id BIGINT REFERENCES data_sources(id),
  category VARCHAR(60) NOT NULL,
  need_count INT DEFAULT 0,
  severity_score DECIMAL(5,2) DEFAULT 0,
  recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT REFERENCES users(id),
  incident_id BIGINT REFERENCES incidents(id),
  message TEXT NOT NULL,
  level VARCHAR(20),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE activity_logs (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT REFERENCES users(id),
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(50),
  entity_id BIGINT,
  details TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
