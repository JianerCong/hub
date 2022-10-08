
function dev {
    $d = $(pwd)
      &{Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell 525826b1}
      cd $d
}

function dev2 {
    $d = $(pwd)
    &{"C:\Program Files (x86)\Microsoft Visual
Studio\2019\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll";Enter-VsDevShell b8e19729}
    cd $d
}

