CREATE TABLE IF NOT EXISTS public.users (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE,
  email TEXT,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL,
  phone TEXT,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.regions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT,
  state TEXT,
  country TEXT NOT NULL DEFAULT 'India',
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  severity_score NUMERIC(5, 2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS public.reports (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  submitted_by BIGINT NOT NULL REFERENCES public.users(id),
  region_id BIGINT REFERENCES public.regions(id),
  incident_location TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  resource_category TEXT NOT NULL,
  priority TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'submitted',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.incidents (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  report_id BIGINT REFERENCES public.reports(id),
  region_id BIGINT REFERENCES public.regions(id),
  title TEXT NOT NULL,
  incident_type TEXT,
  priority TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open',
  assigned_officer_id BIGINT REFERENCES public.users(id),
  opened_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.volunteers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  home_region_id BIGINT REFERENCES public.regions(id),
  skills TEXT,
  availability_status TEXT NOT NULL DEFAULT 'available',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.deployments (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  incident_id BIGINT REFERENCES public.incidents(id),
  volunteer_id BIGINT REFERENCES public.volunteers(id),
  region_id BIGINT REFERENCES public.regions(id),
  assigned_by BIGINT REFERENCES public.users(id),
  deployment_type TEXT,
  status TEXT NOT NULL DEFAULT 'assigned',
  assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.donors (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  donor_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  donor_type TEXT NOT NULL DEFAULT 'individual'
);

CREATE TABLE IF NOT EXISTS public.donations (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  donor_id BIGINT NOT NULL REFERENCES public.donors(id),
  donation_type TEXT NOT NULL,
  value_numeric NUMERIC(12, 2) NOT NULL,
  unit TEXT,
  notes TEXT,
  target_region_id BIGINT REFERENCES public.regions(id),
  status TEXT NOT NULL DEFAULT 'received',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.data_sources (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  source_name TEXT NOT NULL,
  source_type TEXT NOT NULL,
  owner_org TEXT,
  status TEXT NOT NULL DEFAULT 'connected',
  records_count INTEGER NOT NULL DEFAULT 0,
  last_sync_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.community_needs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  region_id BIGINT NOT NULL REFERENCES public.regions(id),
  data_source_id BIGINT REFERENCES public.data_sources(id),
  category TEXT NOT NULL,
  need_count INTEGER NOT NULL DEFAULT 0,
  severity_score NUMERIC(5, 2) NOT NULL DEFAULT 0,
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.notifications (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT REFERENCES public.users(id),
  incident_id BIGINT REFERENCES public.incidents(id),
  message TEXT NOT NULL,
  level TEXT,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.activity_logs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT REFERENCES public.users(id),
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id BIGINT,
  details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
