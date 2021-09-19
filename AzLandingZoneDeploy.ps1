#Login to Azure
Login-AzAccount
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

#Create Resource Group 
New-AzResourceGroup -Name FarooqResourceGroup -Location 'West Europe' -Force
$rulerdp = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP only" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
$ruleweb = New-AzNetworkSecurityRuleConfig -name web-rule -Description "Allow HTTP only" -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80
$NSG = New-AzNetworkSecurityGroup -ResourceGroupName FarooqResourceGroup -Location 'West Europe' -Name "NSG-Farooq" -SecurityRules $rulerdp,$ruleweb -Force

$subnetweb = New-AzVirtualNetworkSubnetConfig -Name subnetweb -AddressPrefix "192.169.0.0/24" -NetworkSecurityGroup $NSG
$subnetapp = New-AzVirtualNetworkSubnetConfig -Name subnetapp -AddressPrefix "192.169.1.0/24" -NetworkSecurityGroup $NSG
$subnetdb = New-AzVirtualNetworkSubnetConfig -Name subnetdb -AddressPrefix "192.169.2.0/24" -NetworkSecurityGroup $NSG
$subnetjh = New-AzVirtualNetworkSubnetConfig -Name subnetjh -AddressPrefix "192.169.3.0/24" -NetworkSecurityGroup $NSG
New-AzVirtualNetwork -Name FarooqVirtualNetwork -ResourceGroupName FarooqResourceGroup -Location 'West Europe' -AddressPrefix "192.169.0.0/22" -Subnet $subnetweb,$subnetapp,$subnetdb,$subnetjh -Verbose -Force
