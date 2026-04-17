# GDG Solution 2026

This project contains UI prototypes for an emergency response and NGO resource coordination platform. The frontend currently covers officer login, a command dashboard, field reporting, donation intake, and a broader NGO problem-solution concept view.

## Project Structure

- `SRAS/GDG Solution/index.html`: Officer login
- `SRAS/GDG Solution/dashboard.html`: Live operations dashboard
- `SRAS/GDG Solution/report.html`: Incident and field report entry
- `SRAS/GDG Solution/donations.html`: Resource and donation intake
- `ngo_problem_solution.html`: NGO aggregation, heatmap, allocation, and impact concept

## What The UI Suggests

From the current screens, the platform needs to support:

- officer and admin users
- regions and geolocations
- incident reports
- operational incidents
- volunteers and deployments
- donors and donations
- external data sources
- community needs by region
- alerts, notifications, and activity logs

## Recommended Database Entities

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

## Database Schema File

The basic SQL schema is available in [database_schema.sql](/d:/Veenit/Projects/GDG%20Solution%202026/database_schema.sql).

## Core Flow

1. An officer logs in.
2. A field report is submitted with category, location, and urgency.
3. The report creates or updates an incident.
4. Command staff allocate volunteers or resources.
5. Donors contribute money or supplies.
6. Data from multiple sources is aggregated for smarter allocation and impact tracking.

## Current Limitations

- login is hardcoded in the frontend
- data is not stored in a backend yet
- sessions use browser `localStorage`
- dashboard values are mocked
- donation and report forms do not persist records

## Next Step

Build a backend API and connect these pages to the schema in `database_schema.sql`.
