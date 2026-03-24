import os
import json
import datetime

# Configuration
FILES_TO_BACKUP = [
    "Agent.md",
    "memory.md",
    "Soul.md",
    # Add other files here
]

BACKUP_DIR = "backups"

def backup_files():
    """
    Reads the specialized markdown files and packs them into a single JSON object.
    """
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR)
        
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_data = {
        "timestamp": timestamp,
        "files": {}
    }

    for filename in FILES_TO_BACKUP:
        if os.path.exists(filename):
            with open(filename, "r", encoding="utf-8") as f:
                backup_data["files"][filename] = f.read()
            print(f"Packed: {filename}")
        else:
            print(f"Warning: File not found: {filename}")
    
    output_filename = os.path.join(BACKUP_DIR, f"backup_{timestamp}.json")
    with open(output_filename, "w", encoding="utf-8") as f:
        json.dump(backup_data, f, ensure_ascii=False, indent=2)
        
    print(f"Backup created successfully: {output_filename}")

if __name__ == "__main__":
    backup_files()
