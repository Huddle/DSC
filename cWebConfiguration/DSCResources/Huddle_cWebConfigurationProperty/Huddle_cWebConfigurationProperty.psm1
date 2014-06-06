function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Filter,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name
	)

	$Value = Get-WebConfigurationPropertyInternal -Filter $Filter -Name $Name

	return @{
		Filter = $Filter;
		Name = $Name;
		Value = $Value
		Type = $Value.GetType()
	}
}

function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Filter,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[PSObject] $Value,

		[ValidateSet("bool","int","string")]
		[PSObject] $Type = "string"
	)

	$ValueWithCorrectType = Cast-ToCorrectType -Value $Value -Type $Type

	Set-WebConfigurationProperty -Filter $Filter -Name $Name -Value $ValueWithCorrectType
}

function Test-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Filter,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Value,

		[ValidateSet("bool","int","string")]
		[PSObject] $Type = "string"
	)

	$CurrentValue = Get-WebConfigurationPropertyInternal -Filter $Filter -Name $Name
	$ValueWithCorrectType = Cast-ToCorrectType -Value $Value -Type $Type

	return $CurrentValue -EQ $ValueWithCorrectType
}

function Get-WebConfigurationPropertyInternal {
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Filter,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Name
	)

	$Property = Get-WebConfigurationProperty -Filter $Filter -Name $Name

	if ($Property | Get-Member | ? Name -EQ "Value") {
		return $Property.Value
	} else {
		return $Property
	}
}

function Cast-ToCorrectType {
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Value,

		[Parameter(Mandatory)]
		[ValidateSet("bool","int","string")]
		[string] $Type
	)

	switch ($Type) { 
		"bool" { return [bool] $Value }
		"int" { return [int] $Value }
		"string" { return $Value }
	}
}

Export-ModuleMember -Function *-TargetResource
