[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$pluginPath = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $pluginPath '.claude-plugin/plugin.json') -Raw | ConvertFrom-Json
if ($manifest.name -ne 'buyercaddy' -or $manifest.version -notmatch '^\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?$') {
    throw 'Expected the buyercaddy manifest and a semantic release version.'
}
$config = Get-Content -LiteralPath (Join-Path $pluginPath '.mcp.json') -Raw | ConvertFrom-Json
$server = $config.mcpServers.buyercaddy
$expectedUrl = 'https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp'
if (@($config.mcpServers.PSObject.Properties).Count -ne 1 -or
    $server.type -ne 'http' -or $server.url -ne $expectedUrl -or
    ($server.PSObject.Properties.Name | Where-Object { $_ -notin @('type', 'url') })) {
    throw 'Expected only the BuyerCaddy OAuth connector with no embedded credential configuration.'
}

$allowed = @('.claude-plugin', '.mcp.json', 'assets', 'skills', 'README.md', 'INSTALL.md', 'LICENSE')
$files = @(
    foreach ($name in $allowed) {
        $item = Get-Item -LiteralPath (Join-Path $pluginPath $name) -Force
        $items = @($item)
        if ($item.PSIsContainer) { $items += @(Get-ChildItem -LiteralPath $item.FullName -Recurse -Force) }
        if ($items | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }) {
            throw 'Plugin files must not be symbolic links or junctions.'
        }
        $items | Where-Object { -not $_.PSIsContainer }
    }
) | Sort-Object FullName
foreach ($file in $files) {
    if ($file.Extension -eq '.json') { $null = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json }
}

$outputDirectory = Join-Path $pluginPath 'dist'
$null = New-Item -ItemType Directory -Path $outputDirectory -Force
$archivePath = Join-Path $outputDirectory ('buyercaddy-claude-oauth-' + $manifest.version + '.zip')
$temporaryPath = Join-Path $outputDirectory ([Guid]::NewGuid().ToString('N') + '.tmp')
try {
    $zip = [IO.Compression.ZipFile]::Open($temporaryPath, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($file in $files) {
            $relative = $file.FullName.Substring($pluginPath.Length + 1).Replace('\', '/')
            $null = [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $relative, [IO.Compression.CompressionLevel]::Optimal)
        }
    } finally { $zip.Dispose() }
    $zip = [IO.Compression.ZipFile]::OpenRead($temporaryPath)
    try {
        foreach ($required in @('.claude-plugin/plugin.json', '.mcp.json', 'skills/research/SKILL.md', 'skills/credits/SKILL.md', 'INSTALL.md', 'LICENSE')) {
            if (-not $zip.GetEntry($required)) { throw "Missing required ZIP entry: $required" }
        }
    } finally { $zip.Dispose() }
    Move-Item -LiteralPath $temporaryPath -Destination $archivePath -Force
} finally {
    if (Test-Path -LiteralPath $temporaryPath) { Remove-Item -LiteralPath $temporaryPath }
}
Write-Output "Built $archivePath ($($files.Count) files)"
Write-Output ('SHA256: ' + (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash)
