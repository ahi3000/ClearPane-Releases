# ClearPane – Installationsskript (PowerShell, keine Admin-Rechte nötig). Bleibt für ältere Anleitungen erhalten;
# empfohlen ist das Setup aus dem README, weil Defender "irm … | iex" oft als Trojaner meldet (Fehlalarm).
# Lädt das neueste Setup von dieser Seite, prüft die SHA-256-Prüfsumme und installiert nach
# %LocalAppData%\Programs\ClearPane. Updates holt sich ClearPane danach selbst.

$ErrorActionPreference = "Stop"
$Repository = "ahi3000/ClearPane-Releases"
$Api = "https://api.github.com/repos/$Repository/releases/latest"
$Headers = @{ "User-Agent" = "ClearPane-Installer"; "Accept" = "application/vnd.github+json" }

Write-Host "ClearPane: suche die neueste Version ..." -ForegroundColor Cyan
# Older Windows PowerShell defaults to TLS 1.0, which GitHub refuses.
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
try {
    $release = Invoke-RestMethod -Uri $Api -Headers $Headers
}
catch {
    Write-Host "Noch keine Version veröffentlicht oder GitHub gerade nicht erreichbar." -ForegroundColor Yellow
    Write-Host "Download-Seite: https://github.com/$Repository/releases" -ForegroundColor Yellow
    return
}
$version = $release.tag_name.TrimStart("v")
$setupName = "ClearPane-$version-setup.exe"
$setup = $release.assets | Where-Object { $_.name -eq $setupName } | Select-Object -First 1
$checksum = $release.assets | Where-Object { $_.name -eq "$setupName.sha256" } | Select-Object -First 1
if (-not $setup -or -not $checksum) {
    throw "Im Release $($release.tag_name) fehlt das Setup oder die Prüfsumme."
}

$folder = Join-Path $env:TEMP "ClearPane-Install"
New-Item -ItemType Directory -Path $folder -Force | Out-Null
$target = Join-Path $folder $setupName
Write-Host "Lade ClearPane $version ($([math]::Round($setup.size / 1MB, 1)) MB) ..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $setup.browser_download_url -OutFile $target -Headers $Headers -UseBasicParsing
# GitHub serves .sha256 as binary – Windows PowerShell would hand back bytes, so read it as a text file instead.
$checksumFile = "$target.sha256"
Invoke-WebRequest -Uri $checksum.browser_download_url -OutFile $checksumFile -Headers $Headers -UseBasicParsing
$expected = ((Get-Content -Path $checksumFile -Raw) -split "\s+")[0].Trim().ToLowerInvariant()
Remove-Item $checksumFile -Force -ErrorAction SilentlyContinue
$actual = (Get-FileHash $target -Algorithm SHA256).Hash.ToLowerInvariant()
if ($expected -ne $actual) {
    Remove-Item $target -Force
    throw "Prüfsumme stimmt nicht – Download abgebrochen, nichts wurde installiert."
}

Write-Host "Prüfsumme stimmt. Installiere ..." -ForegroundColor Green
Start-Process -FilePath $target -ArgumentList "/SILENT" -Wait
Remove-Item $target -Force -ErrorAction SilentlyContinue
Write-Host "Fertig. ClearPane findest du im Startmenü." -ForegroundColor Green
