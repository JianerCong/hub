
function dev {
    $d = $(pwd)
    &{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell de0e628a;
      cd $d
     }
}
