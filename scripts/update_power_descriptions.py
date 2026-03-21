#!/usr/bin/env python3
"""
Script to update power descriptions in powers.go from powers.ts.

USAGE:
    python update_power_descriptions.py

REQUIREMENTS:
    - Python 3.7+
    - No external dependencies (uses only stdlib)

INPUTS:
    - SFS_Core_ASI/01_sheets/character_power_match.csv
      Maps Go power IDs to TypeScript power IDs
    
    - Dashboard/src/lib/data/powers.ts
      Source file containing power definitions with evolution descriptions
    
    - SFS_Core_ASI/SFSWebserver/model/powers.go
      Target file to be updated with new descriptions

OUTPUT:
    - Overwrites powers.go with updated RankDescs

HOW IT WORKS:
1. Reads the character_power_match.csv to map Go power IDs to TS power IDs
2. Parses powers.ts to extract power evolution descriptions (including templates)
3. Fills in template placeholders (e.g., {powerDamage}) with actual values
4. Updates powers.go RankDescs arrays with the filled-in descriptions

NOTES:
    - Template values like {powerDamage} with decimal values (e.g., 0.25) 
      are converted to percentages (25)
    - Descriptions preserve newlines (\n) for proper Go formatting
    - Only powers that exist in the CSV mapping are updated
"""

import csv
import re
import json
from pathlib import Path
from typing import Dict, List, Optional


def build_power_mapping(csv_path: Path) -> Dict[str, str]:
    """
    Build a mapping from Go power ID to TS power ID.
    
    Returns:
        Dict mapping Go power IDs (e.g., 'SFXPowerCustomActionMP_Bloodlust') 
        to TS power IDs (e.g., 'uc')
    """
    mapping = {}
    
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # For each of the 5 power slots (0-4)
            for i in range(5):
                go_power = row.get(f'GoPowerID_{i}', '').strip()
                ts_power = row.get(f'TSPower_{i}', '').strip()
                
                if go_power and ts_power and ts_power not in ['', 'NO_MATCH']:
                    # Store the mapping
                    mapping[go_power] = ts_power
    
    print(f"Built mapping for {len(mapping)} unique Go->TS power pairs")
    return mapping


