function comp_cs {
    param (
        [string] $nam
    )
    $src="$nam.cs"
    $out="$nam.exe"
    if (Test-Path $src){
        csc $src > log.txt
        if ($?){
            . ".\$out"
        }else{
            less log.txt
        }
    }else{
        Write-Host "File $src dosen't exist."
    }
}
