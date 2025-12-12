import sqlite3
import json
from pathlib import Path

def sql_to_json():
    # Connect to the database
    conn = sqlite3.connect('coursecatalog.sql')
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    # Query all courses
    cursor.execute('SELECT * FROM courses')
    rows = cursor.fetchall()
    
    # Convert to list of dictionaries
    courses = [dict(row) for row in rows]
    
    # Create output directory if it doesn't exist
    output_dir = Path('assets/data')
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Write to JSON file
    output_path = output_dir / 'courses.json'
    with open(output_path, 'w') as f:
        json.dump(courses, f, indent=2)
    
    print(f"JSON file saved to {output_path}")
    conn.close()

if __name__ == '__main__':
    sql_to_json()