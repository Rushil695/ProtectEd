from fastapi import FastAPI
from pydantic import BaseModel
import sqlite3
from datetime import datetime, timedelta

# Initialize FastAPI app
app = FastAPI()

# Connect to the SQLite database
conn = sqlite3.connect("example.db", check_same_thread=False)
cursor = conn.cursor()

# Create tables for video and audio incidents
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


# Pydantic models for request body
class IncidentLog(BaseModel):
    room_number: str
    event_time: str  # Format: HH:MM:SS
    incident_source: str  # video or audio


# Endpoint to handle video incidents
@app.post("/video-incident-log/")
async def log_video_incident(incident: IncidentLog):
    try:
        cursor.execute(
            "INSERT INTO incident_log (room_number, event_time, incident_source) VALUES (?, ?, ?)",
            (incident.room_number, incident.event_time, incident.incident_source),
        )
        conn.commit()
        return {
            "message": f"Video incident logged for room {incident.room_number} at {incident.event_time}"
        }
    except Exception as e:
        return {"error": str(e)}


# Endpoint to handle audio incidents from the frontend
@app.post("/audio-incident-log/")
async def log_audio_incident(incident: IncidentLog):
    try:
        cursor.execute(
            "INSERT INTO incident_log (room_number, event_time, incident_source) VALUES (?, ?, ?)",
            (incident.room_number, incident.event_time, incident.incident_source),
        )
        conn.commit()
        return {
            "message": f"Audio incident logged for room {incident.room_number} at {incident.event_time}"
        }
    except Exception as e:
        return {"error": str(e)}


# Updated report-event endpoint to send the oldest available incident
@app.get("/report-event/")
async def report_event():
    try:
        # Fetch the oldest incident from the database
        cursor.execute(
            "SELECT rowid, room_number, event_time, incident_source FROM incident_log ORDER BY event_time ASC LIMIT 1"
        )
        result = cursor.fetchone()

        if result:
            rowid, room_number, event_time, incident_source = result
            # Convert event_time string to a datetime object
            event_time_obj = datetime.strptime(event_time, "%H:%M:%S")
            current_time = datetime.now()

            # Check if the incident is older than 10 seconds
            if current_time - event_time_obj > timedelta(seconds=10):
                # If older than 10 seconds, delete the log and skip it
                cursor.execute("DELETE FROM incident_log WHERE rowid = ?", (rowid,))
                conn.commit()
                return {
                    "message": "Incident older than 10 seconds, ignored and deleted"
                }

            # Otherwise, delete the log and return it
            cursor.execute("DELETE FROM incident_log WHERE rowid = ?", (rowid,))
            conn.commit()
            return {
                "room_number": room_number,
                "event_time": event_time,
                "incident_source": incident_source,
                "message": "Incident reported and deleted",
            }
        else:
            return {"message": "No incidents available"}

    except Exception as e:
        return {"error": str(e)}
