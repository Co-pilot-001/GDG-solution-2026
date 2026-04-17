# Local Tester

This folder is a self-contained working area created from analysis of the existing project files in the outer `GDG Solution 2026` workspace.

## Purpose

Use this folder for local testing, backend planning, and new file creation without modifying the original UI prototype files outside this directory.

## Source Files Used For Analysis

The following outer files were used as references:

- `SRAS/GDG Solution/index.html`
- `SRAS/GDG Solution/dashboard.html`
- `SRAS/GDG Solution/report.html`
- `SRAS/GDG Solution/donations.html`
- `SRAS/GDG Solution/README.md`
- `ngo_problem_solution.html`

## What The Existing UI Covers

Based on those reference files, the platform currently models:

- officer login and access control
- live dashboard and incident monitoring
- field report submission
- donations and resource intake
- volunteer coordination
- regional need aggregation
- impact and allocation tracking

## Files In This Folder

- `README.md`: local working documentation
- `database_schema.sql`: SQLite schema used for local setup
- `database.py`: Python database bootstrap script
- `supabase_schema.sql`: PostgreSQL schema for Supabase SQL Editor
- `supabase_security.sql`: RLS hardening SQL for the same Supabase project
- `supabase_client.py`: Supabase client bootstrap using environment variables
- `supabase_queries.py`: starter CRUD helpers for Supabase
- `seed_supabase.py`: tiny seed script for demo data
- `read_supabase_data.py`: prints seeded Supabase data for quick verification
- `.env.example`: environment variable template for Supabase connection

## Suggested Core Tables

- `users`
- `regions`
- `reports`
- `incidents`
- `volunteers`
- `deployments`
- `donors`
- `donations`
- `data_sources`
- `community_needs`
- `notifications`
- `activity_logs`

## Core Flow

1. Officer logs in.
2. Incident or need is reported from the field.
3. A report becomes an incident record.
4. Volunteers or resources are assigned by region.
5. Donors contribute money or supplies.
6. Aggregated data helps improve allocation and impact tracking.

## Notes

- Outer folders are treated as analysis/reference only.
- New implementation work can now be kept inside `Local Tester`.
- The schema in this folder is intentionally basic and suitable for a first backend version.

## How To Create The Database

Run this from inside `Local Tester`:

```bash
python database.py
```

This will create `local_tester.db` automatically if it does not exist, and it will create any missing tables using `CREATE TABLE IF NOT EXISTS`.

## Supabase Setup Files

The Supabase integration files in this folder are separate from the SQLite prototype:

- [supabase_schema.sql](/d:/Veenit/Projects/GDG%20Solution%202026/Local%20Tester/supabase_schema.sql)
- [supabase_security.sql](/d:/Veenit/Projects/GDG%20Solution%202026/Local%20Tester/supabase_security.sql)
- [supabase_client.py](/d:/Veenit/Projects/GDG%20Solution%202026/Local%20Tester/supabase_client.py)
- [supabase_queries.py](/d:/Veenit/Projects/GDG%20Solution%202026/Local%20Tester/supabase_queries.py)
- [.env.example](</d:/Veenit/Projects/GDG Solution 2026/Local Tester/.env.example>)

### Step 1

Copy `supabase_schema.sql` into the Supabase SQL Editor and run it.

### Step 2

Create a local `.env` file based on `.env.example`.
For backend use, prefer `SUPABASE_SECRET_KEY` and do not commit it.

### Step 3

Install the Python packages:

```bash
pip install supabase python-dotenv
```

### Step 4

Use `supabase_queries.py` as the starting point for inserts, reads, and updates.

### Step 5

Run `supabase_security.sql` in Supabase to enable Row Level Security on all tables.
This keeps the same project but locks down table access by default for publishable-key requests.

### Step 6

If you want sample data for testing, run:

```bash
python seed_supabase.py
```

This inserts a small demo set for:

- one officer user
- one region
- one report
- one incident
- one volunteer
- one donor
- one donation

### Step 7

To verify the seeded data from Python, run:

```bash
python read_supabase_data.py
```
