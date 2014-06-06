function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Source
	)

	if (Test-TargetResource -Name $Name -Source $Source) {
		return @{
			Name = $Name;
			Source = $Source
		}
	} else {
		return $False
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
		[string] $Source
	)

	New-EventLog -LogName $Name -Source $Source
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
		[string] $Source
	)

	return [bool](Get-EventLog -List | ? Log -EQ $Name) -And [System.Diagnostics.EventLog]::SourceExists($Source)
}

Export-ModuleMember -Function *-TargetResource
