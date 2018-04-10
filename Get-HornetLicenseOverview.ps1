param($Username,$Password)

#Create Table object
$table = New-Object system.Data.DataTable “$tabName”

#Define Columns
$customerName = New-Object system.Data.DataColumn Kunde,([string])
$customerUserCount = New-Object system.Data.DataColumn Benutzer,([string])

#Add the Columns
$table.columns.add($customerName)
$table.columns.add($customerUserCount)

#Login
$postParams = @{username=$Username;password=$Password}
[xml]$hornetLogin = (Invoke-WebRequest -Uri https://control.hornetsecurity.com/api/Login -Method POST -Body $postParams).Content

#Get customers
$postParams = @{token=$hornetLogin.LoginResponse.result.token;resellername=$Username}
[xml]$hornetCustomers = (Invoke-WebRequest -Uri https://control.hornetsecurity.com/api/GetCustomerList -Method POST -Body $postParams).Content

$totalUsers = 0

#Get users for each customer
ForEach ($hornetCustomer in $hornetCustomers.GetCustomerListResponse.result.customer)
{
	$postParams = @{token=$hornetLogin.LoginResponse.result.token;customername=$hornetCustomer.name}
	[xml]$hornetUser = (Invoke-WebRequest -Uri https://control.hornetsecurity.com/api/GetUserList -Method POST -Body $postParams).Content
	$hornetUserCount = ($hornetUser.GetUserListResponse.result.user | Measure-Object).Count

	#Create a row
	$row = $table.NewRow()

	#Enter data in the row
	$row.Kunde = $hornetCustomer.name
	$row.Benutzer = $hornetUserCount

	#Add the row to the table
	$table.Rows.Add($row)
	
	$totalUsers += $hornetUserCount 

}

#Logout
$postParams = @{token=$hornetLogin.LoginResponse.result.token}
[xml]$hornetLogin = (Invoke-WebRequest -Uri https://control.hornetsecurity.com/api/Logout -Method POST -Body $postParams).Content

$table | format-table -AutoSize 

"Gesamt: $totalUsers"