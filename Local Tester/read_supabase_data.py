from __future__ import annotations

from typing import Any

from supabase_client import get_supabase_admin_client


supabase = get_supabase_admin_client()


def fetch_rows(table_name: str) -> list[dict[str, Any]]:
    response = supabase.table(table_name).select("*").order("id").execute()
    return list(getattr(response, "data", []) or [])


def print_section(title: str, rows: list[dict[str, Any]]) -> None:
    print(f"\n{title}")
    print("-" * len(title))
    if not rows:
        print("No records found.")
        return

    for row in rows:
        print(row)


def main() -> None:
    print_section("USERS", fetch_rows("users"))
    print_section("REPORTS", fetch_rows("reports"))
    print_section("INCIDENTS", fetch_rows("incidents"))
    print_section("DONATIONS", fetch_rows("donations"))


if __name__ == "__main__":
    main()
