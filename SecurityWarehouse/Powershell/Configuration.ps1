#############################################################################
# Script Information
#----------------------------------------------------------------------------
#  Author: Tony Sweet (@tonysweetdba)
#  Date: 11/12/13
#  Description: Loads Powershell Modules, sets default Database
#############################################################################

# Define inventory server and database
[String] $inventoryServer=""
[String] $inventoryDatabase="SecurityWarehouse"


#############################################################################
# POWERSHELL V3.0 +
#############################################################################

# Import the SQL Server Module.
Import-Module "sqlps" -DisableNameChecking

#############################################################################
# POWERSHELL V2.0
############################################################################
##Load SqlServerProviderSnapin100 
# if (!(Get-PSSnapin | ?{$_.name -eq 'SqlServerProviderSnapin100'})) 
# { 
	# if(Get-PSSnapin -registered | ?{$_.name -eq 'SqlServerProviderSnapin100'}) 
	# { 
		# add-pssnapin SqlServerProviderSnapin100 
		# write-host "Loading SqlServerProviderSnapin100 in session" 
	# } 
	# else 
	# { 
		# write-error "SqlServerProviderSnapin100 is not registered with the system."
	# } 
# } 
# else 
# { 
	# write-host "SqlServerProviderSnapin100 is already loaded" 
# }  

##Load SqlServerCmdletSnapin100 
# if (!(Get-PSSnapin | ?{$_.name -eq 'SqlServerCmdletSnapin100'})) 
# { 
	# if(Get-PSSnapin -registered | ?{$_.name -eq 'SqlServerCmdletSnapin100'}) 
	# { 
		# add-pssnapin SqlServerCmdletSnapin100 
		# write-host "Loading SqlServerCmdletSnapin100 in session" 
	# } 
	# else 
	# { 
		# write-error  "SqlServerCmdletSnapin100 is not registered with the system."  
	# } 
# } 
# else 
# { 
	# write-host "SqlServerCmdletSnapin100 is already loaded" 
# }