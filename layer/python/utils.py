from datetime import datetime

def extract_date_parts(filename: str):
    name_part = filename.replace('.txt', '')
    parts = name_part.split('-')
    if len(parts) < 5:
        return None, None, None
    return parts[2], parts[3], parts[4]

def current_timestamp():
    return datetime.utcnow().isoformat()
