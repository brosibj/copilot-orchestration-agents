param(
    [Parameter(Mandatory = $true)]
    [string]$Version
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$distDir = Join-Path $repoRoot 'dist'
$suitesRoot = Join-Path $repoRoot 'suites'
$skillsRoot = Join-Path $repoRoot 'skills'

Add-Type -AssemblyName System.IO.Compression.FileSystem

function New-CleanDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        Remove-Item $Path -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function New-ZipFromDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceDirectory,

        [Parameter(Mandatory = $true)]
        [string]$DestinationZip
    )

    if (Test-Path $DestinationZip) {
        Remove-Item $DestinationZip -Force
    }

    [System.IO.Compression.ZipFile]::CreateFromDirectory($SourceDirectory, $DestinationZip)
}

function New-SuiteBundle {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SuiteName
    )

    $suiteDir = Join-Path $suitesRoot $SuiteName
    $bundleDir = Join-Path $distDir $SuiteName
    $bundleGithubDir = Join-Path $bundleDir '.github'

    New-CleanDirectory -Path $bundleDir
    New-Item -ItemType Directory -Path $bundleGithubDir -Force | Out-Null

    Copy-Item (Join-Path $suitesRoot 'copilot-instructions.md') (Join-Path $bundleGithubDir 'copilot-instructions.md') -Force

    foreach ($directoryName in 'agents', 'prompts', 'skills', 'instructions') {
        $sourceDirectory = Join-Path $suiteDir $directoryName
        if (Test-Path $sourceDirectory) {
            Copy-Item $sourceDirectory $bundleGithubDir -Recurse -Force
        }
    }

    New-ZipFromDirectory -SourceDirectory $bundleDir -DestinationZip (Join-Path $distDir "copilot-suite-$SuiteName-$Version.zip")
}

function New-SkillsBundle {
    if (-not (Test-Path $skillsRoot)) {
        return
    }

    $hasSkillContent = Get-ChildItem -Path $skillsRoot -Force | Select-Object -First 1
    if (-not $hasSkillContent) {
        return
    }

    $bundleDir = Join-Path $distDir 'skills'
    $bundleGithubDir = Join-Path $bundleDir '.github'

    New-CleanDirectory -Path $bundleDir
    New-Item -ItemType Directory -Path $bundleGithubDir -Force | Out-Null
    Copy-Item $skillsRoot $bundleGithubDir -Recurse -Force

    New-ZipFromDirectory -SourceDirectory $bundleDir -DestinationZip (Join-Path $distDir "copilot-skills-$Version.zip")
}

New-CleanDirectory -Path $distDir
New-SuiteBundle -SuiteName 'coding'
New-SuiteBundle -SuiteName 'project'
New-SkillsBundle