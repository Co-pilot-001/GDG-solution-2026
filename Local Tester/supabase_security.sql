-- Run this after supabase_schema.sql in the Supabase SQL Editor.
-- This secures the public schema tables by enabling Row Level Security.
-- With RLS enabled and no policies, requests using the publishable key
-- will not be able to read or write table data.

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.regions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.volunteers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deployments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_needs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- Optional example policy:
-- Uncomment only if you intentionally want signed-in users to read regions.
--
-- CREATE POLICY "authenticated users can read regions"
-- ON public.regions
-- FOR SELECT
-- TO authenticated
-- USING (true);
