# Prüfe ob pandoc installiert ist
$pandocInstalled = Get-Command pandoc -ErrorAction SilentlyContinue

if (-not $pandocInstalled) {
    Write-Host "Pandoc ist nicht installiert. Installation wird gestartet..."
    # Installation mit winget versuchen
    try {
        winget install pandoc
    }
    catch {
        Write-Host "Fehler bei der Installation von Pandoc. Bitte installiere Pandoc manuell von https://pandoc.org/installing.html"
        exit 1
    }
}

# Parameter für Input und Output Dateien
param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFile
)

# Wenn kein Output-Dateiname angegeben wurde, verwende den Input-Namen mit .html
if (-not $OutputFile) {
    $OutputFile = [System.IO.Path]::ChangeExtension($InputFile, "html")
}

# Prüfe ob die Input-Datei existiert
if (-not (Test-Path $InputFile)) {
    Write-Host "Die Eingabedatei $InputFile wurde nicht gefunden."
    exit 1
}

try {
    # Konvertiere Markdown zu HTML mit einem einfachen CSS-Template
    $cssStyle = @"
<style>
body {
    max-width: 800px;
    margin: 40px auto;
    padding: 0 20px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    line-height: 1.6;
    color: #333;
}
code {
    background-color: #f5f5f5;
    padding: 2px 4px;
    border-radius: 4px;
}
pre {
    background-color: #f5f5f5;
    padding: 1em;
    border-radius: 4px;
    overflow-x: auto;
}
</style>
"@

    pandoc $InputFile -f markdown -t html -s --metadata title="Markdown Conversion" -H $cssStyle -o $OutputFile

    Write-Host "Konvertierung erfolgreich! Die HTML-Datei wurde unter $OutputFile gespeichert."
}
catch {
    Write-Host "Ein Fehler ist aufgetreten: $_"
    exit 1
}
