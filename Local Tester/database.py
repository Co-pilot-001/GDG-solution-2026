from __future__ import annotations

import sqlite3
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "local_tester.db"
SCHEMA_PATH = BASE_DIR / "database_schema.sql"


class DatabaseManager:
    def __init__(self, db_path: Path = DB_PATH, schema_path: Path = SCHEMA_PATH) -> None:
        self.db_path = Path(db_path)
        self.schema_path = Path(schema_path)

    def connect(self) -> sqlite3.Connection:
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        connection = sqlite3.connect(self.db_path)
        connection.row_factory = sqlite3.Row
        connection.execute("PRAGMA foreign_keys = ON;")
        return connection

    def create_database(self) -> None:
        if not self.schema_path.exists():
            raise FileNotFoundError(f"Schema file not found: {self.schema_path}")

        schema_sql = self.schema_path.read_text(encoding="utf-8")
        with self.connect() as connection:
            connection.executescript(schema_sql)
            connection.commit()

    def table_exists(self, table_name: str) -> bool:
        query = """
            SELECT 1
            FROM sqlite_master
            WHERE type = 'table' AND name = ?
            LIMIT 1
        """
        with self.connect() as connection:
            row = connection.execute(query, (table_name,)).fetchone()
        return row is not None

    def list_tables(self) -> list[str]:
        query = """
            SELECT name
            FROM sqlite_master
            WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
            ORDER BY name
        """
        with self.connect() as connection:
            rows = connection.execute(query).fetchall()
        return [row["name"] for row in rows]


def initialize_database() -> None:
    manager = DatabaseManager()
    manager.create_database()
    print(f"Database ready: {manager.db_path}")
    print("Tables:")
    for table_name in manager.list_tables():
        print(f"- {table_name}")


if __name__ == "__main__":
    initialize_database()
