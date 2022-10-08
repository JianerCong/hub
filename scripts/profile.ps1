set-strictmode -version 3
set-alias gh get-help
set-alias l Get-ChildItem

if ( "r" -in (alias).name) {remove-alias -name r}


# Where is the script file that contains the function dev which enters the
# developer shell

# $DEVFILE = (Get-ChildItem $PROFILE).DirectoryName + `
#   (Get-ChildItem $PROFILE).BaseName + "-dev.ps1"
# . $DEVFILE

$dayrmdpath = "C:\Users\congj\AppData\Roaming\Templates\scripts\dayrmd"
$dayrmdpy = Join-Path -Path $dayrmdpath -ChildPath "dayrmd.py"
$dayrmdmsg = Join-Path -Path $dayrmdpath -ChildPath "msg.txt"
python $dayrmdpy
$msg = Get-Content $dayrmdmsg -Raw

function Prompt {
    # $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    # $principal = [Security.Principal.WindowsPrincipal] $identity
    # $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    # $s = $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
    #   elseif($principal.IsInRole($adminRole)) { "[ADMIN]: " }
    #   else { "[$env:username]" }
    #  )
    # write-host "`n----------------------------"
    # write-host "Now it's " (date).tostring()
    if($msg) {write-host "$msg"}
    # write-host "$s AT [$env:COMPUTERNAME]  $(Get-Location)"
    "> "
}

function cppat {
    $script = 'C:\Users\congj\AppData\Roaming\Templates\scripts'
    $old_dir = $pwd
    cd $script
    $s = Get-Content 'pat1.txt', 'tap2.txt'
    $pat = ($s -split '\n')[0] + ($s -split '\n')[1]
    $pat | set-clipboard
    cd $old_dir
}
function cpdir {($pwd).tostring() | set-clipboard}

function got{
    write-host "Where to go ?"
    $h = @{
           "t"  = 'C:\Users\congj\AppData\Roaming\Templates\lrn\h5\weapp\todo'
           "l"  = 'C:\Users\congj\AppData\Roaming\Templates\lrn'
           "w"  = 'C:\Users\congj\AppData\Roaming\Templates\lrn\h5\weapp'
          }
    $h
    $x = read-host "enter your key"
    if ($x -in $h.keys){
        write-host "Address Found"
        cd $h[$x]
    }else{
        write-host " not found"
    }
}

# Get the files in a folder within some days.
function Get-TodayChildItem
{
    Param (
        $Path = '.',
        [PSDefaultValue(Help = '1')]
        $DaysWithin = 1
    )
    # Use space + backquote to change line
    Get-ChildItem $Path | Where-Object { `
      ((Get-Date) - ($_.LastWriteTime)).TotalDays `
      -LE $DaysWithin}
}
set-alias tls Get-TodayChildItem

Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar
Set-PSReadLineKeyHandler -Chord Alt+f -Function NextWord
Set-PSReadLineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar

Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory

Set-PSReadLineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Chord Alt+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Alt+e -Function EndOfLine

# Function for git
function g{
    param(
        [PSDefaultValue(Help = '100')]
        $Size = 5
    )
    git log --oneline --decorate --all -n $Size
}

# Function for pushing to git repositories
function gpsh{
    param(
        [PSDefaultValue(Help = 'MyBranch')]
        $BranchName = 'bch'
    )
    git push usb $BranchName
    git push hub $BranchName
}

function ga{
    git add -A
    git status
}

function Get-y {
    $a = Read-Host "Enter [y/n]: "
    $ok = ("y", "yes")
    $no = ("n", "no")
    while (! ($a -in ($ok + $no))){
        $a = Read-Host "Invalid choice, Enter [y/n]: "
    }
    if ($a -in $ok){
        return $True
    }else{
        return $False
    }
}

function ysql {
    mysqlsh --mysqlx --user root --host localhost --schema=sakila --sql --port 33060
}

# Function for syncronizing powershell profile
function pspf{
    # Push the profile
    param( [switch] $Push)
    $d="c:/Users/congj/AppData/Roaming/Templates/scripts/profile.ps1"

    $s1="C:\Users\congj\AppData\Roaming\.spacemacs"
    $s2="C:\Users\congj\AppData\Roaming\Templates\.emacs-config\.spacemacs-28-win"

    if ($Push) {
        Write-host "Pushing PROFILE and .spacemacs  to ~/Template. Are You Sure?"
        if (Get-y){
            Copy-Item $PROFILE -Destination $d
            Copy-Item $s1 `
              -Destination $s2
        }
    }else{
        Write-host "Updating PROFILE and .spacemacs from ~/Templates. Are You Sure "
        if (Get-y){
            Copy-Item $d -Destination $PROFILE
            Copy-Item $s2 `
              -Destination $s1
        }
    }
    Write-host "done"
}

function pyenv {
    . C:\Users\congj\myGlobalEnv\Scripts\Activate.ps1
}
