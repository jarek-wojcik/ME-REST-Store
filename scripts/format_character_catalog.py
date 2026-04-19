#!/usr/bin/env python3
"""Rewrite the CharacterCatalog entries in model/characters.go so each field is on its own line."""

from __future__ import annotations
import argparse
import re
from pathlib import Path


def find_catalog_range(text: str) -> tuple[int, int]:
    marker = 'var CharacterCatalog = []CharacterDef{'
    start = text.find(marker)
    if start == -1:
        raise ValueError("CharacterCatalog declaration not found")
    index = text.index('{', start + text[start:].index('{'))
    depth = 0
    in_string = False
    string_quote = ''
    escaped = False
    for i in range(index, len(text)):
        ch = text[i]
        if in_string:
            if escaped:
                escaped = False
            elif ch == '\\':
                escaped = True
            elif ch == string_quote:
                in_string = False
        else:
            if ch in ('"', '`'):
                in_string = True
                string_quote = ch
            elif ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
                if depth == 0:
                    return index + 1, i
    raise ValueError("Could not find matching closing brace for CharacterCatalog")


def split_top_level(text: str, separator: str = ',') -> list[str]:
    parts: list[str] = []
    current: list[str] = []
    depth = 0
    in_string = False
    string_quote = ''
    escaped = False
    for ch in text:
        current.append(ch)
        if in_string:
            if escaped:
                escaped = False
            elif ch == '\\':
                escaped = True
            elif ch == string_quote:
                in_string = False
        else:
            if ch in ('"', '`'):
                in_string = True
                string_quote = ch
            elif ch in '{[(':
                depth += 1
            elif ch in '}])':
                depth -= 1
            elif ch == separator and depth == 0:
                part = ''.join(current[:-1]).strip()
                if part:
                    parts.append(part)
                current = []
    remainder = ''.join(current).strip()
    if remainder:
        parts.append(remainder)
    return parts


def format_entry(entry: str) -> str:
    stripped = entry.strip()
    has_trailing_comma = stripped.endswith(',')
    if has_trailing_comma:
        stripped = stripped[:-1].rstrip()
    if not stripped.startswith('{') or not stripped.endswith('}'):
        return entry
    inner = stripped[1:-1].strip()
    if not inner:
        return '\t{\n\t},'
    fields = split_top_level(inner, separator=',')
    formatted_lines = []
    for field in fields:
        formatted_lines.append(f"\t\t{field.strip()},")
    formatted_entry = "\t{\n" + "\n".join(formatted_lines) + "\n\t},"
    return formatted_entry


def reformat_catalog_body(body: str) -> str:
    entries: list[str] = []
    current: list[str] = []
    depth = 0
    in_string = False
    string_quote = ''
    escaped = False
    for ch in body:
        current.append(ch)
        if in_string:
            if escaped:
                escaped = False
            elif ch == '\\':
                escaped = True
            elif ch == string_quote:
                in_string = False
        else:
            if ch in ('"', '`'):
                in_string = True
                string_quote = ch
            elif ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
            elif ch == ',' and depth == 0:
                entry_text = ''.join(current[:-1]) + ','
                entries.append(entry_text)
                current = []
    remainder = ''.join(current).strip()
    if remainder:
        entries.append(remainder)

    formatted_entries: list[str] = []
    for entry in entries:
        stripped = entry.strip()
        if not stripped:
            continue
        if stripped.startswith('//'):
            formatted_entries.append(entry.rstrip())
            continue
        formatted_entries.append(format_entry(entry))
    return '\n\t'.join(formatted_entries).rstrip('\n') + '\n'


def rewrite_file(path: Path, dry_run: bool = False) -> int:
    text = path.read_text(encoding='utf-8')
    start, end = find_catalog_range(text)
    before = text[:start]
    body = text[start:end]
    after = text[end:]
    formatted_body = reformat_catalog_body(body)
    new_text = before + formatted_body + after
    if new_text == text:
        return 0
    if dry_run:
        print(new_text)
    else:
        path.write_text(new_text, encoding='utf-8')
    return 1


def main() -> None:
    parser = argparse.ArgumentParser(description="Format CharacterCatalog entries in model/characters.go")
    parser.add_argument("--file", default="SFS_Core_ASI/SFSWebserver/model/characters.go", help="Path to characters.go")
    parser.add_argument("--dry-run", action="store_true", help="Print the reformatted file instead of writing it")
    args = parser.parse_args()
    path = Path(args.file)
    changed = rewrite_file(path, dry_run=args.dry_run)
    if changed:
        print(f"Formatted {path}")
    else:
        print(f"No changes needed for {path}")


if __name__ == "__main__":
    main()
