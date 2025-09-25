#!/usr/bin/env python3

import os
import sqlite3
import argparse
from datetime import datetime
from pathlib import Path


def get_db_path():
    """Get the database file path in the home directory."""
    home = Path.home()
    return home / '.directory_log.sqlite'


def create_connection(db_path):
    """Create a database connection."""
    return sqlite3.connect(str(db_path))


def create_table(conn):
    """Create the directory_log table if it doesn't exist."""
    conn.execute("""
        CREATE TABLE IF NOT EXISTS directory_log (
            directory_path TEXT PRIMARY KEY,
            last_accessed TIMESTAMP
        )
    """)


def upsert_directory(conn, directory_path):
    """Insert or update the directory entry with current timestamp."""
    current_time = datetime.now().isoformat()
    conn.execute("""
        INSERT OR REPLACE INTO directory_log (directory_path, last_accessed)
        VALUES (?, ?)
    """, (directory_path, current_time))
    conn.commit()


def log_directory(directory_path):
    """Log the directory access to the database."""
    try:
        # Normalize the path
        normalized_path = str(Path(directory_path).resolve())

        # Get database path
        db_path = get_db_path()

        # Create connection
        conn = create_connection(db_path)

        try:
            # Create table if needed
            create_table(conn)

            # Upsert directory entry
            upsert_directory(conn, normalized_path)

        finally:
            conn.close()

    except Exception:
        # Silent failure for PROMPT_COMMAND integration
        pass


def main():
    """Main function to handle command line arguments and log directory."""
    try:
        parser = argparse.ArgumentParser(description='Log directory access to database')
        parser.add_argument('path', help='Directory path to log')

        args = parser.parse_args()

        # Check if path exists and is a directory
        if os.path.exists(args.path) and os.path.isdir(args.path):
            log_directory(args.path)

    except Exception:
        # Silent failure for PROMPT_COMMAND integration
        pass


if __name__ == '__main__':
    main()