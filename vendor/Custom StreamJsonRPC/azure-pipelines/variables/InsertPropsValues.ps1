$BinPath = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\..\bin\Packages\$env:BUILDCONFIGURATION")

$dirsToSearch = "$BinPath\NuGet\*.nupkg" |? { Test-Path $_ }
$icv=@()

# Avoid updating the .props world for an optprof run.
# This avoids breaks in servicing branches when we insert a PublicRelease=false unstable package version.
if ($dirsToSearch -and !$env:OPTPROF) {
    Get-ChildItem -Path $dirsToSearch |% {
        if ($_.Name -match "^(.*)\.(\d+\.\d+\.\d+(?:-.*?)?)(?:\.symbols)?\.nupkg$") {
            $id = $Matches[1]
            $version = $Matches[2]
            $icv += "$id=$version"
        }
    }
}

Write-Output ([string]::join(',',$icv))
