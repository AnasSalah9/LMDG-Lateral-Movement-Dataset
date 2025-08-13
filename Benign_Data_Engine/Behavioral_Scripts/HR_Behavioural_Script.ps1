# HR_Behavioural_Script.ps1

# Define tasks and their weights
$tasks = @{
    "BrowsingJobBoards" = @{
        "Weight" = 20
        "Options" = @{
            "https://www.hrexaminer.com/" = 15  
            "https://www.ziprecruiter.com" = 15
            "https://talentculture.com" = 15 
            "https://www.hrzone.com/" = 15 
            "https://www.naukri.com/" = 13
            "https://www.tlnt.com/" = 9  
            "https://www.hcamag.com/" = 9 
            "https://www.flexjobs.com" = 9
	    "http://192.168.58.13/maintanance.html" = 3
	    "http://192.168.58.13/about.html" = 3
	    "http://192.168.58.13/construction.html" = 3
	    "http://192.168.58.13/contact.html" = 3
	    "http://192.168.58.13/welcome.html" = 3
	    "http://192.168.58.13/hr.html" = 3
        }
    }
    "ManagingEmployeeRecords" = @{
        "Weight" = 20
        "Options" = @{
            "AddEmployeeRecord" = 25
            "UpdateEmployeeRecord" = 25
            "DeleteEmployeeRecord" = 25
            "ViewEmployeeRecord" = 25
        }
    }
    "RunningHRSoftware" = @{
        "Weight" = 15
        "Options" = @{
            "HRMSystem.exe" = 20  #(HR Management System)
            "PayrollSystem.exe" = 20  #(Payroll System)
            "TimeTracking.exe" = 20  #(Time Tracking System)
            "RecruitmentTool.exe" = 20  #(Recruitment Management Tool)
            "PerformanceReview.exe" = 10  #(Performance Review System)
            "BenefitsAdmin.exe" = 10  #(Benefits Administration Tool)
        }
    }
    "HandlingRecruitment" = @{
        "Weight" = 10
        "Options" = @{
            "PostJobListing" = 30
            "ScheduleInterview" = 25
            "ConductInterview" = 25
            "SendOfferLetter" = 20
        }
    }
    "ManagingBenefits" = @{
        "Weight" = 10
        "Options" = @{
            "UpdateHealthBenefits" = 33
            "ManageRetirementPlans" = 33
            "ProcessBenefitClaims" = 34
        }
    }
    "AccessingShares" = @{
        "Weight" = 10
        "Options" = @{
            "\\DB-Server.servers.lmt.com\AllShares\HR\file_1722718835062.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Training-Manual-Template\Training Manual Template.doc" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Template-for-Recording-Employee-Meetings\Template for Recording Employee Meetings.doc" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Sample-Welcome-Letter\Sample Welcome Letter.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Sample-Interview-Questions\Sample Interview Questions.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Retirement-Policy-Template\Retirement Policy Template.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Project-Management-Plan-Template\Project Management Plan Template.doc" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Payslip-Template\Payslip Template.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Metrics-Dashboard-Template\Metrics Dashboard Template.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Letter-of-Engagement-Template\Letter of Engagement Template_.doc" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Induction-Plan-Template\Induction-Plan-Template.doc" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Disciplinary-Suspension-Letter-Template\Disciplinary Suspension Letter Template.doc" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Attendance-Policy-Samples\Attendance Policy Samples.pdf" = 7
            "\\DB-Server.servers.lmt.com\AllShares\HR\Assessment-Report-Template\Assessment Report Template.doc" = 7
        }
    }
    "OrganizingTraining" = @{
        "Weight" = 5
        "Options" = @{
            "ScheduleTraining" = 40
            "UpdateTrainingMaterials" = 30
            "EvaluateTrainingPrograms" = 30
        }
    }
    "EmployeeEngagement" = @{
        "Weight" = 5
        "Options" = @{
            "ConductSurveys" = 34
            "OrganizeEvents" = 33
            "AnalyzeFeedback" = 33
        }
    }
    "ComplianceAndPolicies" = @{
        "Weight" = 5
        "Options" = @{
            "ReviewCompliance" = 50
            "UpdatePolicies" = 50
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
    "BrowsingJobBoards" {
        Start-Process curl -ArgumentList $option -NoNewWindow -PassThru
    }
    "ManagingEmployeeRecords" {
        switch ($option) {
            "AddEmployeeRecord" {
                # Simulate adding an employee record
                Write-Host "Adding a new employee record."
            }
            "UpdateEmployeeRecord" {
                # Simulate updating an employee record
                Write-Host "Updating an existing employee record."
            }
            "DeleteEmployeeRecord" {
                # Simulate deleting an employee record
                Write-Host "Deleting an employee record."
            }
            "ViewEmployeeRecord" {
                # Simulate viewing an employee record
                Write-Host "Viewing an employee record."
            }
        }
    }
    "RunningHRSoftware" {
        Start-Process C:\software\$option
    }
    "HandlingRecruitment" {
        switch ($option) {
            "PostJobListing" {
                # Simulate posting a job listing
                Write-Host "Posting a new job listing."
            }
            "ScheduleInterview" {
                # Simulate scheduling an interview
                Write-Host "Scheduling an interview."
            }
            "ConductInterview" {
                # Simulate conducting an interview
                Write-Host "Conducting an interview."
            }
            "SendOfferLetter" {
                # Simulate sending an offer letter
                Write-Host "Sending an offer letter."
            }
        }
    }
    "ManagingBenefits" {
        switch ($option) {
            "UpdateHealthBenefits" {
                # Simulate updating health benefits
                Write-Host "Updating health benefits."
            }
            "ManageRetirementPlans" {
                # Simulate managing retirement plans
                Write-Host "Managing retirement plans."
            }
            "ProcessBenefitClaims" {
                # Simulate processing benefit claims
                Write-Host "Processing benefit claims."
            }
        }
    }
    "AccessingShares" {
        Write-Host "Accessing file share: $option"
        # Simulate accessing a network share
        Get-Content $option
    }
    "OrganizingTraining" {
        switch ($option) {
            "ScheduleTraining" {
                # Simulate scheduling training
                Write-Host "Scheduling training sessions."
            }
            "UpdateTrainingMaterials" {
                # Simulate updating training materials
                Write-Host "Updating training materials."
            }
            "EvaluateTrainingPrograms" {
                # Simulate evaluating training programs
                Write-Host "Evaluating training programs."
            }
        }
    }
    "EmployeeEngagement" {
        switch ($option) {
            "ConductSurveys" {
                # Simulate conducting employee surveys
                Write-Host "Conducting employee engagement surveys."
            }
            "OrganizeEvents" {
                # Simulate organizing employee events
                Write-Host "Organizing employee events."
            }
            "AnalyzeFeedback" {
                # Simulate analyzing feedback from surveys
                Write-Host "Analyzing feedback from surveys."
            }
        }
    }
    "ComplianceAndPolicies" {
        switch ($option) {
            "ReviewCompliance" {
                # Simulate reviewing compliance
                Write-Host "Reviewing compliance regulations."
            }
            "UpdatePolicies" {
                # Simulate updating policies
                Write-Host "Updating company policies."
            }
        }
    }
}
