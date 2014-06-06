function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $XmlFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $ParentNodeXPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $NodeName
	)

	if (Test-TargetResource -XmlFilePath $XmlFilePath -ParentNodeXPath $ParentNodeXPath -NodeName $NodeName) {
		return @{
			XmlFilePath = $XmlFilePath;
			ParentNodeXPath = $ParentNodeXPath;
			NodeName = $NodeName
		}
	}
}

function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $XmlFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $ParentNodeXPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $NodeName
	)

	$Xml = [xml] (Get-Content $XmlFilePath)

	$NewNode = $Xml.CreateElement($NodeName)
	$ParentNode = (Select-Xml -XPath $ParentNodeXPath -Xml $Xml).Node
	$ParentNode.AppendChild($NewNode)

	$Xml.Save($XmlFilePath)
}

function Test-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $XmlFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $ParentNodeXPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string] $NodeName
	)

	if (Test-Path $XmlFilePath) {
		if (Select-Xml -XPath "$ParentNodeXPath/$NodeName" -Xml ([xml](Get-Content $XmlFilePath))) {
			return $True
		}
	}

	return $False
}

Export-ModuleMember -Function *-TargetResource
