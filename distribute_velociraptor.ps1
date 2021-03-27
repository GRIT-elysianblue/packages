
ForEach ($vhost in (Get-Content .\serverlist.txt )){
    Invoke-Command -ScriptBlock {Invoke-Expression -Command "msiexec.exe /i \\VMXXBNTBTDC02\Deployment\follett-agent.msi /qn /quiet" } -ComputerName $vhost -Credential $env:UserName
}