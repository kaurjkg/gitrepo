# Define parameters
$resourceGroupName = "MyResourceGroup"
$location = "East US"
$vmName = "MyVM"
$adminUsername = "adminuser"
$adminPassword = ConvertTo-SecureString "Jaspreet@1998" -AsPlainText -Force

# Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create Virtual Network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name "MyVNet" -AddressPrefix "10.0.0.0/16"
$vnet = Add-AzVirtualNetworkSubnetConfig -Name "MySubnet" -VirtualNetwork $vnet -AddressPrefix "10.0.1.0/24"
$vnet | Set-AzVirtualNetwork  # Apply changes to Azure

# Retrieve the newly created subnet
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork (Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name "MyVNet") -Name "MySubnet"

echo $subnet.Id

# Create Public IP
$publicIp = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Location $location -Name "MyPublicIP" -AllocationMethod Static

# Create Network Interface
$nic = New-AzNetworkInterface -ResourceGroupName $resourceGroupName -Location $location -Name "MyNIC" -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id

# Create VM Configuration
$cred = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_B1s" | `
           Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
           Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2019-Datacenter" -Version "latest" | `
           Add-AzVMNetworkInterface -Id $nic.Id

# Deploy VM
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

