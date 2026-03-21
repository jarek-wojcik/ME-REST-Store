"""
Audit: find all iconSet duplicates in powers.ts
and show which powers.go entries share the same Picture (iconSet).
"""
import re

with open('Dashboard/src/lib/data/powers.ts', encoding='utf-8') as f:
    ts = f.read()

with open('SFS_Core_ASI/SFSWebserver/model/powers.go', encoding='utf-8') as f:
    go = f.read()

# Parse powers.ts: extract each power block with its iconSet and internalName
# Each top-level key in POWERS looks like:  SFXPowerCustomAction_Foo: { iconSet:'...', internalName:'...', ... }
ts_powers = {}  # internalName -> iconSet
for m in re.finditer(r'(\w+):\s*\{[^}]*?iconSet:\s*[\'"](\w+)[\'"][^}]*?internalName:\s*[\'"](\w+)[\'"]', ts, re.DOTALL):
    key = m.group(1)
    icon = m.group(2)
    internal = m.group(3)
    ts_powers[internal] = {'key': key, 'iconSet': icon}

# Also try the reverse order (internalName before iconSet)
for m in re.finditer(r'(\w+):\s*\{[^}]*?internalName:\s*[\'"](\w+)[\'"][^}]*?iconSet:\s*[\'"](\w+)[\'"]', ts, re.DOTALL):
    key = m.group(1)
    internal = m.group(2)
    icon = m.group(3)
    if internal not in ts_powers:
        ts_powers[internal] = {'key': key, 'iconSet': icon}

print(f"Found {len(ts_powers)} powers in powers.ts")

# Build iconSet -> list of internalNames
icon_to_internals = {}
for internal, data in ts_powers.items():
    icon = data['iconSet']
    icon_to_internals.setdefault(icon, []).append(internal)

dups = {k: v for k, v in icon_to_internals.items() if len(v) > 1}
print(f"\nDuplicate iconSets ({len(dups)} icons shared by multiple powers):")
for icon, internals in sorted(dups.items()):
    print(f"  {icon}: {internals}")

# Parse powers.go: extract ID and Picture for each power
go_powers = {}
for m in re.finditer(r'ID:\s*"([^"]+)"[^}]*?Picture:\s*"([^"]+)"', go, re.DOTALL):
    pid = m.group(1)
    pic = m.group(2).replace('.webp', '')
    go_powers[pid] = pic

print(f"\n\nPowers in powers.go that match a duplicate iconSet:")
for pid, pic in sorted(go_powers.items()):
    if pic in dups:
        print(f"  {pid} -> iconSet '{pic}' (shared with: {dups[pic]})")
