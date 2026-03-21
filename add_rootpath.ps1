$file = 'g:\Mods\Mass Effect 3 Mods\ASI\ME-REST-Store\SFS_Core_ASI\SFSWebserver\model\powers.go'
$lines = Get-Content $file
$out = [System.Collections.Generic.List[string]]::new()
foreach ($line in $lines) {
    $out.Add($line)
    if ($line -match '^\s+ID:\s') {
        $indent = [regex]::Match($line, '^\s+').Value
        $out.Add("${indent}RootPath:  `"`",")
    }
}
[System.IO.File]::WriteAllLines($file, $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "Done. Added RootPath after $($out.Where({ $_ -match 'RootPath:' }).Count) ID lines."
