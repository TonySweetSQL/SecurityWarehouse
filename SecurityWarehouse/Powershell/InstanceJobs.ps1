#############################################################################
# Script Information
#----------------------------------------------------------------------------
#  Date: 11/12/13
#  Description: Collects job information from all instances
#############################################################################

# Bring in Warehouse variables and load Modules
.\Configuration.ps1

[String] $sqlQuery=""
[String] $sqlQuery1=""
[String] $sqlQuery2=""
[String] $sqlQuery3=""
[String] $InstanceName=""
[String] $Database = "master"
[String] $crdate=""

# Query to get the list of SQL Server hosts from the inventory database
$sqlQuery="SELECT ConnectionString FROM dbo.admin_servernames WITH (NOLOCK) WHERE IsSQLServer = 1"
$sqlHosts=Invoke-Sqlcmd -Query $sqlQuery -ServerInstance $inventoryServer -Database $inventoryDatabase

# Truncate the old data
$sqlQuery1="TRUNCATE TABLE SecurityWarehouse.dbo.instance_jobs"
Invoke-Sqlcmd -Query $sqlQuery1 -ServerInstance $inventoryServer -Database $inventoryDatabase

# Query for job information to be run on each instance
$sqlQuery2="SELECT  @@SERVERNAME AS 'InstanceName'
				,name
				,enabled
				,REPLACE(description,'''','''''') AS 'description'
				,dbo.fn_varbintohexstr(owner_sid) AS 'owner_sid'
				,SUSER_SNAME(owner_sid) AS 'owner'
				,date_created
				,date_modified 
				FROM msdb.dbo.sysjobs WITH (NOLOCK)"

# Get information from each instance
foreach ($sqlHost in $sqlHosts) 
{
	$conn=$sqlHost.ConnectionString    
	Write-Host "Collecting job information from $conn"

	$results=Invoke-Sqlcmd -Query $sqlQuery2 -ServerInstance $conn -Database $database

	# Get row of data
    Foreach ($result in $results) 
	{
		$InstanceName=$result.InstanceName
		$name=$result.name.REPLACE("'","''")	# Need to escape character any ' character
		$enabled=$result.enabled
		$description=$result.description
		$owner_sid=$result.owner_sid
		$date_created=$result.date_created
		$date_modified=$result.date_modified
		$description=$result.description
		$owner=$result.owner

		# Insert data into warehouse
		if ($name -ne $null -and $name -ne "")
		{  
			$sqlQuery3="INSERT INTO [dbo].[instance_jobs]([InstanceName],[name],[enabled],[description],[owner_sid],[date_created],[date_modified],[owner])
							VALUES ('$InstanceName','$name','$enabled','$description','$owner_sid','$date_created','$date_modified','$owner')"  			
			Invoke-Sqlcmd -Query $sqlQuery3 -ServerInstance $inventoryServer -Database $inventoryDatabase
		}
	}    
}