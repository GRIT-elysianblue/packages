$serverlist = $args[0]

ForEach ($vhost in (Get-Content $serverlist )){
    Invoke-Command -FilePath "C:\Windows\System32\cmd.exe /c \"msiexec.exe /i \\VMXXBNTBTDC02\Deployment\follett-agent.msi /qn /quiet \"" -ComputerName $vhost -Credential $env:UserName
}