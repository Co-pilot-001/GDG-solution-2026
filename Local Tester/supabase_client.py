from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv
from supabase import Client, create_client


BASE_DIR = Path(__file__).resolve().parent
ENV_PATH = BASE_DIR / ".env"

load_dotenv(ENV_PATH)


def _get_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise ValueError(f"Missing {name} in environment or .env file.")
    return value


def get_supabase_public_client() -> Client:
    url = _get_env("SUPABASE_URL")
    key = _get_env("SUPABASE_PUBLISHABLE_KEY")
    return create_client(url, key)


def get_supabase_admin_client() -> Client:
    url = _get_env("SUPABASE_URL")
    key = os.getenv("SUPABASE_SECRET_KEY") or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
    if not key:
        raise ValueError(
            "Missing SUPABASE_SECRET_KEY or SUPABASE_SERVICE_ROLE_KEY in environment or .env file."
        )
    return create_client(url, key)


def get_supabase_client() -> Client:
    # Backend code should prefer the admin client when available.
    # This falls back to the publishable key only for low-privilege usage.
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_SECRET_KEY") or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
    if not url:
        raise ValueError("Missing SUPABASE_URL in environment or .env file.")
    if not key:
        key = os.getenv("SUPABASE_PUBLISHABLE_KEY")
    if not key:
        raise ValueError(
            "Missing SUPABASE_SECRET_KEY, SUPABASE_SERVICE_ROLE_KEY, or SUPABASE_PUBLISHABLE_KEY."
        )

    return create_client(url, key)


if __name__ == "__main__":
    client = get_supabase_client()
    print("Supabase client initialized successfully.")
    print(f"Project URL: {client.supabase_url}")
