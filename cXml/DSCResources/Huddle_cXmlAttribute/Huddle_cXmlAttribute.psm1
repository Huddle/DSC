function Get-TargetResource {
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $XmlFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $NodeXPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $AttributeName
	)

	return @{
		XmlFilePath = $XmlFilePath;
		XPath = $XPath;
		Value = ([xml] (Get-Content $XmlFilePath)).SelectNodes("$NodeXPath/@$AttributeName").Value
	}
}

function Set-TargetResource {
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $XmlFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $NodeXPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $AttributeName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Value
	)

	$Xml = [xml] (Get-Content $XmlFilePath)

	$Xml.SelectNodes($NodeXPath).SetAttribute($AttributeName, $Value)

	$Xml.Save($XmlFilePath)
}

function Test-TargetResource {
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $XmlFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $NodeXPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $AttributeName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $Value
	)

	return ([xml] (Get-Content $XmlFilePath)).SelectNodes("$NodeXPath/@$AttributeName").Value -EQ $Value
}

Export-ModuleMember -Function *-TargetResource
