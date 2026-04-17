PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE,
  email TEXT,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL,
  phone TEXT,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS regions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  city TEXT,
  state TEXT,
  country TEXT NOT NULL DEFAULT 'India',
  latitude REAL,
  longitude REAL,
  severity_score REAL NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  submitted_by INTEGER NOT NULL,
  region_id INTEGER,
  incident_location TEXT NOT NULL,
  latitude REAL,
  longitude REAL,
  resource_category TEXT NOT NULL,
  priority TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'submitted',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (submitted_by) REFERENCES users(id),
  FOREIGN KEY (region_id) REFERENCES regions(id)
);

CREATE TABLE IF NOT EXISTS incidents (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  report_id INTEGER,
  region_id INTEGER,
  title TEXT NOT NULL,
  incident_type TEXT,
  priority TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open',
  assigned_officer_id INTEGER,
  opened_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at TEXT,
  FOREIGN KEY (report_id) REFERENCES reports(id),
  FOREIGN KEY (region_id) REFERENCES regions(id),
  FOREIGN KEY (assigned_officer_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS volunteers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  home_region_id INTEGER,
  skills TEXT,
  availability_status TEXT NOT NULL DEFAULT 'available',
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (home_region_id) REFERENCES regions(id)
);

CREATE TABLE IF NOT EXISTS deployments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id INTEGER,
  volunteer_id INTEGER,
  region_id INTEGER,
  assigned_by INTEGER,
  deployment_type TEXT,
  status TEXT NOT NULL DEFAULT 'assigned',
  assigned_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at TEXT,
  FOREIGN KEY (incident_id) REFERENCES incidents(id),
  FOREIGN KEY (volunteer_id) REFERENCES volunteers(id),
  FOREIGN KEY (region_id) REFERENCES regions(id),
  FOREIGN KEY (assigned_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS donors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  donor_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  donor_type TEXT NOT NULL DEFAULT 'individual'
);

CREATE TABLE IF NOT EXISTS donations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  donor_id INTEGER NOT NULL,
  donation_type TEXT NOT NULL,
  value_numeric REAL NOT NULL,
  unit TEXT,
  notes TEXT,
  target_region_id INTEGER,
  status TEXT NOT NULL DEFAULT 'received',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (donor_id) REFERENCES donors(id),
  FOREIGN KEY (target_region_id) REFERENCES regions(id)
);

CREATE TABLE IF NOT EXISTS data_sources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_name TEXT NOT NULL,
  source_type TEXT NOT NULL,
  owner_org TEXT,
  status TEXT NOT NULL DEFAULT 'connected',
  records_count INTEGER NOT NULL DEFAULT 0,
  last_sync_at TEXT
);

CREATE TABLE IF NOT EXISTS community_needs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  region_id INTEGER NOT NULL,
  data_source_id INTEGER,
  category TEXT NOT NULL,
  need_count INTEGER NOT NULL DEFAULT 0,
  severity_score REAL NOT NULL DEFAULT 0,
  recorded_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (region_id) REFERENCES regions(id),
  FOREIGN KEY (data_source_id) REFERENCES data_sources(id)
);

CREATE TABLE IF NOT EXISTS notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  incident_id INTEGER,
  message TEXT NOT NULL,
  level TEXT,
  is_read INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (incident_id) REFERENCES incidents(id)
);

CREATE TABLE IF NOT EXISTS activity_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id INTEGER,
  details TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
