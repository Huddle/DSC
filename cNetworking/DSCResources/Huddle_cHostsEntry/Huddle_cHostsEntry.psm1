function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name
	)

	Get-Content C:\Windows\system32\drivers\etc\hosts | ? { $_ -Match "^\s*(?<Address>\d+\.\d+\.\d+\.\d+)\s+$Name(\s|#|$)" } | Out-Null

	return @{
		Name = $Name;
		Address = $Matches.Address
	}
}

function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Address
	)

	Add-Content C:\Windows\system32\drivers\etc\hosts "$Address $Name"
}

function Test-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Address
	)

	return [bool](Get-Content C:\Windows\system32\drivers\etc\hosts | ? { $_ -Match "^\s*$Address\s+$Name(\s|#|$)" })
}

Export-ModuleMember -Function *-TargetResource
