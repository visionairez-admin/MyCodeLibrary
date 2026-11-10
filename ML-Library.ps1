# Python ML Lab Code Library - PowerShell launcher
# Git is not required. This script reads files directly from GitHub.

$ErrorActionPreference = "Stop"
$owner = "visionairez-admin"
$repo = "MyCodeLibrary"
$branch = "main"
$apiRoot = "https://api.github.com/repos/$owner/$repo"
$rawRoot = "https://raw.githubusercontent.com/$owner/$repo/$branch"

function Get-RepositoryPythonFiles {
    $headers = @{
        "Accept" = "application/vnd.github+json"
        "User-Agent" = "ML-Lab-Code-Library"
    }
    $tree = Invoke-RestMethod -Uri "$apiRoot/git/trees/$branch?recursive=1" -Headers $headers
    @($tree.tree | Where-Object {
        $_.type -eq "blob" -and $_.path -match '^Week[^/]*\/.*\.py$'
    } | Sort-Object path)
}

function Show-WeekMenu {
    param([array]$Files)

    $weeks = @($Files | ForEach-Object { ($_.path -split '/')[0] } | Sort-Object -Unique)
    if ($weeks.Count -eq 0) {
        Write-Host "No Python programs have been added yet." -ForegroundColor Yellow
        Write-Host "Add .py files under folders named Week-01, Week-02, etc."
        return
    }

    while ($true) {
        Clear-Host
        Write-Host "======================================" -ForegroundColor Cyan
        Write-Host "     PYTHON ML LAB CODE LIBRARY" -ForegroundColor Cyan
        Write-Host "======================================" -ForegroundColor Cyan
        for ($i = 0; $i -lt $weeks.Count; $i++) {
            Write-Host ("{0}. {1}" -f ($i + 1), $weeks[$i])
        }
        Write-Host "0. Exit"
        $choice = Read-Host "Choose a week"
        if ($choice -eq "0") { return }
        $weekNumber = 0
        if (-not [int]::TryParse($choice, [ref]$weekNumber) -or $weekNumber -lt 1 -or $weekNumber -gt $weeks.Count) {
            Write-Host "Invalid choice." -ForegroundColor Red
            Start-Sleep -Seconds 1
            continue
        }

        $selectedWeek = $weeks[$weekNumber - 1]
        $programs = @($Files | Where-Object { $_.path -like "$selectedWeek/*" })
        while ($true) {
            Clear-Host
            Write-Host "$selectedWeek - PROGRAMS" -ForegroundColor Cyan
            for ($j = 0; $j -lt $programs.Count; $j++) {
                $name = [System.IO.Path]::GetFileNameWithoutExtension($programs[$j].path)
                Write-Host ("{0}. {1}" -f ($j + 1), $name)
            }
            Write-Host "0. Back"
            $programChoice = Read-Host "Choose a program"
            if ($programChoice -eq "0") { break }
            $programNumber = 0
            if (-not [int]::TryParse($programChoice, [ref]$programNumber) -or $programNumber -lt 1 -or $programNumber -gt $programs.Count) {
                Write-Host "Invalid choice." -ForegroundColor Red
                Start-Sleep -Seconds 1
                continue
            }

            $path = $programs[$programNumber - 1].path
            $encodedPath = ($path -split '/' | ForEach-Object { [uri]::EscapeDataString($_) }) -join '/'
            try {
                $source = Invoke-RestMethod -Uri "$rawRoot/$encodedPath"
                Clear-Host
                Write-Host "SOURCE: $path" -ForegroundColor Cyan
                Write-Host "--------------------------------------"
                Write-Output $source
                Write-Host "--------------------------------------"
                [void](Read-Host "Press Enter to return")
            }
            catch {
                Write-Host "Could not download this program: $($_.Exception.Message)" -ForegroundColor Red
                [void](Read-Host "Press Enter to return")
            }
        }
    }
}

try {
    Write-Host "Connecting to GitHub..." -ForegroundColor Cyan
    $files = Get-RepositoryPythonFiles
    Show-WeekMenu -Files $files
}
catch {
    Write-Host "Unable to load the library. Check your internet connection and try again." -ForegroundColor Red
    Write-Host $_.Exception.Message
}
