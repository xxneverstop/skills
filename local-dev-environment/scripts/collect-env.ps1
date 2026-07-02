param(
    [string]$OutputPath = "",
    [switch]$Json
)

$ErrorActionPreference = "SilentlyContinue"

function ConvertTo-ArgString {
    param([string[]]$ArgList)

    (($ArgList | ForEach-Object {
        if ($_ -match '\s') { '"' + ($_ -replace '"', '\"') + '"' } else { $_ }
    }) -join " ")
}

function Invoke-VersionCommand {
    param([string]$ExePath, [string[]]$ArgList, [int]$TimeoutMs = 4000)

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $ExePath
    $psi.Arguments = ConvertTo-ArgString $ArgList
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()
    if (-not $proc.WaitForExit($TimeoutMs)) {
        try { $proc.Kill() } catch {}
        return "version command timed out"
    }

    $out = ($proc.StandardOutput.ReadToEnd() + " " + $proc.StandardError.ReadToEnd()).Trim()
    if ($out) {
        return (($out -split "`r?`n") | Select-Object -First 3) -join " "
    }
    return $null
}

function Get-CommandInfo {
    param([string]$Name, [string[]]$VersionArgs = @("--version"))

    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) {
        return [ordered]@{
            name = $Name
            found = $false
            path = $null
            version = $null
        }
    }

    $version = Invoke-VersionCommand $cmd.Source $VersionArgs

    [ordered]@{
        name = $Name
        found = $true
        path = $cmd.Source
        version = $version
    }
}

function Redact-EnvValue {
    param([string]$Name, [string]$Value)

    if ($Name -match "(TOKEN|SECRET|PASSWORD|PASS|KEY|CREDENTIAL|COOKIE|AUTH|PRIVATE)") {
        return "[REDACTED]"
    }
    if ($Value.Length -gt 240) {
        return $Value.Substring(0, 240) + "...[truncated]"
    }
    return $Value
}

function Get-ProjectHints {
    $files = @(
        ".python-version",
        ".node-version",
        ".nvmrc",
        "pyproject.toml",
        "requirements.txt",
        "package.json",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "Dockerfile",
        "docker-compose.yml",
        "compose.yml"
    )

    $hints = @()
    foreach ($file in $files) {
        $path = Join-Path (Get-Location) $file
        if (Test-Path -LiteralPath $path) {
            $hints += [ordered]@{
                file = $file
                path = (Resolve-Path -LiteralPath $path).Path
            }
        }
    }
    return $hints
}


function Get-CondaEnvironmentSummary {
    $roots = @(
        "D:\software\Anaconda3",
        (Join-Path $env:USERPROFILE "anaconda3"),
        (Join-Path $env:USERPROFILE "miniconda3")
    ) | Where-Object { $_ } | Select-Object -Unique

    $envs = @()
    foreach ($root in $roots) {
        if (-not (Test-Path -LiteralPath $root)) {
            continue
        }

        $basePython = Join-Path $root "python.exe"
        if (Test-Path -LiteralPath $basePython) {
            $envs += [ordered]@{
                name = "base"
                root = $root
                path = $root
                python = $basePython
                python_version = Invoke-VersionCommand $basePython @("--version")
                pip = Join-Path $root "Scripts\pip.exe"
                scripts = Join-Path $root "Scripts"
            }
        }

        $envRoot = Join-Path $root "envs"
        if (-not (Test-Path -LiteralPath $envRoot)) {
            continue
        }

        Get-ChildItem -LiteralPath $envRoot -Directory | Sort-Object Name | ForEach-Object {
            $python = Join-Path $_.FullName "python.exe"
            $pip = Join-Path $_.FullName "Scripts\pip.exe"
            $scripts = Join-Path $_.FullName "Scripts"
            $envs += [ordered]@{
                name = $_.Name
                root = $root
                path = $_.FullName
                python = if (Test-Path -LiteralPath $python) { $python } else { $null }
                python_version = if (Test-Path -LiteralPath $python) { Invoke-VersionCommand $python @("--version") } else { $null }
                pip = if (Test-Path -LiteralPath $pip) { $pip } else { $null }
                scripts = if (Test-Path -LiteralPath $scripts) { $scripts } else { $null }
            }
        }
    }

    return $envs
}
function Get-InstallRootSummary {
    $roots = @(
        @{ label = "manual_tools"; path = "D:\software" },
        @{ label = "applications"; path = "D:\application" }
    )

    $summaries = @()
    foreach ($root in $roots) {
        $exists = Test-Path -LiteralPath $root.path
        $children = @()
        if ($exists) {
            $children = @(Get-ChildItem -LiteralPath $root.path -Directory | Sort-Object Name | ForEach-Object {
                $child = $_
                $candidateDirs = @()
                foreach ($candidateName in @("bin", "Scripts", "cmd", "libexec")) {
                    $candidate = Join-Path $child.FullName $candidateName
                    if (Test-Path -LiteralPath $candidate) {
                        $candidateDirs += $candidate
                    }
                }

                [ordered]@{
                    name = $child.Name
                    path = $child.FullName
                    candidate_path_dirs = @($candidateDirs)
                }
            })
        }

        $summaries += [ordered]@{
            label = $root.label
            path = $root.path
            exists = $exists
            entries = $children
        }
    }
    return $summaries
}
$tools = @(
    @{ name = "python"; version_args = @("--version") },
    @{ name = "python3"; version_args = @("--version") },
    @{ name = "py"; version_args = @("--version") },
    @{ name = "pip"; version_args = @("--version") },
    @{ name = "pipx"; version_args = @("--version") },
    @{ name = "uv"; version_args = @("--version") },
    @{ name = "poetry"; version_args = @("--version") },
    @{ name = "conda"; version_args = @("--version") },
    @{ name = "java"; version_args = @("-version") },
    @{ name = "javac"; version_args = @("-version") },
    @{ name = "mvn"; version_args = @("--version") },
    @{ name = "gradle"; version_args = @("--version") },
    @{ name = "node"; version_args = @("--version") },
    @{ name = "npm"; version_args = @("--version") },
    @{ name = "pnpm"; version_args = @("--version") },
    @{ name = "yarn"; version_args = @("--version") },
    @{ name = "bun"; version_args = @("--version") },
    @{ name = "git"; version_args = @("--version") },
    @{ name = "gh"; version_args = @("--version") },
    @{ name = "docker"; version_args = @("--version") },
    @{ name = "kubectl"; version_args = @("version", "--client") },
    @{ name = "code"; version_args = @("--version") },
    @{ name = "cursor"; version_args = @("--version") },
    @{ name = "idea"; version_args = @("--version") }
)

