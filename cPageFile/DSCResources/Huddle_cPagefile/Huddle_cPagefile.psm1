function Get-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter
	)

	$PageFile = Get-CimInstance Win32_PageFileSetting | ? Name -EQ "$($DriveLetter):\pagefile.sys"

	if ($PageFile) {
		return @{
			DriveLetter = $DriveLetter;
			Ensure = "Present";
			InitialSize = $PageFile.InitialSize;
			MaximumSize = $PageFile.MaximumSize
		}
	} else {
		return @{
			DriveLetter = $DriveLetter;
			Ensure = "Absent"
		}
	}
}

function Set-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter,

		[ValidateSet("Present", "Absent")]
		[String] $Ensure = "Present",

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $InitialSize,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $MaximumSize
	)

	$PageFile = Get-CimInstance Win32_PageFileSetting | ? Name -EQ "$($DriveLetter):\pagefile.sys"

	if ($Ensure -EQ "Present") {
		if (-Not $PageFile) {
			$PageFile = New-CimInstance -CimClass (Get-CimClass Win32_PageFileSetting) -Property @{
				Name = "$($DriveLetter):\pagefile.sys";
				InitialSize = $InitialSize;
				MaximumSize = $MaximumSize
			}
		} else {
			$PageFile | Set-CimInstance -Property @{
				InitialSize = $InitialSize;
				MaximumSize = $MaximumSize
			}
		}
	} else {
		if ($PageFile) {
			$PageFile | Remove-CimInstance
			Write-Verbose "PageFile $($DriveLetter):\pagefile.sys removed successfully."
		}
	}

	Write-Warning "A reboot is required to complete PageFile configuration"
	$global:DSCMachineStatus = 1
}

function Test-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter,

		[ValidateSet("Present", "Absent")]
		[String] $Ensure = "Present",

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $InitialSize,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $MaximumSize
	)

	$Success = $True

	$PageFile = Get-CimInstance Win32_PageFileSetting | ? Name -EQ "$($DriveLetter):\pagefile.sys"

	if ($Ensure -EQ "Present") {
		if ($PageFile) {
			if ($PageFile.InitialSize -NE $InitialSize) {
				Write-Verbose "PageFile initial size is not $InitialSize"
				$Success = $False
			}

			if ($PageFile.MaximumSize -NE $MaximumSize) {
				Write-Verbose "PageFile maximum size is not $MaximumSize"
				$Success = $False
			}
		} else {
			Write-Verbose "PageFile not found."
			$Success = $False
		}
	} else {
		if ($PageFile) {
			Write-Verbose "PageFile found."
			$Success = $False
		}
	}

	return $Success
}

Export-ModuleMember -Function *-TargetResource
