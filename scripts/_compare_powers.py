import re

with open('SFS_Core_ASI/SFSWebserver/model/characters.go', 'r') as f:
    chars_content = f.read()

with open('SFS_Core_ASI/SFSWebserver/model/powers.go', 'r') as f:
    powers_content = f.read()

# All IDs referenced in PowerIDs arrays in characters.go
chars_power_ids = set(re.findall(r'"(SFX[A-Za-z0-9_.]+)"', chars_content))
# Filter to only power IDs (exclude character IDs, picture files etc.)
chars_power_ids = {p for p in chars_power_ids if 'Power' in p or 'Passive' in p or 'Melee' in p}

# All IDs defined in powers.go (ID: "..." fields in PowerDef structs)
powers_defined = set(re.findall(r'\bID:\s*"(SFX[A-Za-z0-9_.]+)"', powers_content))

print("=== Powers in characters.go NOT in powers.go (MISSING - need to add) ===")
missing = sorted(chars_power_ids - powers_defined)
for p in missing:
    print(f"  {p}")

print()
print("=== Powers in powers.go NOT in characters.go (EXTRA - need to remove) ===")
extra = sorted(powers_defined - chars_power_ids)
for p in extra:
    print(f"  {p}")

print()
print(f"Total in characters.go: {len(chars_power_ids)}")
print(f"Total defined in powers.go: {len(powers_defined)}")
print(f"Missing (to add): {len(missing)}")
print(f"Extra (to remove): {len(extra)}")
