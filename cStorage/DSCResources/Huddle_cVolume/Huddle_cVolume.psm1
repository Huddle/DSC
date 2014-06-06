function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter
	)

	$Volume = Get-Volume -DriveLetter $DriveLetter -ErrorAction SilentlyContinue

	if ($Volume) {
		return @{
			DriveLetter = $DriveLetter;
			FileSystemLabel = $Volume.FileSystemLabel
		}
	} else {
		Write-Error "Volume not found."
	}
}

function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[String] $FileSystemLabel
	)

	if (Get-Volume -DriveLetter $DriveLetter -ErrorAction SilentlyContinue) {
		Set-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $FileSystemLabel
	} else {
		Write-Error "Volume not found."
	}
}

function Test-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[String] $FileSystemLabel
	)

	$Volume = Get-Volume -DriveLetter $DriveLetter -ErrorAction SilentlyContinue

	if ($Volume) {
		return $Volume.FileSystemLabel -EQ $FileSystemLabel
	} else {
		Write-Error "Volume not found."
		return $False
	}
}

Export-ModuleMember -Function *-TargetResource
