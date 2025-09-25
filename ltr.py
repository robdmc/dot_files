#!/usr/bin/env python3

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


def format_timestamp(timestamp_str):
    """Format timestamp for human-readable display."""
    try:
        # Parse the timestamp string back to datetime
        if isinstance(timestamp_str, str):
            # Handle potential microseconds
            if '.' in timestamp_str:
                dt = datetime.fromisoformat(timestamp_str)
            else:
                dt = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S')
        else:
            dt = timestamp_str

        return dt.strftime('%Y-%m-%d %H:%M:%S')
    except:
        return str(timestamp_str)


def list_directories(latest_only=False):
    """List directories from the database, most recent last or only latest."""
    try:
        db_path = get_db_path()

        if not db_path.exists():
            if not latest_only:
                print("No directory log database found.")
            return

        conn = create_connection(db_path)

        try:
            if latest_only:
                cursor = conn.execute("""
                    SELECT directory_path
                    FROM directory_log
                    ORDER BY last_accessed DESC
                    LIMIT 1
                """)
                row = cursor.fetchone()
                if row:
                    print(row[0])
            else:
                cursor = conn.execute("""
                    SELECT directory_path, last_accessed
                    FROM directory_log
                    ORDER BY last_accessed ASC
                """)
                rows = cursor.fetchall()

                if not rows:
                    print("No directory entries found.")
                    return

                # Display results
                for directory_path, last_accessed in rows:
                    formatted_time = format_timestamp(last_accessed)
                    print(f"{formatted_time}  {directory_path}")

        finally:
            conn.close()

    except Exception as e:
        if not latest_only:
            print(f"Error reading directory log: {e}")


def main():
    """Main function to display directory log."""
    parser = argparse.ArgumentParser(description='List directory access log')
    parser.add_argument('--latest', action='store_true',
                       help='Show only the most recent directory')

    args = parser.parse_args()
    list_directories(latest_only=args.latest)


if __name__ == '__main__':
    main()