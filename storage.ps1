# Define parameters
$resourceGroupName = "MyResourceGroup"   # Replace with your resource group name
$location = "eastus"                      # Replace with your desired location
$storageAccountName = "jkglmnop"


# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName "Standard_LRS" -Kind "StorageV2"

# Wait for the storage account to be provisioned
Start-Sleep -Seconds 10

# Get Storage Context
$storageKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccountName)[0].Value
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKey

# Set Public Access to Allowed on the Storage Account
Set-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -PublicNetworkAccess Enabled


Write-Host "Storage account successfully created '$storageAccountName'."

