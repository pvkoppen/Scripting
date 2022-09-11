
$ServerInstance = "VCOM "
$Database = "VCOM "
$ConnectionTimeout = 30
$Query = "SELECT COUNT(*) FROM [VCOM_Comm].[dbo].[COMM_ConfigStore]"
$QueryTimeout = 120

$ConnectionString = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $ServerInstance,$Database,$ConnectionTimeout
$conn=new-object System.Data.SqlClient.SQLConnection
$conn.ConnectionString=$ConnectionString
$conn.Open()
$cmd=new-object system.Data.SqlClient.SqlCommand($Query,$conn)
$cmd.CommandTimeout=$QueryTimeout
$ds=New-Object system.Data.DataSet
$da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
$da.fill($ds)
$conn.Close()

$ds.Tables

#Go ahead and add the SQL Snapins
add-pssnapin SqlServerCmdletSnapin100

#sp_databases | format-table
invoke-sqlcmd -query “sp_databases” -database master -serverinstance WIN7\Kilimanjaro | format-table


new-DynamicDistributionGroup -Name "Tui Ora LOCATION Glover Rd Hawera" -Alias "TuiOraLOCATIONGloverRdHawera" -RecipientFilter {(Office -eq 'Glover Rd, Hawera')} -RecipientContainer "tol.local/TOL"
new-DynamicDistributionGroup -Name "Tui Ora LOCATION Maru Wehi Hauora New Plymouth" -Alias "TuiOraLOCATIONMaruWehiHauoraNewPlymouth" -RecipientFilter {(Office -eq 'Maru Wehi Hauora, New Plymouth')} -RecipientContainer "tol.local/TOL"

Get-DynamicDistributionGroup '*glover*' | set-DynamicDistributionGroup -Name "Tui Ora LOCATION Glover Rd Hawera" -Alias "TuiOraLOCATIONGloverRdHawera" -RecipientFilter {(Office -eq 'Glover Rd, Hawera')} -RecipientContainer "tol.local/TOL"
Get-DynamicDistributionGroup '*maru w*' | set-DynamicDistributionGroup -Name "Tui Ora LOCATION Maru Wehi Hauora New Plymouth" -Alias "TuiOraLOCATIONMaruWehiHauoraNewPlymouth" -RecipientFilter {(Office -eq 'Maru Wehi Hauora, New Plymouth')} -RecipientContainer "tol.local/TOL"
