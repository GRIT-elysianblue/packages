foreach ($server in (Get-Content C:\Script\serverlist.txt)){
	try{
		$Session = New-PSSession -ComputerName $server 
		Copy-Item C:\Script\follett-agent.msi -Destination C:\follett-agent.msi -ToSession $Session
		Invoke-Command -Scriptblock {Invoke-Expression -Command 'cmd.exe /c msiexec /i C:\follett-agent.msi /qn /quiet'} -Session $Session
		Invoke-Command -Scriptblock {Invoke-Expression -Command 'Remove-Item C:\follett-agent.msi'} -Session $Session
		$Session | Remove-PSSession
	}catch{
		$server | Out-File C:\script\failed_installations.txt -Append
	}
}