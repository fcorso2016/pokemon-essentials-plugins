Set-Location Data/Scripts
Get-ChildItem -Path . -Recurse -File | Resolve-Path -Relative | ForEach-Object {
    $targetPath = "../../sig/Data/Scripts/${_}s"
    Write-Output "Processing file: ${_}"
    if (-NOT (Test-Path $targetPath)) {
        $directory = Split-Path -Parent $targetPath
        New-Item -ItemType Directory -Force -Path $directory
        #rbs prototype rbi "$_" >> "$targetPath"
        typeprof "$targetPath" "$_" -I . >> "$targetPath"
    }
}
Set-Location ../..