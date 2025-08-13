# Dev_Behavioural_Script.ps1

# Define tasks and their weights
$tasks = @{
    "BrowsingDevResources" = @{
        "Weight" = 15
        "Options" = @{
            "https://stackoverflow.com/" = 15
            "https://github.com/" = 15
            "https://gitlab.com/" = 15
            "https://www.digitalocean.com/community/tutorials" = 15
            "https://dev.to/" = 15
            "https://developer.mozilla.org/" = 10
            "https://www.reddit.com/r/programming/" = 10
            "https://www.geeksforgeeks.org/" = 5
	    "http://192.168.58.13/maintanance.html" = 3
	    "http://192.168.58.13/about.html" = 3
	    "http://192.168.58.13/construction.html" = 3
	    "http://192.168.58.13/contact.html" = 3
	    "http://192.168.58.13/welcome.html" = 3
	    "http://192.168.58.13/dev.html" = 3
        }
    }
    "AccessingDevShares" = @{
        "Weight" = 20
        "Options" = @{
            "\\DB-Server.servers.lmt.com\AllShares\Dev\notes" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Documentation\APIReference.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Documentation\DevGuide.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Projects\Project1\Docs\README.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Projects\Project1\SourceCode\main.py" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Projects\Project1\Tests\test_main.py" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Projects\Project2\Docs\README.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Projects\Project2\SourceCode\app.js" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Projects\Project2\Tests\test_app.js" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Resources\Guidelines\CodingStandards.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Resources\Templates\ProjectTemplate.docx" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Tools\BuildTool.exe" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\Development\Tools\DeployScript.ps1" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\LICENSE" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\README.md" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\.git\config" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\.git\HEAD" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\scripts\github_pull_request.sh" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\scripts\requirements.txt" = 5
            "\\DB-Server.servers.lmt.com\AllShares\Dev\public-apis\scripts\tests\test_validate_format.py" = 5
        }
    }
    "RunningDevTools" = @{
        "Weight" = 15
        "Options" = @{
            "VisualStudioCode.exe.lnk" = 20
            "IntelliJIDEA.exe" = 20
            "PyCharm.exe" = 20
            "Postman.exe" = 20
            "Docker.exe" = 20
        }
    }
    "CodingTasks" = @{
        "Weight" = 15
        "Options" = @{
            "WriteCode" = 40
            "ReviewCode" = 30
            "FixBugs" = 30
        }
    }
    "ProjectManagement" = @{
        "Weight" = 10
        "Options" = @{
            "UpdateJira" = 40
            "PlanSprint" = 30
            "ConductMeeting" = 30
        }
    }
    "VersionControl" = @{
        "Weight" = 10
        "Options" = @{
            "CommitChanges" = 40
            "MergePullRequest" = 30
            "RevertCommit" = 30
        }
    }
    "TestingAndQA" = @{
        "Weight" = 10
        "Options" = @{
            "WriteTests" = 40
            "RunTests" = 40
            "FixTestFailures" = 20
        }
    }
    "DevOpsTasks" = @{
        "Weight" = 5
        "Options" = @{
            "DeployToStaging" = 50
            "DeployToProduction" = 50
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
    "BrowsingDevResources" {
        Start-Process curl -ArgumentList $option -NoNewWindow -PassThru
    }
    "AccessingDevShares" {
        Write-Host "Accessing file share: $option"
        # Simulate accessing a network share
        Get-Content $option
    }
    "RunningDevTools" {
        Start-Process C:\software\$option
    }
    "CodingTasks" {
        switch ($option) {
            "WriteCode" {
                # Simulate writing code
                Write-Host "Writing code."
            }
            "ReviewCode" {
                # Simulate reviewing code
                Write-Host "Reviewing code."
            }
            "FixBugs" {
                # Simulate fixing bugs
                Write-Host "Fixing bugs."
            }
        }
    }
    "ProjectManagement" {
        switch ($option) {
            "UpdateJira" {
                # Simulate updating Jira issues
                Write-Host "Updating Jira issues."
            }
            "PlanSprint" {
                # Simulate planning a sprint
                Write-Host "Planning the sprint."
            }
            "ConductMeeting" {
                # Simulate conducting a meeting
                Write-Host "Conducting a meeting."
            }
        }
    }
    "VersionControl" {
        switch ($option) {
            "CommitChanges" {
                # Simulate committing changes
                Write-Host "Committing changes to version control."
            }
            "MergePullRequest" {
                # Simulate merging a pull request
                Write-Host "Merging a pull request."
            }
            "RevertCommit" {
                # Simulate reverting a commit
                Write-Host "Reverting a commit."
            }
        }
    }
    "TestingAndQA" {
        switch ($option) {
            "WriteTests" {
                # Simulate writing test cases
                Write-Host "Writing test cases."
            }
            "RunTests" {
                # Simulate running tests
                Write-Host "Running tests."
            }
            "FixTestFailures" {
                # Simulate fixing test failures
                Write-Host "Fixing test failures."
            }
        }
    }
    "DevOpsTasks" {
        switch ($option) {
            "DeployToStaging" {
                # Simulate deploying to a staging environment
                Write-Host "Deploying to staging environment."
            }
            "DeployToProduction" {
                # Simulate deploying to a production environment
                Write-Host "Deploying to production environment."
            }
        }
    }
}
