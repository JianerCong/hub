$d=$(Get-Date -UFormat "周报%Y-%m-%d.pdf")

Remove-Item -Path *.pdf
xelatex mwin
xelatex mwin 1> $null           #stdout to devnull
Write-Host 'Renaming to ' $d
Copy-Item -Path mwin.pdf -Destination $d
Remove-Item -Path *.aux,*.log,*.out
Write-Host 'Done'
