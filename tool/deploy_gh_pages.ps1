# Builds the Flutter web app and publishes build/web to the `gh-pages`
# branch of a GitHub repository. Once Pages is set to serve that branch,
# the site is available at https://<user>.github.io/<repo>/
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File tool\deploy_gh_pages.ps1 `
#       -RepoUrl https://github.com/<user>/mt-alchemy-website.git
#
# Re-run this script any time you want to update the live site.

param(
    [Parameter(Mandatory = $true)][string]$RepoUrl,
    [string]$BaseHref = "/mt-alchemy-website/"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$web = Join-Path $root "build\web"

Write-Host "==> Building web release (base href $BaseHref)" -ForegroundColor Cyan
Push-Location $root
flutter build web --release --base-href $BaseHref

# GitHub Pages needs .nojekyll (so it does not run Jekyll) and a 404.html
# that mirrors index.html so deep links work when refreshed.
New-Item -ItemType File -Path (Join-Path $web ".nojekyll") -Force | Out-Null
Copy-Item (Join-Path $web "index.html") (Join-Path $web "404.html") -Force

Write-Host "==> Publishing build/web to gh-pages" -ForegroundColor Cyan
$tmp = Join-Path $env:TEMP ("ghpages_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmp | Out-Null
robocopy $web $tmp /E /NFL /NDL /NJH /NJS /NP | Out-Null

Push-Location $tmp
git init -b gh-pages | Out-Null
git add -A
git commit -m "Deploy MT Alchemy web build" | Out-Null
git remote add origin $RepoUrl
git push -f origin gh-pages
Pop-Location

Remove-Item $tmp -Recurse -Force
Pop-Location
Write-Host "==> Done. https://<user>.github.io/<repo>/" -ForegroundColor Green
