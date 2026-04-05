import os
import re
import xml.etree.ElementTree as ET

root_dir = r"g:\Mods\Mass Effect 3 Mods\Vanilla Dump\Coalesced"
agg_path = os.path.join(root_dir, 'dynamicloadmapping_agg.xml')

patterns = {
    'Player_Archetypes': re.compile(r'\.Archetypes\.'),
    'Weapons': re.compile(r'SFXWeapon_'),
    'Weapon_Mods': re.compile(r'\.SFXWeaponMod_'),
    # include both normal and MP variant power custom actions
    'Powers': re.compile(r'SFXPowerCustomAction(?:MP)?_'),
}

# data buckets
buckets = {key: [] for key in patterns.keys()}
other = []

if not os.path.isfile(agg_path):
    raise FileNotFoundError(f"Aggregate file not found: {agg_path}")

# parse with ElementTree. if invalid XML due no root wrapper, do manual read.
xml_text = open(agg_path, 'r', encoding='utf-8').read()

# try parsing as root property; if fails then wrap.
try:
    root = ET.fromstring(xml_text)
except ET.ParseError:
    xml_text_wrapped = f'<root>\n{xml_text}\n</root>'
    root = ET.fromstring(xml_text_wrapped)

values = root.findall('.//Value')
print(f"Found {len(values)} Value entries in {agg_path}")

for val in values:
    text = (val.text or '').strip()
    if not text:
        continue

    assigned = False
    for key, pat in patterns.items():
        if pat.search(text):
            buckets[key].append(text)
            assigned = True
            break

    if not assigned:
        other.append(text)

# output files
for key, items in buckets.items():
    out_file = os.path.join(root_dir, f'{key}.xml')
    with open(out_file, 'w', encoding='utf-8') as f:
        f.write('<Property name="dynamicloadmapping">\n')
        for item in items:
            f.write(f'    <Value type="2">{item}</Value>\n')
        f.write('</Property>\n')
    print(f"Wrote {len(items)} entries to {out_file}")

other_out = os.path.join(root_dir, 'Other.xml')
with open(other_out, 'w', encoding='utf-8') as f:
    f.write('<Property name="dynamicloadmapping">\n')
    for item in other:
        f.write(f'    <Value type="2">{item}</Value>\n')
    f.write('</Property>\n')
print(f"Wrote {len(other)} entries to {other_out}")
