import os
import json
import datetime
import argparse
from crypto_utils import save_encrypted_backup

# Configuration matches backup_local.py or can be passed via args
DEFAULT_FILES = [
    "Agent.md",
    "memory.md",
    "Soul.md",
    "README.md" # Example
]
BACKUP_DIR = "backups"

def backup_secure(password, files=None, output_dir=BACKUP_DIR):
    if files is None:
        files = DEFAULT_FILES
        
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_data = {
        "timestamp": timestamp,
        "files": {}
    }

    print("Packing files...")
    for filename in files:
        if os.path.exists(filename):
            with open(filename, "r", encoding="utf-8") as f:
                backup_data["files"][filename] = f.read()
        else:
             print(f"Warning: File not found: {filename}")

    output_filename = os.path.join(output_dir, f"backup_secure_{timestamp}.blob")
    
    try:
        # Provide the raw dict, save_encrypted_backup handles JSON dump -> Encrypt -> Write
        # Using a specialized function from crypto_utils that expects data to encrypt?
        # Let's adjust crypto_utils usage.
        # save_encrypted_backup in crypto_utils: (json_data, output_path, password)
        # But crypto_utils was written to take json_str in encrypt_data. 
        # Helper 'save_encrypted_backup' in crypto_utils.py I wrote above takes (json_data, output_path, password).
        # Let's check crypto_utils.py content again to be sure.
        
        save_encrypted_backup(backup_data, output_filename, password)
        print(f"Secure backup created: {output_filename}")
        
    except Exception as e:
        print(f"Encryption failed: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create a secure encrypted backup of Openclaw memory.")
    parser.add_argument("--password", required=True, help="Password for encryption")
    parser.add_argument("--files", nargs="*", help="Specific files to backup")
    
    args = parser.parse_args()
    
    file_list = args.files if args.files else DEFAULT_FILES
    backup_secure(args.password, file_list)
