"""
fill_power_descs.py

Reads powers.ts (PocketRelay Dashboard) and fills in the RankDesc descriptions
in powers.go, matching on iconSet (= Picture without .webp).

Rank → evolution index mapping:
  Rank 1 → evolutions[0]  (base description)
  Rank 2 → evolutions[1]  (rank 2 upgrade)
  Rank 3 → evolutions[2]  (rank 3 upgrade)
  Rank 4 → evolutions[3]  (rank 4 evo A)
  Rank 5 → evolutions[4]  (rank 4 evo B)
  Rank 6 → evolutions[5]  (rank 5 evo A)
  Rank 7 → evolutions[6]  (rank 5 evo B)
  Rank 8 → evolutions[7]  (rank 6 evo A)
  Rank 9 → evolutions[8]  (rank 6 evo B)

Attribute substitution:
  Each evolution has an `attributes` dict; descriptions contain {varName}
  placeholders.  The rule (matching what powers.ts replaceTemplates does after
  the dashboard formats the values):
    - If `{varName}%` appears in the template text, the stored value is a
      decimal fraction (0.25 = 25%) → multiply by 100 and round to int.
    - Otherwise the value is an absolute number → format as int if whole,
      else round to 2 dp.
"""
import re
import sys
import os

WORKSPACE = r'g:\Mods\Mass Effect 3 Mods\ASI\ME-REST-Store'
POWERS_TS = os.path.join(WORKSPACE, r'Dashboard\src\lib\data\powers.ts')
POWERS_GO = os.path.join(WORKSPACE, r'SFS_Core_ASI\SFSWebserver\model\powers.go')

# ---------------------------------------------------------------------------
# Parse powers.ts
# ---------------------------------------------------------------------------
ICONSET_PAT = re.compile(r'iconSet:\s*"([^"]+)"')
INTNAME_PAT = re.compile(r'internalName:\s*"([^"]+)"')
# evolution description (handles multi-line string syntax)
DESC_PAT    = re.compile(r'description:\s*\n?\s*"((?:[^"\\]|\\.)*)"')
# attributes block: attributes: { key: value, ... }
EVO_PAT     = re.compile(
    r'description:\s*\n?\s*"((?:[^"\\]|\\.)*)"'   # description text
    r'.*?'                                          # anything (non-greedy)
    r'attributes:\s*\{([^}]*)\}',                  # attributes block
    re.DOTALL
)
ATTR_VAL_PAT = re.compile(r'(\w+):\s*([-\d.]+)')


def format_attr(value: float, key: str, desc_template: str) -> str:
    """Format an attribute value for insertion into a description string.

    If the template contains `{key}%`, the value is a decimal fraction that
    the game UI shows as a percentage, so multiply by 100.
    """
    placeholder_pct = '{' + key + '}%'
    if placeholder_pct in desc_template:
        return str(int(round(value * 100)))
    if value == int(value):
        return str(int(value))
    return str(round(value, 2))


def substitute_attrs(desc: str, attrs: dict) -> str:
    """Replace all {varName} placeholders with their formatted attribute values."""
    def replace_var(m):
        key = m.group(1)
        if key not in attrs:
            return m.group(0)  # leave unresolvable vars as-is
        return format_attr(attrs[key], key, desc)
    return re.sub(r'\{([^}]+)\}', replace_var, desc)


def parse_powers_ts(path):
    """Returns dict: iconSet (case-sensitive) → list of resolved description strings."""
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    m = re.search(r'export const POWERS = createPowers\(\{', content)
    if not m:
        sys.exit('ERROR: could not find POWERS in powers.ts')
    powers_section = content[m.end():]

    # Split chunks by iconSet occurrence so that the evolutions block always
    # falls WITHIN the chunk, regardless of whether internalName precedes or
    # follows the evolutions array (5 powers in the file have internalName
    # before evolutions).
    icon_positions = [(mo.group(1), mo.start())
                      for mo in ICONSET_PAT.finditer(powers_section)]

    by_icon = {}

    for i, (icon, start) in enumerate(icon_positions):
        end = icon_positions[i + 1][1] if i + 1 < len(icon_positions) else len(powers_section)
        chunk = powers_section[start:end]

        # Extract (description, attributes) pairs for each evolution
        evolutions = []
        for evo_m in EVO_PAT.finditer(chunk):
            raw_desc  = evo_m.group(1)
            attrs_txt = evo_m.group(2)
            attrs = {k: float(v) for k, v in ATTR_VAL_PAT.findall(attrs_txt)}
            resolved = substitute_attrs(raw_desc, attrs)
            evolutions.append(resolved)

        if evolutions:
            by_icon.setdefault(icon, evolutions)

    return by_icon


# ---------------------------------------------------------------------------
# Update powers.go
# ---------------------------------------------------------------------------
IDPIC_PAT = re.compile(r'ID:\s*"([^"]+)".*Picture:\s*"([^"]+)"')
RANK_PAT  = re.compile(r'(\{Rank:\s*(\d+),\s*Description:\s*)"((?:[^"\\]|\\.)*)"(\})')


def get_descs(full_id: str, picture: str, by_icon: dict):
    """Find evolution descriptions for a Go power."""
    icon = picture.replace('.webp', '')
    if icon in by_icon:
        return by_icon[icon]

    # Fall back: strip the SFX prefix and try variant suffixes
    suffix = re.sub(r'^SFXPowerCustomAction(?:MP)?_', '', full_id)
    if suffix in by_icon:
        return by_icon[suffix]

    base = re.sub(
        r'(_N7|_Krogan|_Warlord|_Volus|_Base|_Prothean'
        r'|_Commando|_Vanguard|_Infiltrator|_Sentinel|_Adept|2|3)$',
        '', suffix
    )
    if base in by_icon:
        return by_icon[base]

    return None


def process_go(go_path: str, by_icon: dict):
    with open(go_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    current_descs = None
    matched = 0
    unmatched = []
    result = []

    for line in lines:
        idpic_m = IDPIC_PAT.search(line)
        if idpic_m:
            full_id = idpic_m.group(1)
            picture = idpic_m.group(2)
            current_descs = get_descs(full_id, picture, by_icon)
            if current_descs:
                matched += 1
            else:
                unmatched.append(f'{full_id} ({picture})')

        def replace_rank(m):
            prefix    = m.group(1)
            rank      = int(m.group(2))
            cur_desc  = m.group(3)
            suffix    = m.group(4)

            # Never overwrite an already-populated description
            if cur_desc != '' or current_descs is None:
                return m.group(0)

            evo_idx = rank - 1
            if evo_idx >= len(current_descs):
                return m.group(0)

            return f'{prefix}"{current_descs[evo_idx]}"{suffix}'

        line = RANK_PAT.sub(replace_rank, line)
        result.append(line)

    with open(go_path, 'w', encoding='utf-8', newline='\n') as f:
        f.writelines(result)

    print(f'Matched: {matched} powers')
    if unmatched:
        print(f'Unmatched ({len(unmatched)}):')
        for u in unmatched:
            print(f'  - {u}')


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    print('Parsing powers.ts ...')
    by_icon = parse_powers_ts(POWERS_TS)
    print(f'  {len(by_icon)} unique iconSets parsed')

    print('Updating powers.go ...')
    process_go(POWERS_GO, by_icon)
    print('Done.')


if __name__ == '__main__':
    main()
