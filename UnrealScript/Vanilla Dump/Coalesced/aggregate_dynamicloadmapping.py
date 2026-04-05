import os
import xml.etree.ElementTree as ET

root_dir = r"g:\Mods\Mass Effect 3 Mods\Vanilla Dump\Coalesced"

agg = []
seen = set()
duplicates = []

for dirpath, dirnames, filenames in os.walk(root_dir):
    for fname in filenames:
        if fname.lower() == "bioengine.xml":
            path = os.path.join(dirpath, fname)
            try:
                tree = ET.parse(path)
                root = tree.getroot()
            except Exception as e:
                print(f"Unable to parse {path}: {e}")
                continue

            # Find all Property elements named dynamicloadmapping
            for prop in root.findall('.//Property[@name="dynamicloadmapping"]'):
                for val in prop.findall('Value'):
                    text = val.text.strip() if val.text is not None else ''
                    if not text:
                        continue
                    if text in seen:
                        duplicates.append((text, path))
                    else:
                        seen.add(text)
                        agg.append(text)

print(f"Found {len(agg)} unique dynamicloadmapping entries")
print(f"Found {len(duplicates)} duplicate entries")
for item, path in duplicates:
    print(f"Duplicate: {item} in {path}")

out_path = os.path.join(root_dir, 'dynamicloadmapping_agg.xml')

with open(out_path, 'w', encoding='utf-8') as f:
    f.write('<Property name="dynamicloadmapping">\n')
    for item in agg:
        f.write(f'    <Value type="2">{item}</Value>\n')
    f.write('</Property>\n')

print(f"Aggregated file written: {out_path}")