$envVars = [ordered]@{}
Get-ChildItem Env: | Sort-Object Name | ForEach-Object {
    if ($_.Name -match "^(JAVA_HOME|M2_HOME|MAVEN_HOME|GRADLE_HOME|NODE_|NPM_|PNPM_|PYTHON|PYENV|CONDA|VIRTUAL_ENV|UV_|PATH|GIT_|HOME|USERPROFILE|SHELL|COMSPEC|CODEX|CLAUDE)") {
        $envVars[$_.Name] = Redact-EnvValue $_.Name $_.Value
    }
}

$report = [ordered]@{
    generated_at = (Get-Date).ToString("s")
    machine = [ordered]@{
        os = [System.Environment]::OSVersion.Platform.ToString()
        os_version = [System.Environment]::OSVersion.VersionString
        computer_name = $env:COMPUTERNAME
        user = $env:USERNAME
        home = $env:USERPROFILE
        current_directory = (Get-Location).Path
        powershell = $PSVersionTable.PSVersion.ToString()
    }
    tools = @($tools | ForEach-Object { Get-CommandInfo $_['name'] $_['version_args'] })
    path_entries = @($env:PATH -split ";" | Where-Object { $_ } | Select-Object -Unique)
    environment = $envVars
    project_hints = @(Get-ProjectHints)
    install_roots = @(Get-InstallRootSummary)
    conda_envs = @(Get-CondaEnvironmentSummary)
}

if ($Json) {
    $text = $report | ConvertTo-Json -Depth 6
} else {
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Local Development Environment")
    $lines.Add("")
    $lines.Add("Generated: $($report.generated_at)")
    $lines.Add("OS: $($report.machine.os) $($report.machine.os_version)")
    $lines.Add("User/Home: $($report.machine.user) / $($report.machine.home)")
    $lines.Add("Current directory: $($report.machine.current_directory)")
    $lines.Add("PowerShell: $($report.machine.powershell)")
    $lines.Add("")
    $lines.Add("## Tools")
    foreach ($tool in $report.tools) {
        if ($tool.found) {
            $lines.Add("- $($tool.name): $($tool.version) [$($tool.path)]")
        } else {
            $lines.Add("- $($tool.name): not detected")
        }
    }
    $lines.Add("")
    $lines.Add("## Project Hints")
    if ($report.project_hints.Count -eq 0) {
        $lines.Add("- none detected in current directory")
    } else {
        foreach ($hint in $report.project_hints) {
            $lines.Add("- $($hint.file): $($hint.path)")
        }
    }
    $lines.Add("")
    $lines.Add("")
    $lines.Add("")
    $lines.Add("## Conda Environments")
    if ($report.conda_envs.Count -eq 0) {
        $lines.Add("- none detected")
    } else {
        foreach ($env in $report.conda_envs) {
            $pythonText = if ($env.python_version) { " | $($env.python_version)" } else { "" }
            $lines.Add("- $($env.name): $($env.path)$pythonText")
            if ($env.python) { $lines.Add("  - python: $($env.python)") }
            if ($env.pip) { $lines.Add("  - pip: $($env.pip)") }
            if ($env.scripts) { $lines.Add("  - scripts: $($env.scripts)") }
        }
    }
    $lines.Add("")
    $lines.Add("## Local Install Roots")
    foreach ($root in $report.install_roots) {
        if (-not $root.exists) {
            $lines.Add("- $($root.label): $($root.path) not found")
            continue
        }
        $lines.Add("- $($root.label): $($root.path)")
        foreach ($entry in $root.entries) {
            $candidateText = ""
            if ($entry.candidate_path_dirs.Count -gt 0) {
                $candidateText = " | candidate PATH dirs: " + ($entry.candidate_path_dirs -join "; ")
            }
            $lines.Add("  - $($entry.name): $($entry.path)$candidateText")
        }
    }
    $lines.Add("")
    $lines.Add("## Environment")
    foreach ($key in $report.environment.Keys) {
        $lines.Add("- ${key}=$($report.environment[$key])")
    }
    $lines.Add("")
    $lines.Add("## PATH Entries")
    foreach ($entry in $report.path_entries) {
        $lines.Add("- $entry")
    }
    $text = $lines -join [Environment]::NewLine
}

if ($OutputPath) {
    $text | Set-Content -LiteralPath $OutputPath -Encoding UTF8
    Write-Host "Wrote $OutputPath"
} else {
    $text
}









