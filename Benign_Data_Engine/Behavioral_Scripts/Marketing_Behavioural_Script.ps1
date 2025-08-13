# Marketing_Behavioural_Script.ps1

# Define tasks and their weights
$tasks = @{
    "BrowsingMarketingResources" = @{
        "Weight" = 20
        "Options" = @{
            "https://www.marketingprofs.com/" = 20
            "https://www.hubspot.com/" = 20
            "https://www.adweek.com/" = 20
            "https://www.contentmarketinginstitute.com/" = 20
            "https://moz.com/blog" = 20
	    "http://192.168.58.13/maintanance.html" = 3
	    "http://192.168.58.13/about.html" = 3
	    "http://192.168.58.13/construction.html" = 3
	    "http://192.168.58.13/contact.html" = 3
	    "http://192.168.58.13/welcome.html" = 3
	    "http://192.168.58.13/mark.html" = 3
        }
    }
    "AccessingMarketingShares" = @{
        "Weight" = 25
        "Options" = @{
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\notes" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Campaigns\Campaign1\Plan.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Campaigns\Campaign1\Report.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Campaigns\Campaign2\Plan.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Campaigns\Campaign2\Report.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Documentation\Plans\Marketing_Plan.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Documentation\Reports\Marketing_Report.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Research\CompetitorAnalysis\competitor_analysis.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Research\MarketAnalysis\market_analysis.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Resources\Guidelines\Marketing_Guidelines.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Resources\Templates\Marketing_Template.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Tools\SEOTool.exe" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Marketing\Tools\SocialMediaScript.ps1" = 5
        }
    }
    "RunningMarketingTools" = @{
        "Weight" = 20
        "Options" = @{
            "SEOTool.exe" = 40
            "SocialMediaScript.ps1" = 40
            "AnalyticsDashboard.exe" = 20
        }
    }
    "CreatingContent" = @{
        "Weight" = 15
        "Options" = @{
            "WriteBlogPost" = 40
            "CreateSocialMediaPost" = 40
            "DesignEmailCampaign" = 20
        }
    }
    "AnalyzingData" = @{
        "Weight" = 10
        "Options" = @{
            "AnalyzeCampaignPerformance" = 50
            "ConductMarketResearch" = 50
        }
    }
    "ManagingCampaigns" = @{
        "Weight" = 10
        "Options" = @{
            "PlanCampaign" = 50
            "ReportOnCampaign" = 50
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
    "BrowsingMarketingResources" {
        Start-Process curl -ArgumentList $option -NoNewWindow -PassThru
    }
    "AccessingMarketingShares" {
        Write-Host "Accessing file share: $option"
        # Simulate accessing a network share
        Get-Content $option
    }
    "RunningMarketingTools" {
        if ($option -like "*.ps1") {
            # Run the PowerShell script
            & PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File C:\software\$option
        } else {
            # Start the executable
            Start-Process C:\software\$option
        }
    }
    "CreatingContent" {
        switch ($option) {
            "WriteBlogPost" {
                # Simulate writing a blog post
                Write-Host "Writing a blog post."
            }
            "CreateSocialMediaPost" {
                # Simulate creating a social media post
                Write-Host "Creating a social media post."
            }
            "DesignEmailCampaign" {
                # Simulate designing an email campaign
                Write-Host "Designing an email campaign."
            }
        }
    }
    "AnalyzingData" {
        switch ($option) {
            "AnalyzeCampaignPerformance" {
                # Simulate analyzing campaign performance data
                Write-Host "Analyzing campaign performance."
            }
            "ConductMarketResearch" {
                # Simulate conducting market research
                Write-Host "Conducting market research."
            }
        }
    }
    "ManagingCampaigns" {
        switch ($option) {
            "PlanCampaign" {
                # Simulate planning a marketing campaign
                Write-Host "Planning a marketing campaign."
            }
            "ReportOnCampaign" {
                # Simulate reporting on a marketing campaign
                Write-Host "Reporting on a marketing campaign."
            }
        }
    }
}
