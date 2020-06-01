' If WScript.Arguments.length = 0 Then
'    Set objShell = CreateObject("Shell.Application")
'    'Pass a bogus argument, say [ uac]
'    objShell.ShellExecute "wscript.exe", Chr(34) & _
'       WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
' Else
'    Add your code here
Set shell = CreateObject("WScript.Shell" ) 
Set wmi = GetObject ("winmgmts://./root/cimv2")

Sub CheckProcess(name)
    For Each p In wmi.ExecQuery("SELECT * FROM Win32_Process")
        If p.Name = name Then Exit Sub
    Next
    shell.Run "C:\Users\spersson\Documents\config2.xlaunch"
    ' shell.Run """C:\Program Files\VcXsrv\vcxsrv.exe"" :0.0 -wgl -multiwindow -ac"
End Sub

CheckProcess "vcxsrv.exe"

shell.Run "wsl ~ /home/spersson/termstart.sh", 0
' shell.Run "wsl ~ eval ""GTK_THEME=Arc:dark DISPLAY=$(route -n |grep 'UG' |awk '{print $2}'):0.0 terminator""", 0
' End If