Set-Location Plugins
Get-ChildItem -Path . -Recurse -File | Resolve-Path -Relative | ForEach-Object {
    $targetPath = "../sig/Plugins/${_}s"
    Write-Output "Processing file: ${_}"
    if (-NOT (Test-Path $targetPath)) {
        $directory = Split-Path -Parent $targetPath
        New-Item -ItemType Directory -Force -Path $directory
        rbs prototype rb "$_" >> "$targetPath"
    }
}
Set-Location ..