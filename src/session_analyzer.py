import os
import json
import sqlite3
import sys
from pathlib import Path
from datetime import datetime, timedelta

# Configuration
WORKSPACE_ROOT = Path(os.getcwd())
STORAGE_ROOT = Path(os.path.expanduser("~/Library/Application Support/Cursor/User/workspaceStorage"))
TRANSCRIPTS_DIR = Path(os.path.expanduser("~/.cursor/projects/Users-joonatan-repos-cursor-research-plan-implement/agent-transcripts"))

def find_workspace_db():
    if not STORAGE_ROOT.exists():
        return None
        
    for folder in STORAGE_ROOT.iterdir():
        if not folder.is_dir():
            continue
        workspace_json = folder / "workspace.json"
        if not workspace_json.exists():
            continue
        try:
            with open(workspace_json, 'r') as f:
                data = json.load(f)
            if 'folder' in data and str(WORKSPACE_ROOT) in data['folder']:
                db_path = folder / "state.vscdb"
                if db_path.exists():
                    return str(db_path)
        except:
            continue
    return None

def get_recent_prompts(db_path, limit=20):
    prompts = []
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        cursor.execute("SELECT value FROM ItemTable WHERE key = 'aiService.prompts'")
        row = cursor.fetchone()
        if row:
            data = json.loads(row[0])
            # Data is a list of dicts with 'text'
            # We assume it's chronological. We want the LAST 'limit' entries.
            prompts = [p.get('text', '') for p in data[-limit:]]
    except Exception as e:
        print(f"Error reading prompts: {e}")
    finally:
        if 'conn' in locals():
            conn.close()
    return prompts

def get_recent_transcripts(hours=1):
    recent_files = []
    if not TRANSCRIPTS_DIR.exists():
        return []
        
    now = datetime.now()
    for file_path in TRANSCRIPTS_DIR.glob("*.txt"):
        mtime = datetime.fromtimestamp(file_path.stat().st_mtime)
        if now - mtime < timedelta(hours=hours):
            try:
                content = file_path.read_text()
                recent_files.append({
                    "filename": file_path.name,
                    "mtime": mtime.isoformat(),
                    "content": content
                })
            except:
                pass
    
    # Sort by time
    recent_files.sort(key=lambda x: x['mtime'])
    return recent_files

def main():
    print("Gathering session data...")
    
    # 1. User Prompts
    db_path = find_workspace_db()
    prompts = []
    if db_path:
        print(f"Found DB: {db_path}")
        prompts = get_recent_prompts(db_path)
    else:
        print("Warning: Could not locate Cursor workspace DB.")

    # 2. Sub-agent Transcripts
    transcripts = get_recent_transcripts()
    
    # 3. Output Report
    report = "# Session Context Analysis\n\n"
    
    report += "## Recent User Prompts (Last 20)\n"
    if prompts:
        for i, p in enumerate(prompts, 1):
            report += f"{i}. {p}\n"
    else:
        report += "No prompts found.\n"
        
    report += "\n## Recent Sub-Agent Transcripts (Last 1 Hour)\n"
    if transcripts:
        for t in transcripts:
            report += f"### {t['filename']} ({t['mtime']})\n"
            report += "```\n"
            report += t['content'][:2000] + ("\n... (truncated)" if len(t['content']) > 2000 else "")
            report += "\n```\n"
    else:
        report += "No sub-agent transcripts found in the last hour.\n"

    # Write to a temp file or print
    out_file = WORKSPACE_ROOT / "commands/meta/session_context.md"
    out_file.write_text(report)
    print(f"Context written to: {out_file}")

if __name__ == "__main__":
    main()
