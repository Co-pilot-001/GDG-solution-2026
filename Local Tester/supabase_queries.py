from __future__ import annotations

from typing import Any

from supabase_client import get_supabase_admin_client


supabase = get_supabase_admin_client()


def create_user(
    full_name: str,
    username: str,
    password_hash: str,
    role: str,
    email: str | None = None,
    phone: str | None = None,
) -> Any:
    return supabase.table("users").insert(
        {
            "full_name": full_name,
            "username": username,
            "password_hash": password_hash,
            "role": role,
            "email": email,
            "phone": phone,
        }
    ).execute()


def list_users() -> Any:
    return supabase.table("users").select("*").order("id").execute()


def create_region(name: str, city: str | None = None, state: str | None = None) -> Any:
    return supabase.table("regions").insert(
        {
            "name": name,
            "city": city,
            "state": state,
        }
    ).execute()


def create_report(
    submitted_by: int,
    incident_location: str,
    resource_category: str,
    priority: str,
    region_id: int | None = None,
    description: str | None = None,
    latitude: float | None = None,
    longitude: float | None = None,
) -> Any:
    return supabase.table("reports").insert(
        {
            "submitted_by": submitted_by,
            "region_id": region_id,
            "incident_location": incident_location,
            "latitude": latitude,
            "longitude": longitude,
            "resource_category": resource_category,
            "priority": priority,
            "description": description,
        }
    ).execute()


def list_reports() -> Any:
    return supabase.table("reports").select("*").order("id").execute()


def create_donor(donor_name: str, donor_type: str = "individual") -> Any:
    return supabase.table("donors").insert(
        {
            "donor_name": donor_name,
            "donor_type": donor_type,
        }
    ).execute()


def create_donation(
    donor_id: int,
    donation_type: str,
    value_numeric: float,
    unit: str | None = None,
    notes: str | None = None,
    target_region_id: int | None = None,
) -> Any:
    return supabase.table("donations").insert(
        {
            "donor_id": donor_id,
            "donation_type": donation_type,
            "value_numeric": value_numeric,
            "unit": unit,
            "notes": notes,
            "target_region_id": target_region_id,
        }
    ).execute()


def list_donations() -> Any:
    return supabase.table("donations").select("*").order("id").execute()


if __name__ == "__main__":
    print("Supabase query helpers are ready.")
