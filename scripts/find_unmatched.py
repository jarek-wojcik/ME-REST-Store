import re

path = r'g:\Mods\Mass Effect 3 Mods\ASI\ME-REST-Store\Dashboard\src\lib\data\powers.ts'
with open(path, 'r', encoding='utf-8') as f:
    c = f.read()

for term in ['SentryTurret', 'BioticOrbs', 'ElectricSlash', 'GethTurret', 'Lash']:
    found = False
    for m in re.finditer(r'iconSet:\s*"([^"]*' + term + r'[^"]*)"', c, re.IGNORECASE):
        print(f'{term}: iconSet={m.group(1)}')
        found = True
    for m in re.finditer(r'internalName:\s*"([^"]*' + term + r'[^"]*)"', c, re.IGNORECASE):
        print(f'{term}: internalName={m.group(1)}')
        found = True
    if not found:
        print(f'{term}: NOT FOUND in powers.ts')