def parse_powers_ts(ts_path: Path) -> Dict[str, dict]:
    """
    Parse powers.ts to extract all power definitions.
    
    Returns:
        Dict mapping TS power IDs to their full power definition
        (including evolutions array with descriptions and attributes)
    """
    with open(ts_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the POWERS export
    match = re.search(r'export const POWERS = createPowers\(\{', content)
    if not match:
        raise ValueError("Could not find POWERS export in powers.ts")
    
    start_pos = match.end()
    
    # Find the matching closing brace - count braces to handle nesting
    brace_count = 1
    pos = start_pos
    while pos < len(content) and brace_count > 0:
        if content[pos] == '{':
            brace_count += 1
        elif content[pos] == '}':
            brace_count -= 1
        pos += 1
    
    powers_content = content[start_pos:pos-1]
    
    powers = {}
    
    # More robust parsing: split by power IDs at the start of lines
    # Pattern: "  powerID: {" where powerID can include $, letters, numbers
    power_splits = list(re.finditer(r'\n  ([\w$]+): \{', powers_content))
    
    for i, match in enumerate(power_splits):
        power_id = match.group(1)
        start = match.end()
        
        # Find the end of this power definition (start of next power or end of content)
        if i + 1 < len(power_splits):
            end = power_splits[i + 1].start()
        else:
            end = len(powers_content)
        
        power_body = powers_content[start:end]
        
        # Extract evolutions array by finding matching brackets
        evolutions_start = power_body.find('evolutions: [')
        if evolutions_start == -1:
            print(f"Warning: No evolutions found for power {power_id}")
            continue
        
        evolutions_start += len('evolutions: [')
        
        # Find matching closing bracket
        bracket_count = 1
        pos = evolutions_start
        while pos < len(power_body) and bracket_count > 0:
            if power_body[pos] == '[':
                bracket_count += 1
            elif power_body[pos] == ']':
                bracket_count -= 1
            pos += 1
        
        evolutions_content = power_body[evolutions_start:pos-1]
        
        # Parse each evolution object
        evolutions = parse_evolutions(evolutions_content)
        
        if len(evolutions) != 9:
            print(f"Warning: Power {power_id} has {len(evolutions)} evolutions (expected 9)")
        
        powers[power_id] = {
            'id': power_id,
            'evolutions': evolutions
        }
    
    print(f"Parsed {len(powers)} powers from powers.ts")
    return powers


def parse_evolutions(evolutions_content: str) -> List[dict]:
    """
    Parse the evolutions array content.
    Each evolution is an object with name, description, and attributes.
    """
    evolutions = []
    
    # Split by evolution objects - look for "      {" at the start
    evo_starts = [m.start() for m in re.finditer(r'\n      \{', evolutions_content)]
    evo_starts.append(len(evolutions_content))
    
    for i in range(len(evo_starts) - 1):
        evo_text = evolutions_content[evo_starts[i]:evo_starts[i+1]].strip()
        
        if not evo_text or evo_text == ',':
            continue
        
        # Remove leading/trailing braces and comma
        evo_text = evo_text.strip()
        if evo_text.startswith('{'):
            evo_text = evo_text[1:]
        if evo_text.endswith(','):
            evo_text = evo_text[:-1]
        if evo_text.endswith('}'):
            evo_text = evo_text[:-1]
        
        # Extract name
        name_match = re.search(r'name:\s*"([^"]+)"', evo_text)
        if not name_match:
            continue
        name = name_match.group(1)
        
        # Extract description (handle multiline strings)
        desc_match = re.search(r'description:\s*"((?:[^"\\]|\\.)*)"', evo_text, re.DOTALL)
        if not desc_match:
            print(f"Warning: Could not extract description for evolution: {name}")
            continue
        description = desc_match.group(1)
        # Unescape \n in the description
        description = description.replace('\\n', '\n')
        
        # Extract attributes
        attr_match = re.search(r'attributes:\s*\{([^}]*)\}', evo_text)
        if not attr_match:
            print(f"Warning: Could not extract attributes block for evolution: {name}")
            # Don't skip - use empty attributes
            attributes = {}
        else:
            attributes_str = attr_match.group(1)
            attributes = {}
            
            # Parse attributes - format is "key: value," or "key: value\n"
            for attr_pair in re.finditer(r'(\w+):\s*([^,\n]+)', attributes_str):
                key = attr_pair.group(1).strip()
                value_str = attr_pair.group(2).strip()
                
                # Try to parse as number
                try:
                    if '.' in value_str:
                        value = float(value_str)
                    else:
                        value = int(value_str)
                except ValueError:
                    # Keep as string (remove quotes if present)
                    value = value_str.strip('"\'')
                
                attributes[key] = value
        
        evolutions.append({
            'name': name,
            'description': description,
            'attributes': attributes
        })
    
    return evolutions


def fill_template(template: str, attributes: dict) -> str:
    """
    Fill template placeholders in a description with actual values.
    
    Templates look like: "Increase damage by {powerDamage}%."
    Values are taken from attributes and converted to percentages if needed.
    """
    def replace_placeholder(match):
        key = match.group(1)
        if key in attributes:
            value = attributes[key]
            
            # Convert decimal values to percentages (0.25 -> 25, -0.6 -> -60)
            if isinstance(value, (int, float)):
                # Check if it looks like a percentage in decimal form
                if -1 <= value <= 1 and value != 0 and abs(value) < 1:
                    # Convert to percentage
                    pct = int(value * 100)
                    return str(pct)
                else:
                    # Keep as-is (could be an integer or large float)
                    if isinstance(value, float) and value.is_integer():
                        return str(int(value))
                    return str(value)
            else:
                return str(value)
        else:
            # Keep the placeholder if we don't have a value
            return match.group(0)
    
    return re.sub(r'\{(\w+)\}', replace_placeholder, template)


def format_go_description(description: str) -> str:
    """
    Format a description for inclusion in Go code.
    Escapes quotes and handles newlines properly.
    """
    # Escape backslashes first
    description = description.replace('\\', '\\\\')
    # Escape quotes
    description = description.replace('"', '\\"')
    # Escape actual newlines to \n for Go string literals
    description = description.replace('\n', '\\n')
    return description


def generate_rank_descs_go(evolutions: List[dict]) -> str:
    """
    Generate the Go code for RankDescs array from evolution definitions.
    """
    lines = []
    
    for i, evo in enumerate(evolutions, start=1):
        # Fill in the template with actual values
        description = fill_template(evo['description'], evo['attributes'])
        # Format for Go
        description_go = format_go_description(description)
        
        # Determine the comment based on rank
        if i == 1:
            comment = " // Rank 1"
        elif i == 2:
            comment = " // Rank 2"
        elif i == 3:
            comment = " // Rank 3"
        elif i == 4:
            comment = " // Rank 4 - Evolution A"
        elif i == 5:
            comment = " // Rank 4 - Evolution B"
        elif i == 6:
            comment = " // Rank 5 - Evolution A"
        elif i == 7:
            comment = " // Rank 5 - Evolution B"
        elif i == 8:
            comment = " // Rank 6 - Evolution A"
        elif i == 9:
            comment = " // Rank 6 - Evolution B"
        else:
            comment = ""
        
        lines.append(f'\t\t\t{{Rank: {i}, Description: "{description_go}"}},{comment}')
    
    return '\n'.join(lines)


def update_powers_go(go_path: Path, mapping: Dict[str, str], ts_powers: Dict[str, dict], 
                     output_path: Optional[Path] = None, dry_run: bool = False):
    """
    Update powers.go with new descriptions from TS powers.
    
    Args:
        go_path: Path to powers.go
        mapping: Dict mapping Go power IDs to TS power IDs
        ts_powers: Dict of parsed TS power definitions
        output_path: Optional output path (defaults to overwriting go_path)
        dry_run: If True, only show what would change without modifying files
    """
    with open(go_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # For each Go power in the mapping, find and replace its RankDescs
    updates_made = 0
    powers_not_found = []
    
    for go_power_id, ts_power_id in sorted(mapping.items()):
        if ts_power_id not in ts_powers:
            powers_not_found.append(f"{go_power_id} -> {ts_power_id}")
            continue
        
        ts_power = ts_powers[ts_power_id]
        
        if len(ts_power['evolutions']) != 9:
            print(f"Warning: Skipping {go_power_id} - has {len(ts_power['evolutions'])} evolutions")
            continue
        
        # Generate the new RankDescs
        new_rank_descs = generate_rank_descs_go(ts_power['evolutions'])
        
        # Find the power definition in the Go file        
        # Match from ID through RankDescs array closing with proper indentation
        # The RankDescs array closes with:\n\t\t}, (two tabs before closing brace)
        pattern = rf'(ID: "{re.escape(go_power_id)}"[^{{]+RankDescs: \[\]RankDesc\{{)(.*?)(\n\t\t\}},)'
        
        match = re.search(pattern, content, re.DOTALL)
        if match:
            # Replace the RankDescs content
            old_rank_descs = match.group(2)
            replacement = f'{match.group(1)}\n{new_rank_descs}{match.group(3)}'
            content = content[:match.start()] + replacement + content[match.end():]
            updates_made += 1
            print(f"[OK] Updated {go_power_id} -> {ts_power_id}")
            
            if dry_run:
                # Show a sample of the change
                print(f"  Sample: {ts_power['evolutions'][0]['name']}")
                first_desc = fill_template(ts_power['evolutions'][0]['description'], 
                                          ts_power['evolutions'][0]['attributes'])
                print(f"  Desc:   {first_desc[:80]}...")
        else:
            print(f"[ERR] Could not find {go_power_id} in powers.go")
    
    # Write the updated content unless dry run
    if not dry_run:
        output_file = output_path or go_path
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"\nOutput written to: {output_file}")
    else:
        print(f"\n{'='*60}")
        print("DRY RUN - No files were modified")
        print(f"{'='*60}")
    
    print(f"\n{'='*60}")
    print(f"Summary:")
    print(f"  Total mappings: {len(mapping)}")
    print(f"  Updates made: {updates_made}")
    print(f"  TS powers not found: {len(powers_not_found)}")
    if powers_not_found:
        print(f"  Missing TS powers: {', '.join(powers_not_found[:5])}")
        if len(powers_not_found) > 5:
            print(f"    ... and {len(powers_not_found) - 5} more")
    print(f"{'='*60}")


def main():
    """Main entry point."""
    import sys
    
    # Check for --dry-run flag
    dry_run = '--dry-run' in sys.argv or '-n' in sys.argv
    
    # Define paths relative to script location
    script_dir = Path(__file__).parent
    root_dir = script_dir.parent
    
    csv_path = root_dir / "SFS_Core_ASI" / "01_sheets" / "character_power_match.csv"
    ts_path = root_dir / "Dashboard" / "src" / "lib" / "data" / "powers.ts"
    go_path = root_dir / "SFS_Core_ASI" / "SFSWebserver" / "model" / "powers.go"
    
    # Optional: create a backup or output to a different file
    # output_path = go_path.with_suffix('.go.new')
    output_path = None  # Overwrite the original
    
    # Verify files exist
    for path, name in [(csv_path, "CSV"), (ts_path, "TS"), (go_path, "Go")]:
        if not path.exists():
            print(f"Error: {name} file not found at {path}")
            return
    
    if dry_run:
        print("=== DRY RUN MODE - No files will be modified ===\n")
    
    print("Starting power description update...")
    print(f"CSV: {csv_path}")
    print(f"TS:  {ts_path}")
    print(f"Go:  {go_path}")
    print()
    
    # Step 1: Build mapping
    mapping = build_power_mapping(csv_path)
    
    # Step 2: Parse TS powers
    ts_powers = parse_powers_ts(ts_path)
    
    # Step 3: Update Go file
    update_powers_go(go_path, mapping, ts_powers, output_path, dry_run)
    
    if not dry_run:
        print("\nDone!")
    else:
        print("\nDone! Run without --dry-run to apply changes.")


if __name__ == '__main__':
    main()
