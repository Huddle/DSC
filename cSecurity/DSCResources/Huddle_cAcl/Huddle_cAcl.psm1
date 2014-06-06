function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String] $Path,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[System.Security.Principal.IdentityReference] $Principal
	)

	if (Test-Path $Path) {
		$Acl = Get-Acl $Path

		return @{
			Path = $Path;
			Principal = $Principal;
			FileSystemRights = ($Acl.Access | ? IdentityReference -EQ $Principal).FileSystemRights
		}
	} else {
		Write-Error "Path $Path not found."
	}
}

function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String] $Path,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[System.Security.Principal.IdentityReference] $Principal,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[System.Security.AccessControl.FileSystemAccessRule] $FileSystemRights
	)

	if (Test-Path $Path) {
		$Acl = Get-Acl $Path

		$Acl.SetAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($Principal, $FileSystemRights, "ContainerInherit, ObjectInherit", "None", "Allow")))

		Set-Acl $Path $Acl
	} else {
		Write-Error "Path $Path not found."
	}
}

function Test-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String] $Path,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[System.Security.Principal.IdentityReference] $Principal,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[System.Security.AccessControl.FileSystemAccessRule] $FileSystemRights
	)

	if (Test-Path $Path) {
		$Acl = Get-Acl $Path
		$Access = $Acl.Access | ? IdentityReference -EQ $Principal

		return $Access.FileSystemRights -EQ $FileSystemRights -And $Access.InheritanceFlags -EQ "ContainerInherit, ObjectInherit"
	} else {
		Write-Error "Path $Path not found."
	}
}

Export-ModuleMember -Function *-TargetResource
