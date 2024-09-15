import sqlite3


def create_table():
    # Connect to the SQLite database
    conn = sqlite3.connect("example.db")
    cursor = conn.cursor()

    # Create the incident_log table if it doesn't exist
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS incident_log (
            room_number TEXT NOT NULL,
            event_time TEXT NOT NULL,
            incident_source TEXT NOT NULL
        )
        """
    )
    conn.commit()
    # Close the connection
    conn.close()


def get_all_entries():
    # Connect to the SQLite database
    conn = sqlite3.connect("example.db")
    cursor = conn.cursor()

    # Execute the query to get all entries
    cursor.execute("SELECT * FROM incident_log")
    rows = cursor.fetchall()

    # Close the connection
    conn.close()

    return rows


if __name__ == "__main__":
    create_table()  # Ensure the table is created
    entries = get_all_entries()
    for entry in entries:
        print(entry)
