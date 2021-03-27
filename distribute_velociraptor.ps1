$vparams = New-Object string[] 2
$vparams[0] = "/c"
$vparams[1] = "msiexec.exe /i \\VMXXBNTBTDC02\Deployment\follett-agent.msi /qn /quiet "

ForEach ($vhost in (Get-Content .\serverlist.txt )){
    Invoke-Command -FilePath "C:\Windows\System32\cmd.exe" -ArgumentList $vparams -ComputerName $vhost -Credential $env:UserName
}