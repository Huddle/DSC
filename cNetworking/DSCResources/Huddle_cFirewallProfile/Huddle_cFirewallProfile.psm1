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
		Enabled = Convert-GpoBooleanToBool((Get-NetFirewallProfile -Name $Name).Enabled)
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
		[bool] $Enabled
	)

	Set-NetFirewallProfile -Name $Name -Enabled (Convert-BoolToGpoBoolean $Enabled)
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
		[bool] $Enabled
	)

	return (Get-NetFirewallProfile -Name $Name).Enabled -EQ (Convert-BoolToGpoBoolean $Enabled)
}

function Convert-BoolToGpoBoolean
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[bool] $Bool
	)

	if ($Bool) {
		return [Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.GpoBoolean]::True
	} else {
		return [Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.GpoBoolean]::False
	}
}

function Convert-GpoBooleanToBool
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.GpoBoolean] $GpoBoolean
	)

	return $GpoBoolean -EQ [Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.GpoBoolean]::True
}

Export-ModuleMember -Function *-TargetResource
