import os
import json
import sys

def restore_backup(backup_file_path):
    """
    Reads a JSON backup file and restores the markdown files to the current directory.
    """
    if not os.path.exists(backup_file_path):
        print(f"Error: Backup file not found: {backup_file_path}")
        return

    try:
        with open(backup_file_path, "r", encoding="utf-8") as f:
            backup_data = json.load(f)
            
        files = backup_data.get("files", {})
        timestamp = backup_data.get("timestamp", "Unknown")
        
        print(f"Restoring backup from: {timestamp}")
        
        for filename, content in files.items():
            # Safety check: Prevent directory traversal or overwriting critical system files
            if ".." in filename or filename.startswith("/") or filename.startswith("\\"):
                 print(f"Skipping unsafe filename: {filename}")
                 continue
                 
            with open(filename, "w", encoding="utf-8") as f:
                f.write(content)
            print(f"Restored: {filename}")
            
        print("All files restored successfully.")
        
    except json.JSONDecodeError:
        print("Error: Invalid JSON format in backup file.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python restore_local.py <path_to_backup.json>")
    else:
        restore_backup(sys.argv[1])
