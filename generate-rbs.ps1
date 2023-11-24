Get-ChildItem -Path Data/Scripts -Recurse -File -Filter *.rb | Resolve-Path -Relative | ForEach-Object {
    $targetPath = "sig/${_}s"
    Write-Output "Processing file: ${_}"
    if (-NOT (Test-Path $targetPath)) {
        $directory = Split-Path -Parent $targetPath
        New-Item -ItemType Directory -Force -Path $directory
        rbs prototype rb "$_" >> "$targetPath"
        #typeprof $_ --show-errors #>> $targetPath
        #echo "$_ => $targetPath"
    }
}