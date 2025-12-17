#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
from typing import Any


def _load_json(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)
    if isinstance(data, dict):
        return data
    raise ValueError(f"{path} must contain a JSON object at the top level.")


def _ensure_dict(parent: dict[str, Any], key: str) -> dict[str, Any]:
    val = parent.get(key)
    if isinstance(val, dict):
        return val
    new: dict[str, Any] = {}
    parent[key] = new
    return new


def _ensure_list(parent: dict[str, Any], key: str) -> list[Any]:
    val = parent.get(key)
    if isinstance(val, list):
        return val
    new: list[Any] = []
    parent[key] = new
    return new


def _merge_required_servers(doc: dict[str, Any], *, agents_dir: Path) -> dict[str, Any]:
    mcp_servers = _ensure_dict(doc, "mcpServers")

    # Required: sub-agents-mcp
    sub_agents = _ensure_dict(mcp_servers, "sub-agents")
    sub_agents.setdefault("command", "npx")
    args = sub_agents.get("args")
    if not isinstance(args, list) or not args:
        sub_agents["args"] = ["-y", "sub-agents-mcp"]
    env = _ensure_dict(sub_agents, "env")
    env["AGENTS_DIR"] = str(agents_dir.resolve())
    env.setdefault("AGENT_TYPE", "cursor")

    # Required: Perplexity MCP server
    perplexity = _ensure_dict(mcp_servers, "perplexity")
    perplexity.setdefault("command", "npx")
    p_args = perplexity.get("args")
    if not isinstance(p_args, list) or not p_args:
        perplexity["args"] = ["-y", "@perplexity-ai/mcp-server"]
    p_env = _ensure_dict(perplexity, "env")
    p_env.setdefault("PERPLEXITY_API_KEY", "${PERPLEXITY_API_KEY}")

    # Required: grep MCP server
    # If user already has a more specific config (command/args/url), keep it.
    grep_srv = _ensure_dict(mcp_servers, "grep")
    if not any(k in grep_srv for k in ("url", "command")):
        grep_srv["url"] = "https://mcp.grep.app"

    return doc


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Merge required MCP servers into .cursor/mcp.json without removing existing servers."
    )
    parser.add_argument(
        "--repo-root",
        default=str(Path(__file__).resolve().parent),
        help="Repo root (defaults to directory containing this script).",
    )
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    cursor_dir = repo_root / ".cursor"
    agents_dir = cursor_dir / "agents"
    mcp_path = cursor_dir / "mcp.json"

    cursor_dir.mkdir(parents=True, exist_ok=True)
    agents_dir.mkdir(parents=True, exist_ok=True)

    doc = _load_json(mcp_path)
    doc = _merge_required_servers(doc, agents_dir=agents_dir)

    tmp_path = mcp_path.with_suffix(".json.tmp")
    with tmp_path.open("w", encoding="utf-8") as f:
        json.dump(doc, f, indent=2, sort_keys=True)
        f.write("\n")
    os.replace(tmp_path, mcp_path)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())



