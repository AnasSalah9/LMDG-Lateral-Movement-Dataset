# Sales_Behavioural_Script.ps1
$processesToTerminate = @()

# Define tasks and their weights
$tasks = @{
    "BrowsingSalesResources" = @{
        "Weight" = 20
        "Options" = @{
            "https://www.salesforce.com/blog/" = 15
            "https://www.hubspot.com/sales" = 15
            "https://www.saleshacker.com/" = 15
            "https://www.sandler.com/blog" = 15
            "https://blog.hubspot.com/sales" = 10
            "https://www.outreach.io/blog" = 10
            "https://www.close.com/blog" = 10
	    "http://192.168.58.13/maintanance.html" = 3
	    "http://192.168.58.13/about.html" = 3
	    "http://192.168.58.13/construction.html" = 3
	    "http://192.168.58.13/contact.html" = 3
	    "http://192.168.58.13/welcome.html" = 3
	    "http://192.168.58.13/sales.html" = 3
        }
    }
    "AccessingSalesShares" = @{
        "Weight" = 25
        "Options" = @{
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Documentation\Policies\Sales_Policies.docx" = 6
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Documentation\Procedures\Sales_Procedures.docx" = 6
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Leads\Lead1\Details.md" = 6
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Leads\Lead1\FollowUp.md" = 6
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Leads\Lead2\Details.md" = 6
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Leads\Lead2\FollowUp.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Reports\Monthly\July2024_Report.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Reports\Quarterly\Q2_2024_Report.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Resources\Guidelines\Sales_Guidelines.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\Resources\Templates\Sales_Template.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Annual-Analysis-and-Summary-Report-of-Sales-Data.xlsx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Appointment-Setting-Script.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Follow-up-Benefits-of-our-product_service.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\KRA-For-SEO-Specialist.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Money-Collection-Second-Reminder-of-Late-Payment.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Pricing-Strategy-Worksheet.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Sales-10-Min-Pitch.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\sales-invoice.xlsx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Sales-Plan.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\Sales-Proposal-Medium-Length.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Sales\sales\SOP-for-conducting-a-client-meeting.docx" = 5
        }
    }
    "RunningSalesTools" = @{
        "Weight" = 20
        "Options" = @{
            "CRMTool.exe" = 60
            "AutomationScript.ps1" = 40
        }
    }
    "ManagingLeads" = @{
        "Weight" = 15
        "Options" = @{
            "QualifyLead" = 40
            "FollowUpLead" = 30
            "CloseLead" = 30
        }
    }
    "AnalyzingSalesData" = @{
        "Weight" = 10
        "Options" = @{
            "AnalyzeMonthlyReport" = 50
            "AnalyzeQuarterlyReport" = 50
        }
    }
    "CreatingSalesDocuments" = @{
        "Weight" = 10
        "Options" = @{
            "PrepareProposal" = 50
            "CreateSalesPlan" = 50
        }
    }
}

# Function to select a random item based on weight
function Get-RandomWeighted {
    param (
        [hashtable]$items
    )
    $sum = ($items.Values | Measure-Object -Sum).Sum
    $rand = Get-Random -Maximum $sum
    $current = 0
    foreach ($key in $items.Keys) {
        $current += $items[$key]
        if ($rand -lt $current) {
            return $key
        }
    }
}

# Construct a hashtable with task names and their weights
$taskWeights = @{}
foreach ($key in $tasks.Keys) {
    $taskWeights[$key] = $tasks[$key].Weight
}

# Select a task based on weight
$taskName = Get-RandomWeighted $taskWeights
$task = $tasks[$taskName]

# Select an option for the task based on weight
$option = Get-RandomWeighted $task.Options

Write-Host "Selected Task: $taskName"
Write-Host "Selected Option: $option"

# Execute the selected task and option
switch ($taskName) {
    "BrowsingSalesResources" {
         Start-Process curl -ArgumentList $option -NoNewWindow -PassThru
    }
    "AccessingSalesShares" {
        Write-Host "Accessing file share: $option"
        # Simulate accessing a network share
        Get-Content $option
    }
    "RunningSalesTools" {
        if ($option -like "*.ps1") {
            # Run the PowerShell script
            & PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File C:\software\$option
        } else {
            # Start the executable
            Start-Process C:\software\$option
        }
    }
    "ManagingLeads" {
        switch ($option) {
            "QualifyLead" {
                # Simulate qualifying a lead
                Write-Host "Qualifying a lead."
            }
            "FollowUpLead" {
                # Simulate following up with a lead
                Write-Host "Following up with a lead."
            }
            "CloseLead" {
                # Simulate closing a lead
                Write-Host "Closing a lead."
            }
        }
    }
    "AnalyzingSalesData" {
        switch ($option) {
            "AnalyzeMonthlyReport" {
                # Simulate analyzing monthly sales report data
                Write-Host "Analyzing monthly sales report."
            }
            "AnalyzeQuarterlyReport" {
                # Simulate analyzing quarterly sales report data
                Write-Host "Analyzing quarterly sales report."
            }
        }
    }
    "CreatingSalesDocuments" {
        switch ($option) {
            "PrepareProposal" {
                # Simulate preparing a sales proposal
                Write-Host "Preparing a sales proposal."
            }
            "CreateSalesPlan" {
                # Simulate creating a sales plan
                Write-Host "Creating a sales plan."
            }
        }
    }
}
