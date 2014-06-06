function Get-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[String] $Path
	)

	if (-Not (Test-Path $Path)) {
		throw "$Path not found."
	}

	$Thumbprint = (New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($Path)).Thumbprint

	if (Test-Path Cert:\LocalMachine\Root\$Thumbprint) {
		return @{
			Path = $Path;
			Ensure = "Present"
		}
	} else {
		return @{
			Path = $Path;
			Ensure = "Absent"
		}
	}
}

function Set-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[String] $Path,

		[ValidateSet("Present", "Absent")]
		[String] $Ensure = "Present"
	)

	if (-Not (Test-Path $Path)) {
		throw "$Path not found."
	}

	$Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($Path)

	$Store = Get-Item Cert:\LocalMachine\Root
	$Store.Open("ReadWrite")

	if ($Ensure -EQ "Present") {
		$Store.Add($Certificate)
	} else {
		$Store.Remove($Certificate)
	}

	$Store.Close()
}

function Test-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[String] $Path,

		[ValidateSet("Present", "Absent")]
		[String] $Ensure = "Present"
	)

	if (-Not (Test-Path $Path)) {
		throw "$Path not found."
	}

	$Thumbprint = (New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($Path)).Thumbprint

	if (Test-Path Cert:\LocalMachine\Root\$Thumbprint) {
		return $Ensure -EQ "Present"
	} else {
		return $Ensure -EQ "Absent"
	}
}

Export-ModuleMember -Function *-TargetResource
