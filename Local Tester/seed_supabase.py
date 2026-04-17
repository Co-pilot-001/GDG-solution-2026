from __future__ import annotations

from typing import Any

from supabase_client import get_supabase_admin_client


supabase = get_supabase_admin_client()


def first_or_none(response: Any) -> dict[str, Any] | None:
    data = getattr(response, "data", None) or []
    return data[0] if data else None


def get_or_create_user() -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("users").select("*").eq("username", "bhushan").limit(1).execute()
    )
    if existing:
        print(f"Using existing user: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("users")
        .insert(
            {
                "full_name": "Bhushan",
                "username": "bhushan",
                "email": "bhushan@example.com",
                "password_hash": "demo_hash_for_local_testing",
                "role": "officer",
                "phone": "+91-9000000001",
            }
        )
        .execute()
    )
    print(f"Created user: {created['id']}")
    return created


def get_or_create_region() -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("regions")
        .select("*")
        .eq("name", "Mumbai HQ")
        .eq("city", "Mumbai")
        .limit(1)
        .execute()
    )
    if existing:
        print(f"Using existing region: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("regions")
        .insert(
            {
                "name": "Mumbai HQ",
                "city": "Mumbai",
                "state": "Maharashtra",
                "country": "India",
                "latitude": 19.0760,
                "longitude": 72.8777,
                "severity_score": 82.50,
            }
        )
        .execute()
    )
    print(f"Created region: {created['id']}")
    return created


def get_or_create_report(user_id: int, region_id: int) -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("reports")
        .select("*")
        .eq("submitted_by", user_id)
        .eq("incident_location", "Sector-4 Water Point")
        .limit(1)
        .execute()
    )
    if existing:
        print(f"Using existing report: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("reports")
        .insert(
            {
                "submitted_by": user_id,
                "region_id": region_id,
                "incident_location": "Sector-4 Water Point",
                "latitude": 19.0330,
                "longitude": 72.8515,
                "resource_category": "Water Supply",
                "priority": "high",
                "description": "Water depletion reported by field officer. Immediate tanker support needed.",
            }
        )
        .execute()
    )
    print(f"Created report: {created['id']}")
    return created


def get_or_create_incident(report_id: int, region_id: int, officer_id: int) -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("incidents")
        .select("*")
        .eq("report_id", report_id)
        .limit(1)
        .execute()
    )
    if existing:
        print(f"Using existing incident: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("incidents")
        .insert(
            {
                "report_id": report_id,
                "region_id": region_id,
                "title": "Sector-4 Water Crisis",
                "incident_type": "water_crisis",
                "priority": "high",
                "status": "open",
                "assigned_officer_id": officer_id,
            }
        )
        .execute()
    )
    print(f"Created incident: {created['id']}")
    return created


def get_or_create_volunteer(region_id: int) -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("volunteers")
        .select("*")
        .eq("email", "aarti.volunteer@example.com")
        .limit(1)
        .execute()
    )
    if existing:
        print(f"Using existing volunteer: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("volunteers")
        .insert(
            {
                "full_name": "Aarti Patil",
                "phone": "+91-9000000002",
                "email": "aarti.volunteer@example.com",
                "home_region_id": region_id,
                "skills": "first aid, logistics",
                "availability_status": "available",
                "active": True,
            }
        )
        .execute()
    )
    print(f"Created volunteer: {created['id']}")
    return created


def get_or_create_donor() -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("donors")
        .select("*")
        .eq("donor_name", "Helping Hands Foundation")
        .limit(1)
        .execute()
    )
    if existing:
        print(f"Using existing donor: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("donors")
        .insert(
            {
                "donor_name": "Helping Hands Foundation",
                "phone": "+91-9000000003",
                "email": "contact@helpinghands.example",
                "donor_type": "ngo",
            }
        )
        .execute()
    )
    print(f"Created donor: {created['id']}")
    return created


def get_or_create_donation(donor_id: int, region_id: int) -> dict[str, Any]:
    existing = first_or_none(
        supabase.table("donations")
        .select("*")
        .eq("donor_id", donor_id)
        .eq("donation_type", "money")
        .eq("value_numeric", 5000)
        .limit(1)
        .execute()
    )
    if existing:
        print(f"Using existing donation: {existing['id']}")
        return existing

    created = first_or_none(
        supabase.table("donations")
        .insert(
            {
                "donor_id": donor_id,
                "donation_type": "money",
                "value_numeric": 5000,
                "unit": "INR",
                "notes": "Initial emergency contribution for Sector-4 response.",
                "target_region_id": region_id,
            }
        )
        .execute()
    )
    print(f"Created donation: {created['id']}")
    return created


def main() -> None:
    user = get_or_create_user()
    region = get_or_create_region()
    report = get_or_create_report(user["id"], region["id"])
    get_or_create_incident(report["id"], region["id"], user["id"])
    get_or_create_volunteer(region["id"])
    donor = get_or_create_donor()
    get_or_create_donation(donor["id"], region["id"])
    print("Supabase seed completed successfully.")


if __name__ == "__main__":
    main()
