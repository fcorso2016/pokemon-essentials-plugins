Get-ChildItem . *.rbs -Recurse | ForEach-Object {
    $MyRawString = Get-Content -Raw $_.FullName
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($_.FullName, $MyRawString, $Utf8NoBomEncoding)
}