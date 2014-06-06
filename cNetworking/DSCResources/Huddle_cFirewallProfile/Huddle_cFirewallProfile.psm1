function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateSet("Domain","Public","Private")]
		[String] $Name
	)

	return @{
		Name = $Name;
		Enabled = (Get-NetFirewallProfile -Name $Name).Enabled
	}
}

function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateSet("Domain","Public","Private")]
		[String] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.GpoBoolean] $Enabled
	)

	Set-NetFirewallProfile -Name $Name -Enabled $Enabled
}

function Test-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateSet("Domain","Public","Private")]
		[String] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.GpoBoolean] $Enabled
	)

	return (Get-NetFirewallProfile -Name $Name).Enabled -EQ $Enabled
}

Export-ModuleMember -Function *-TargetResource
