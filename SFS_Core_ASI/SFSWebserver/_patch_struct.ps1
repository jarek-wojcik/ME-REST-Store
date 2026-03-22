$f = 'model\powers.go'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Find and replace the struct block
# The file has mojibake in comments but the struct fields themselves are ASCII
$oldStruct = @'
type PowerDef struct {
	ID        string
	RootPath  string
	Name      string
	Picture   string     // filename in /static/assets/powers/, e.g. "Warp.webp"
'@

# Find the start of the struct
$structStart = $c.IndexOf('type PowerDef struct {')
if ($structStart -lt 0) { Write-Host "ERROR: struct not found"; exit 1 }

# Find the closing brace for the struct (the next standalone "}")
$bracePos = $c.IndexOf('}', $structStart + 22)
$oldBlock = $c.Substring($structStart, $bracePos - $structStart + 1)
Write-Host "Found block:"
Write-Host $oldBlock
Write-Host "---"

# Also locate the IconURL func so we can replace struct + methods together
$iconFuncStart = $c.IndexOf('// IconURL returns the URL for the power')
$descFuncEnd = $c.IndexOf('`)', $iconFuncStart)  # end of DescForRank
if ($descFuncEnd -lt 0) {
    # try alternate - find the closing of DescForRank
    $descFuncEnd = $c.IndexOf("`n}", $iconFuncStart + 100) + 1
}
Write-Host "descFuncEnd: $descFuncEnd"

# Replacement: new struct with AmmoPowerSpriteDir + new methods
$rankDescComment = $oldBlock -replace '(?s)\s*RankDescs.*?$', ''
# Extract the comment line from original to preserve exact bytes
$rankLine = $c.Substring($c.IndexOf('	RankDescs []RankDesc'), 200)
$rankLineEnd = $rankLine.IndexOf("`n")
$rankLineExact = $rankLine.Substring(0, $rankLineEnd)
Write-Host "RankDesc line exact: [$rankLineExact]"

$newBlock = $oldBlock -replace '(\s*RankDescs \[\]RankDesc[^\n]*)', "`$1`n`tAmmoPowerSpriteDir string     // non-empty for ammo powers: path under /static/assets/powers/AmmoPowers/ containing 1.png-9.png"
$newBlock = $newBlock -replace 'ID        string', 'ID                 string'
$newBlock = $newBlock -replace 'RootPath  string', 'RootPath           string'
$newBlock = $newBlock -replace 'Name      string', 'Name               string'
$newBlock = $newBlock -replace 'Picture   string', 'Picture            string'
$newBlock = $newBlock -replace 'RankDescs \[\]RankDesc', 'RankDescs          []RankDesc'
Write-Host "New block:"
Write-Host $newBlock
Write-Host "---"

$c2 = $c.Replace($oldBlock, $newBlock)
if ($c2 -eq $c) { Write-Host "ERROR: no change made"; exit 1 }

# Now inject IsAmmoPower and AmmoPowerRankURL after IconURL()
$afterIconURL = $c2.IndexOf('func (p PowerDef) IconURL() string {')
$iconFuncEndPos = $c2.IndexOf("`n}", $afterIconURL) + 2
$newMethods = @"


// IsAmmoPower reports whether this power uses individual per-rank PNG sprites
// (under AmmoPowers/) instead of a shared sprite sheet.
func (p PowerDef) IsAmmoPower() bool {
	return p.AmmoPowerSpriteDir != ""
}

// AmmoPowerRankURL returns the URL for the rank-index PNG sprite (1-9).
// Only meaningful when IsAmmoPower() is true.
func (p PowerDef) AmmoPowerRankURL(rank int) string {
	return "/static/assets/powers/AmmoPowers/" + p.AmmoPowerSpriteDir + "/" + strconv.Itoa(rank) + ".png"
}
"@

$c3 = $c2.Substring(0, $iconFuncEndPos) + $newMethods + $c2.Substring($iconFuncEndPos)

[System.IO.File]::WriteAllText($f, $c3, [System.Text.Encoding]::UTF8)
Write-Host "SUCCESS"
