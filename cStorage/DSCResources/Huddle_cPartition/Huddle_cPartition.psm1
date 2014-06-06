function Get-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $DiskNumber,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $PartitionNumber
	)

	$Partition = Get-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber -ErrorAction SilentlyContinue

	if ($Partition) {
		return @{
			DiskNumber = $DiskNumber;
			PartitionNumber = $PartitionNumber;
			DriveLetter = $Partition.DriveLetter
		}
	} else {
		Write-Error "Partition not found."
	}
}

function Set-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $DiskNumber,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $PartitionNumber,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter
	)

	if (Get-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber -ErrorAction SilentlyContinue) {
		Set-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber -NewDriveLetter $DriveLetter
	} else {
		Write-Error "Partition not found."
	}
}

function Test-TargetResource
{
	param (
		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $DiskNumber,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[UInt32] $PartitionNumber,

		[Parameter(Mandatory)]
		[ValidateNotNull()]
		[Char] $DriveLetter
	)

	$Partition = Get-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionNumber -ErrorAction SilentlyContinue

	if ($Partition) {
		return $Partition.DriveLetter -EQ $DriveLetter
	} else {
		Write-Error "Partition not found."
		return $False
	}
}

Export-ModuleMember -Function *-TargetResource
