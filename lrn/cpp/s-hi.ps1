Function f {
    # Clear-Host
    echo "🐸 🐸"
    # cmake -S hi -B build-hi
    cmake --build build-hi --config Debug
}

# Unlisten all events (important)
Get-EventSubscriber -Force | Unregister-Event -Force

## A file watcher, we check whether a file should be run by checking the access
## time of a temp file. We leave 3s buffer-time so that we don't run our scripts
## too often. The event listener itself dosen't run anything concrete, it just
## update the temp file.

$tmp = New-TemporaryFile
# a file info object, this object will not update itself as you modify the file.

Function watch {
    $fd = "C:\Users\congj\repo\hi"
    # filter
    $ft = "*.*"
    $w = New-Object System.IO.FileSystemWatcher $fd,$ft -Property @{
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }
    Write-Host "🐸 Registering event"
    Register-ObjectEvent $w -EventName Changed -Action {
        # # unwatch
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        $logline = "$(Get-Date), $changeType, $path"
        echo $logline > $tmp    #Update the tmp file
        Write-Host $logline
    }
}

watch
$lastRunTime = (Get-ChildItem $tmp).LastWriteTime
while ($true){
    $t2 = (Get-ChildItem $tmp).LastWriteTime
    if ($lastRunTime.AddSeconds(3) -lt $t2){
        Write-Host "⚙️ Update: was $lastRunTime, now $t2"
        # older than 2s
        f
        $lastRunTime= $t2
    }
    # sleep 2
}
