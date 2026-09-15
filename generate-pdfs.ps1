# Regenerate the downloadable CV PDFs using headless Chrome.
# Run:  .\generate-pdfs.ps1
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $chrome)) {
    $edge = "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe"
    if (Test-Path $edge) { $chrome = $edge } else { throw "Chrome or Edge not found." }
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$assets = Join-Path $root "assets"

$jobs = @(
    @{ Html = "pdf-english.html"; Pdf = "Shorna-Akter-CV-English.pdf" },
    @{ Html = "pdf-bangla.html";  Pdf = "Shorna-Akter-CV-Bangla.pdf" }
)

foreach ($job in $jobs) {
    $src  = [Uri]::new((Join-Path $root $job.Html)).AbsoluteUri
    $dest = Join-Path $assets $job.Pdf
    & $chrome --headless=new --disable-gpu --no-pdf-header-footer --print-to-pdf=$dest $src
    Write-Host "$(Get-Item $dest | Select-Object -ExpandProperty Length) bytes -> $dest"
}