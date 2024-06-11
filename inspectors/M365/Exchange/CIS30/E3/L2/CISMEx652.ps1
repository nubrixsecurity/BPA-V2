# Date: 25-1-2023
# Version: 1.0
# Benchmark: CIS Microsoft 365 v3.0.0
# Product Family: Microsoft Exchange
# Purpose: Ensure MailTips are enabled for end users
# Author: Leonardo van de Weteringh

# New Error Handler Will be Called here
Import-Module PoShLog

# Determine OutPath
$path = @($OutPath)


function Build-CISMEx652($findings)
{
	#Actual Inspector Object that will be returned. All object values are required to be filled in.
	$inspectorobject = New-Object PSObject -Property @{
		ID			     = "CISMEx652"
		FindingName	     = "CIS MEx 6.5.2 - MailTips is not enabled for end users"
		ProductFamily    = "Microsoft Exchange"
		RiskScore	     = "8"
		Description	     = "MailTips assist end users with identifying strange patterns to emails they send. By having this disabled end-users are at risk exfiltrating information or doing malicious things without knowing or without being warned."
		Remediation	     = "Run the PowerShell Command to enable MailTips"
		PowerShellScript = 'Set-OrganizationConfig -MailTipsAllTipsEnabled $true -MailTipsExternalRecipientsTipsEnabled $true -MailTipsGroupMetricsEnabled $true -MailTipsLargeAudienceThreshold "25"'
		DefaultValue	 = "MailTipsAllTipsEnabled: False <br/> MailTipsExternalRecipientsTipsEnabled: False <br/> MailTipsGroupMetricsEnabled: False <br/> MailTipsLargeAudienceThreshold: 25"
		ExpectedValue    = "MailTipsAllTipsEnabled: True <br/> MailTipsExternalRecipientsTipsEnabled: True <br/> MailTipsGroupMetricsEnabled: True <br/> MailTipsLargeAudienceThreshold: >25"
		ReturnedValue    = $findings
		Impact		     = "2"
		Likelihood	     = "4"
		RiskRating	     = "Medium"
		Priority		 = "Medium"
		References	     = @(@{ 'Name' = 'MailTips in Exchange Online'; 'URL' = "https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/mailtips/mailtips" },
			@{ 'Name' = 'Set-OrganizationConfig'; 'URL' = "https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig?view=exchange-ps" })
	}
	return $inspectorobject
}

function Audit-CISMEx652
{
	try
	{
		$ExchangeMailTipsData = @()
		Get-OrganizationConfig | Select-Object MailTipsAllTipsEnabled, MailTipsExternalRecipientsTipsEnabled, MailTipsGroupMetricsEnabled, MailTipsLargeAudienceThreshold
		if ($ExchangeMailTips.MailTipsAllTipsEnabled -match 'True')
		{
			$ExchangeMailTipsData += "MailTipsAllTipsEnabled: $($ExchangeMailTips.MailTipsAllTipsEnabled)"
		}
		if ($ExchangeMailTips.MailTipsExternalRecipientsTipsEnabled -match 'True')
		{
			$ExchangeMailTipsData += "MailTipsExternalRecipientsTipsEnabled: $($ExchangeMailTips.MailTipsExternalRecipientsTipsEnabled)"
		}
		if ($ExchangeMailTips.MailTipsGroupMetricsEnabled -match 'True')
		{
			$ExchangeMailTipsData += "MailTipsGroupMetricsEnabled: $($ExchangeMailTips.MailTipsGroupMetricsEnabled)"
		}
		if ($ExchangeMailTips.MailTipsLargeAudienceThreshold -ige 25)
		{
			$ExchangeMailTipsData += "MailTipsLargeAudienceThreshold: $($ExchangeMailTips.MailTipsLargeAudienceThreshold)"
		}
		if ($ExchangeMailTipsData.count -igt 0)
		{
			$ExchangeMailTipsData | Format-List | Out-File -FilePath "$path\CISMEx652-MailTipsConfiguration.txt"
			$endobject = Build-CISMEx652($ExchangeMailTipsData)
			Return $endobject
		}
		
		return $null
	}
	catch
	{
		Write-WarningLog 'The Inspector: {inspector} was terminated!' -PropertyValues $_.InvocationInfo.ScriptName
		Write-ErrorLog 'An error occured on line {line} char {char} : {error}' -ErrorRecord $_ -PropertyValues $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $_.InvocationInfo.Line
	}
}
return Audit-CISMEx652