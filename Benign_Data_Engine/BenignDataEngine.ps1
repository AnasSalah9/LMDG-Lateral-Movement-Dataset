# Import the powershell-yaml module
Import-Module powershell-yaml

# Specify the path to the YAML file
$yamlFilePath = "C:\Users\Administrator\desktop\BenignDataEngineConfig.yaml"

# Read the YAML file and convert it to a PowerShell object
$configData = Get-Content -Path $yamlFilePath | ConvertFrom-Yaml

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#        Users Credentials and Hosts
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


$usersinfo = @{}

# psobject.Properties.Name
foreach ($key in $configData["UsersCredsAndHosts"].Keys) {
    # Access the value of each property using dot notation
    $value = $configData["UsersCredsAndHosts"][$key]    
    $usersinfo[$key] = $value
}

# each user has 4 properties so dividing the total number of properties by 4 will give us the # users
$NumberOfUsers = ($usersinfo.Count)/4
$Users_Hosts = @()

for($i = 1 ; $i -le $NumberOfUsers ; $i++){
    # Define credentials for remote execution
    $username = $usersinfo["username"+$i]
    $pass = $usersinfo["pass"+$i]
    $remoteComputer = $usersinfo["remoteComputer"+$i]
    $DeptID = $usersinfo["DeptID"+$i]
    
    $password = ConvertTo-SecureString $pass -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($username, $password)

    $Users_Hosts += ,(($credential, $remoteComputer, $DeptID))
}

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#        Behavioural Scripts
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

$behavScriptsNames = @{}

# psobject.Properties.Name
foreach ($key in $configData["BehaviouralScripts"].Keys) {
    # Access the value of each property using dot notation
    $value = $configData["BehaviouralScripts"][$key]    
    $behavScriptsNames[$key] = $value
}

# each user has 4 properties so dividing the total number of properties by 4 will give us the # users
$NumberOfBehavScripts = $behavScriptsNames.Count
$BehaviouralScripts = @()

for($i = 1 ; $i -le $NumberOfBehavScripts ; $i++){
    
    # Define credentials for remote execution
    $scriptName = $behavScriptsNames["BehaviouralScriptName"+$i]

    # Read the contents of the script file into a variable
    $scriptContent = Get-Content -Path $scriptName -Raw
    # Create a script block from the script content
    $Behavioural_Script = [scriptblock]::Create($scriptContent)

    $BehaviouralScripts += $Behavioural_Script
}

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#        Configurations
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

#--------------------------------

# Probabilities of an employee being absent in weekdays
$isVal_probabilityAbsent = $configData.EngineConfig.isVal_probabilityAbsent
$probabilityAbsent_val = $configData.EngineConfig.probabilityAbsent_val
$probabilityAbsent_min = $configData.EngineConfig.probabilityAbsent_min
$probabilityAbsent_max = $configData.EngineConfig.probabilityAbsent_max

# Probabilities of an employee being absent in weekends
$isVal_probabilityAbsent_weekend = $configData.EngineConfig.isVal_probabilityAbsent_weekend
$probabilityAbsent_val_weekend = $configData.EngineConfig.probabilityAbsent_val_weekend
$probabilityAbsent_min_weekend = $configData.EngineConfig.probabilityAbsent_min_weekend
$probabilityAbsent_max_weekend = $configData.EngineConfig.probabilityAbsent_max_weekend

#--------------------------------

# t_start_abnormal_early: [3:30 AM - 7:29 AM] (exponential distribution)
$start_time_sae_hour = $configData.EngineConfig.start_time_sae_hour
$start_time_sae_minute = $configData.EngineConfig.start_time_sae_minute
$end_time_sae_hour = $configData.EngineConfig.end_time_sae_hour
$end_time_sae_minute = $configData.EngineConfig.end_time_sae_minute

$isExp_sae = $configData.EngineConfig.isExp_sae
$lambda_sae = $configData.EngineConfig.lambda_sae
$flipped_sae = $configData.EngineConfig.flipped_sae

$isVal_prob_t_sae = $configData.EngineConfig.isVal_prob_t_sae
$prob_t_sae_val = $configData.EngineConfig.prob_t_sae_val
$prob_t_sae_min = $configData.EngineConfig.prob_t_sae_min
$prob_t_sae_max = $configData.EngineConfig.prob_t_sae_max
#--------------------------------

# t_start_abnormal_late: [10:01 AM - 4:00 PM] (flipped exponential distribution)
$start_time_sal_hour = $configData.EngineConfig.start_time_sal_hour
$start_time_sal_minute = $configData.EngineConfig.start_time_sal_minute
$end_time_sal_hour = $configData.EngineConfig.end_time_sal_hour
$end_time_sal_minute = $configData.EngineConfig.end_time_sal_minute

$isExp_sal = $configData.EngineConfig.isExp_sal
$lambda_sal = $configData.EngineConfig.lambda_sal
$flipped_sal = $configData.EngineConfig.flipped_sal

$isVal_prob_t_sal = $configData.EngineConfig.isVal_prob_t_sal
$prob_t_sal_val = $configData.EngineConfig.prob_t_sal_val
$prob_t_sal_min = $configData.EngineConfig.prob_t_sal_min
$prob_t_sal_max = $configData.EngineConfig.prob_t_sal_max

#--------------------------------

# t_start_late: [8:31 AM - 10 AM] (flipped exponential distribution)
$start_time_sl_hour = $configData.EngineConfig.start_time_sl_hour
$start_time_sl_minute = $configData.EngineConfig.start_time_sl_minute
$end_time_sl_hour = $configData.EngineConfig.end_time_sl_hour
$end_time_sl_minute = $configData.EngineConfig.end_time_sl_minute

$isExp_sl = $configData.EngineConfig.isExp_sl
$lambda_sl = $configData.EngineConfig.lambda_sl
$flipped_sl = $configData.EngineConfig.flipped_sl

$isVal_prob_t_sl = $configData.EngineConfig.isVal_prob_t_sl
$prob_t_sl_val = $configData.EngineConfig.prob_t_sl_val
$prob_t_sl_min = $configData.EngineConfig.prob_t_sl_min
$prob_t_sl_max = $configData.EngineConfig.prob_t_sl_max

#--------------------------------

# t_start_ontime: [7:30 AM - 8:30 AM] (normal distribution)
$start_time_son_hour = $configData.EngineConfig.start_time_son_hour
$start_time_son_minute = $configData.EngineConfig.start_time_son_minute
$end_time_son_hour = $configData.EngineConfig.end_time_son_hour
$end_time_son_minute = $configData.EngineConfig.end_time_son_minute

$isExp_son = $configData.EngineConfig.isExp_son
$lambda_son = $configData.EngineConfig.lambda_son
$flipped_son = $configData.EngineConfig.flipped_son

#--------------------------------

# t_end_abnormal_early: [9 AM - 3:00 PM] (exponential distribution)
$start_time_eae_hour = $configData.EngineConfig.start_time_eae_hour
$start_time_eae_minute = $configData.EngineConfig.start_time_eae_minute
$end_time_eae_hour = $configData.EngineConfig.end_time_eae_hour
$end_time_eae_minute = $configData.EngineConfig.end_time_eae_minute

$isExp_eae = $configData.EngineConfig.isExp_eae
$lambda_eae = $configData.EngineConfig.lambda_eae
$flipped_eae = $configData.EngineConfig.flipped_eae

$isVal_prob_t_eae = $configData.EngineConfig.isVal_prob_t_eae
$prob_t_eae_val = $configData.EngineConfig.prob_t_eae_val
$prob_t_eae_min = $configData.EngineConfig.prob_t_eae_min
$prob_t_eae_max = $configData.EngineConfig.prob_t_eae_max

#--------------------------------

# t_end_abnormal_late: [8:01 PM - 2:30 AM (next day)](flipped exponential distribution)
$start_time_eal_hour = $configData.EngineConfig.start_time_eal_hour
$start_time_eal_minute = $configData.EngineConfig.start_time_eal_minute
$end_time_eal_hour = $configData.EngineConfig.end_time_eal_hour
$end_time_eal_minute = $configData.EngineConfig.end_time_eal_minute
$end_time_eal_nextDay = $configData.EngineConfig.end_time_eal_nextDay

$isExp_eal = $configData.EngineConfig.isExp_eal
$lambda_eal = $configData.EngineConfig.lambda_eal
$flipped_eal = $configData.EngineConfig.flipped_eal

$isVal_prob_t_eal = $configData.EngineConfig.isVal_prob_t_eal
$prob_t_eal_val = $configData.EngineConfig.prob_t_eal_val
$prob_t_eal_min = $configData.EngineConfig.prob_t_eal_min
$prob_t_eal_max = $configData.EngineConfig.prob_t_eal_max

#--------------------------------

# t_end_late: [5:31 PM - 8 PM] (flipped exponential distribution)
$start_time_el_hour = $configData.EngineConfig.start_time_el_hour
$start_time_el_minute = $configData.EngineConfig.start_time_el_minute
$end_time_el_hour = $configData.EngineConfig.end_time_el_hour
$end_time_el_minute = $configData.EngineConfig.end_time_el_minute

$isExp_el = $configData.EngineConfig.isExp_el
$lambda_el = $configData.EngineConfig.lambda_el
$flipped_el = $configData.EngineConfig.flipped_el

$isVal_prob_t_el = $configData.EngineConfig.isVal_prob_t_el
$prob_t_el_val = $configData.EngineConfig.prob_t_el_val
$prob_t_el_min = $configData.EngineConfig.prob_t_el_min
$prob_t_el_max = $configData.EngineConfig.prob_t_el_max

#--------------------------------

# t_end_ontime: [4:30 PM - 5:30 PM] (normal distribution)
$start_time_eon_hour = $configData.EngineConfig.start_time_eon_hour
$start_time_eon_minute = $configData.EngineConfig.start_time_eon_minute
$end_time_eon_hour = $configData.EngineConfig.end_time_eon_hour
$end_time_eon_minute = $configData.EngineConfig.end_time_eon_minute

$isExp_eon = $configData.EngineConfig.isExp_eon
$lambda_eon = $configData.EngineConfig.lambda_eon
$flipped_eon = $configData.EngineConfig.flipped_eon

#--------------------------------

# LUNCH LOGOUTs



# start_lunch_time: the interval in which the lunch break can start [11:30 AM - 12:30 PM] (normal distribution)
$start_lunch_start_time_hour = $configData.EngineConfig.start_lunch_start_time_hour
$start_lunch_start_time_minute = $configData.EngineConfig.start_lunch_start_time_minute
$start_lunch_end_time_hour = $configData.EngineConfig.start_lunch_end_time_hour
$start_lunch_end_time_minute = $configData.EngineConfig.start_lunch_end_time_minute

$isExp_lunch_start = $configData.EngineConfig.isExp_lunch_start
$lambda_lunch_start = $configData.EngineConfig.lambda_lunch_start
$flipped_lunch_start = $configData.EngineConfig.flipped_lunch_start
$CI_lunch_start = $configData.EngineConfig.CI_lunch_start # confidence interval for normal distribution


# end_lunch_time: the interval in which the lunch break can end [12:31 PM - 01:30 PM] (normal distribution)
$end_lunch_start_time_hour = $configData.EngineConfig.end_lunch_start_time_hour
$end_lunch_start_time_minute = $configData.EngineConfig.end_lunch_start_time_minute
$end_lunch_end_time_hour = $configData.EngineConfig.end_lunch_end_time_hour
$end_lunch_end_time_minute = $configData.EngineConfig.end_lunch_end_time_minute

$isExp_lunch_end = $configData.EngineConfig.isExp_lunch_end
$lambda_lunch_end = $configData.EngineConfig.lambda_lunch_end
$flipped_lunch_end = $configData.EngineConfig.flipped_lunch_end
$CI_lunch_end = $configData.EngineConfig.CI_lunch_end # confidence interval for normal distribution



# Conditions 
# 1) 
#       t_end - t_start >= min_tend_tstart_diff # e.g. 6 hours
#       This condition is defining the minimum amount of hours the employee is requried to work to get a lunch break
#
# 2)
#        
#       start_lunch_end_time - t_start >= min_work_before_lunch # e.g. 2 hours
#       This condition is defining the minumum amount of hours the employee requried to work before getting a lunch break
#
# 3)    
#       t_end - end_lunch_end_time >= min_work_after_lunch # e.g. 2 hours
#       This condition is defining the minumum amount of hours the employee requried to work after getting a lunch break
#
# 4)
#       t_end_lunch - t_start_lunch >= min_lunch_period # e.g. 15 minutes
#

$min_tend_tstart_diff = $configData.EngineConfig.min_tend_tstart_diff # hours
$min_work_befor_lunch = $configData.EngineConfig.min_work_befor_lunch # hours
$min_work_after_lunch = $configData.EngineConfig.min_work_after_lunch # hours
$min_lunch_period = $configData.EngineConfig.min_lunch_period # minutes
$havingLunch = $configData.EngineConfig.havingLunch


# probability of having a lunch break, if the conditions is not satisfied the probability is Zero
$isVal_probabilityLunch = $configData.EngineConfig.isVal_probabilityLunch
$probabilityLunch_val = $configData.EngineConfig.probabilityLunch_val
$probabilityLunch_min = $configData.EngineConfig.probabilityLunch_min
$probabilityLunch_max = $configData.EngineConfig.probabilityLunch_max


#--------------------------------

# RANDOM LOGOUTs BEFORE LUNCH

# nolb stands for number_of_logouts_before_lunch
$isVal_nolb = $configData.EngineConfig.isVal_nolb
$nolb_val = $configData.EngineConfig.nolb_val
$nolb_min = $configData.EngineConfig.nolb_min
$nolb_max = $configData.EngineConfig.nolb_max

$isExp_nolb = $configData.EngineConfig.isExp_nolb
$lambda_nolb = $configData.EngineConfig.lambda_nolb
$flipped_nolb = $configData.EngineConfig.flipped_nolb

#iltb instance_logout_time_before_lunch for every logout of nlob
$isVal_iltb = $configData.EngineConfig.isVal_iltb
$iltb_val = $configData.EngineConfig.iltb_val # mins
$iltb_min = $configData.EngineConfig.iltb_min # mins
$iltb_max = $configData.EngineConfig.iltb_max # mins
# uniform distribution

# mlttpb stands for maximum_total_logout_time_percentage_before_lunch, which represent the 
# allowed total time to be logged out between t_s and t_lunch_start to in force this rule:
# total time that the user will be logged out will be maximum of 30% of (t_lunch_start - t_s)
$mtltpb = $configData.EngineConfig.mtltpb # percent

# mtbclb stands for minimum_time_between_consecutive_logouts_before_lunch
$isVal_mtbclb = $configData.EngineConfig.isVal_mtbclb
$mtbclb_val = $configData.EngineConfig.mtbclb_val # mins
$mtbclb_min = $configData.EngineConfig.mtbclb_min # mins
$mtbclb_max = $configData.EngineConfig.mtbclb_max # mins
# uniform distribution


# RANDOM LOGOUTs AFTER LUNCH

# nola stands for number_of_logouts_after_lunch
$isVal_nola = $configData.EngineConfig.isVal_nola
$nola_val = $configData.EngineConfig.nola_val
$nola_min = $configData.EngineConfig.nola_min
$nola_max = $configData.EngineConfig.nola_max

$isExp_nola = $configData.EngineConfig.isExp_nola
$lambda_nola = $configData.EngineConfig.lambda_nola
$flipped_nola = $configData.EngineConfig.flipped_nola

#iltb instance_logout_time_after_lunch for every logout of nola
$isVal_ilta = $configData.EngineConfig.isVal_ilta
$ilta_val = $configData.EngineConfig.ilta_val # mins
$ilta_min = $configData.EngineConfig.ilta_min # mins
$ilta_max = $configData.EngineConfig.ilta_max # mins
# uniform distribution

# mtltpa stands for maximu$number_of_users = 2m_total_logout_time_percentage_after_lunch, which represent the 
# allowed total time to be logged out between t_lunch_end and t_e to in force this rule:
# total time that the user will be logged out will be maximum of 30% of (t_e - t_lunch_end)
$mtltpa = $configData.EngineConfig.mtltpa # percent

# mtbcla stands for minimum_time_between_consecutive_logouts_after_lunch
$isVal_mtbcla = $configData.EngineConfig.isVal_mtbcla
$mtbcla_val = $configData.EngineConfig.mtbcla_val # mins
$mtbcla_min = $configData.EngineConfig.mtbcla_min # mins
$mtbcla_max = $configData.EngineConfig.mtbcla_max # mins
#uniform distribution


######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@
#        FUNCTIONS
#@@@@@@@@@@@@@@@@@@@@@@@@

# Implementation of the two functions GenerateTime-Exponential and GenerateTime-Normal,
# these functions will draw random time from the given interval adhering to the given distribution.
function GenerateTime-Exponential {
    param (
        [datetime]$start_time,
        [datetime]$end_time,
        [double]$lambda_val,
        [bool]$flipped = $false
    )

    while ($true) {
        # Generate a random time using exponential distribution
        $u = Get-Random -Minimum 0.0 -Maximum 0.9999
        $t = -[math]::Log(1 - $u) / $lambda_val  # Compute the random value using the inverse CDF of exponential distribution
        
        # Decide whether it is exponential distribution or flipped exponential distribution
        if ($flipped) {
            $t_exp = $end_time - [TimeSpan]::FromSeconds($t)  # Subtract the computed value from the end time
        } else {
            $t_exp = $start_time + [TimeSpan]::FromSeconds($t)  # Add the computed value to the start time
        }
        
        # Ensure the generated time is within the interval [start_time - end_time]
        if ($start_time -le $t_exp -and $t_exp -le $end_time) {
            return $t_exp
        }
    }
}


function GenerateInteger-Exponential {
    param (
        [int]$start_val,
        [int]$end_val,
        [double]$lambda_val,
        [bool]$flipped = $false
    )

    while ($true) {
        # Generate a random value using exponential distribution
        $u = Get-Random -Minimum 0.0 -Maximum 0.9999  # Generate a random number between 0 and 1
        $t = -[math]::Log(1 - $u) / $lambda_val  # Compute the random value using the inverse CDF of exponential distribution

        # Decide whether it is exponential distribution or flipped exponential distribution
        if ($flipped) {
            $random_value = $end_val - [math]::Floor($t)  # Subtract the computed value from the end value
        } else {
            $random_value = $start_val + [math]::Floor($t)  # Add the computed value to the start value
        }

        # Ensure the generated value is within the specified range
        if ($start_val -le $random_value -and $random_value -le $end_val) {
            return $random_value
        }
    }
}


# Approximate normal distribution using Box-Muller transform
function Get-NormalRandom {
    $u1 = Get-Random -Minimum 0.0 -Maximum 1.0
    $u2 = Get-Random -Minimum 0.0 -Maximum 1.0
    $z = [math]::Sqrt(-2 * [math]::Log($u1)) * [math]::Sin(2 * [math]::PI * $u2)
    return $z
}


# Function to run experiments N number of times
function GenerateTime-Normal {
    param (
        [datetime]$start_time,
        [datetime]$end_time,
        [double]$confidence_interval = 2.58
    )

    # Generate a value from the normal distribution
    $mean = ($start_time.Ticks + $end_time.Ticks) / 2  # Mean of the distribution
    # Standard deviation of the distribution with default 99% confidence interval. (confidence_interval = 1.96) for 95% confidence interval.
    $std_dev = ($end_time.Ticks - $start_time.Ticks) / (2 * $confidence_interval) 
    # Generate a value from the normal distribution, ensuring it falls within the interval
    $normal_ticks = $mean + $std_dev * (Get-NormalRandom)  # Generate ticks value from normal distribution

    while ($normal_ticks -lt $start_time.Ticks -or $normal_ticks -gt $end_time.Ticks) {
        $normal_ticks = $mean + $std_dev * (Get-NormalRandom)  # Generate ticks value from normal distribution
    }

    return [datetime]::new($normal_ticks)  # Convert ticks to datetime
}


# Function to run experiments N number of times
function GenerateInteger-Normal {
    param (
        [int]$start_val,
        [int]$end_val,
        [double]$confidence_interval = 2.58
    )

    # Generate a value from the normal distribution
    $mean = ($start_val + $end_val) / 2  # Mean of the distribution
    # Standard deviation of the distribution with default 99% confidence interval. (confidence_interval = 1.96) for 95% confidence interval.
    $std_dev = ($end_val - $start_val) / (2 * $confidence_interval) 
    # Generate a value from the normal distribution, ensuring it falls within the interval
    $normal_value = $mean + $std_dev * (Get-NormalRandom)  # Generate value from normal distribution

    while ($normal_value -lt $start_val -or $normal_value -gt $end_val) {
        $normal_value = $mean + $std_dev * (Get-NormalRandom)  # Generate value from normal distribution
    }

    return [int]$normal_value  # Return the generated integer value
}


function Roll-Dice {
    param (
        [array]$dice # array of tuples [(face, prob_of_face)]
    )

    # Generate a random number between 0 and 1
    $random_number = Get-Random -Minimum 0.0 -Maximum 1.0

    # Determine the side of the dice based on the generated random number and probabilities
    $cumulative_probability = 0
    foreach ($side in $dice) {
        $cumulative_probability += $side[1]  # Accessing the probability from the tuple
        if ($random_number -le $cumulative_probability) {
            $selected_side = $side[0]  # Accessing the side from the tuple
            return $selected_side
        }
    }
}


function Generate-LogoutsPeriods {
    param (
        [int]$total_number_of_logouts,
        [int]$min_val,
        [int]$max_val,
        [int]$max_total_logouts_time
    )

    # Initialize an array to store the generated periods
    $periods = @()

    # Generate random periods until the sum is less than or equal to max_total_logouts_time
    $sum = 0
    for ($i = 0; $i -lt $total_number_of_logouts; $i++) {

        $breaker = 0
        $breaker_flage = $false

        do{
            # Generate a random period between min_val and max_val
            $period = Get-Random -Minimum $min_val -Maximum $max_val
            if($breaker -gt 3000){
                $breaker_flage = $true
                break
            }
            $breaker++
        }while($sum + $period -gt $max_total_logouts_time)
        
        if($breaker_flage){break}
        $periods += $period
        $sum += $period
    }

    # Return the array of periods
    return $periods
}


# mtbcl: minimum_time_between_consecutive_logouts in minutes
function AllocatePoints($t_s, $t_e, $periods, $i, $mtbcl_min, $mtbcl_max) {
    
    if ($i -eq $periods.Count) { return 0, @() }

    $min_consecutive_logouts = Get-Random -Minimum $mtbcl_min -Maximum $mtbcl_max

    $diff = $t_e.AddMinutes(($min_consecutive_logouts)*-2) - $t_s
    if (($diff.hours*60 + $diff.minutes) -lt $periods[$i])
    { 
        return AllocatePoints $t_s $t_e $periods ($i+1) $mtbcl_min $mtbcl_max
    }

    # Loop until we find a suitable random point
    $breaker = 3000
    do {
        $t_r = Get-Random -Minimum $t_s.AddMinutes($min_consecutive_logouts).Ticks -Maximum $t_e.AddMinutes(-$min_consecutive_logouts).Ticks | ForEach-Object { [datetime]::new($_) }
        $var1 = ($t_e.AddMinutes(-($periods[$i]))) - $t_r
        $var2 = $t_r - $t_s
        if($breaker -eq 0) { return 0, @() }
        $breaker--
    } while (($var1.hours*60 + $var1.minutes) -lt $min_consecutive_logouts -or ($var2.hours*60 + $var2.minutes) -lt $min_consecutive_logouts)
    
    # Store the chosen t_r value along with the associated periods[i] value
    $tr_with_period = [PSCustomObject]@{
        Time = $t_r
        Period = $periods[$i]
    }

    # Calculate the scores for both branches
    $score1, $chosen_trs1 = AllocatePoints $t_s $t_r $periods ($i+1) $mtbcl_min $mtbcl_max
    $score2, $chosen_trs2 = AllocatePoints ($t_r.AddMinutes($periods[$i])) $t_e $periods ($i+1) $mtbcl_min $mtbcl_max

    # Choose the maximum score
    if ($score1 -gt $score2) { return (1+$score1), ($chosen_trs1 + $tr_with_period) }
    return (1+$score2), ($chosen_trs2 + $tr_with_period)
}


# $distribution_functions = @({GenerateTime-Exponential}, {GenerateTime-Normal})

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@
#        CODE
#@@@@@@@@@@@@@@@@@@@@@@@@



$sessionsTimingArray = @()


foreach($user_host in $Users_Hosts){


    # Check if the current date is a weekend
    if ((Get-Date).DayOfWeek -eq 'Saturday' -or (Get-Date).DayOfWeek -eq 'Sunday') {
        $isVal_probabilityAbsent = $isVal_probabilityAbsent_weekend
        $probabilityAbsent_val = $probabilityAbsent_val_weekend
        $probabilityAbsent_min = $probabilityAbsent_min_weekend
        $probabilityAbsent_max = $probabilityAbsent_max_weekend
    }



    # Decide whether the employee will be absent or not
    if($isVal_probabilityAbsent){
        $probabilityAbsent = $probabilityAbsent_val
    }
    else{
        $probabilityAbsent = Get-Random -Minimum $probabilityAbsent_min -Maximum $probabilityAbsent_max
    }

    $absence_dice = @(
        ($true, $probabilityAbsent),
        ($false, (1 - $probabilityAbsent))
    )

    # Decide if the user is absent or working based on probabilities
    $isAbsent = Roll-Dice -dice $absence_dice





    # Define the intervals of all the start_time types (start_late, start_ontime, ..)
    $start_time_sae = Get-Date -Hour $start_time_sae_hour -Minute $start_time_sae_minute -Second 0
    $end_time_sae = Get-Date -Hour $end_time_sae_hour -Minute $end_time_sae_minute -Second 0

    $start_time_sal = Get-Date -Hour $start_time_sal_hour -Minute $start_time_sal_minute -Second 0
    $end_time_sal = Get-Date -Hour $end_time_sal_hour -Minute $end_time_sal_minute -Second 0

    $start_time_sl = Get-Date -Hour $start_time_sl_hour -Minute $start_time_sl_minute -Second 0
    $end_time_sl = Get-Date -Hour $end_time_sl_hour -Minute $end_time_sl_minute -Second 0 

    $start_time_son = Get-Date -Hour $start_time_son_hour -Minute $start_time_son_minute -Second 0
    $end_time_son = Get-Date -Hour $end_time_son_hour -Minute $end_time_son_minute -Second 0


    # Define the intervals of all the end_time types (end_ontime, end_late, ...)
    $start_time_eae = Get-Date -Hour $start_time_eae_hour -Minute $start_time_eae_minute -Second 0
    $end_time_eae = Get-Date -Hour $end_time_eae_hour -Minute $end_time_eae_minute -Second 0

    $start_time_eal = Get-Date -Hour $start_time_eal_hour -Minute $start_time_eal_minute -Second 0
    if($end_time_eal_nextDay){
        $end_time_eal = Get-Date -Day ((Get-Date).Day + 1) -Hour $end_time_eal_hour -Minute $end_time_eal_minute -Second 0
    }
    else{
        $end_time_eal = Get-Date -Hour $end_time_eal_hour -Minute $end_time_eal_minute -Second 0
    }

    $start_time_el = Get-Date -Hour $start_time_el_hour -Minute $start_time_el_minute -Second 0
    $end_time_el = Get-Date -Hour $end_time_el_hour -Minute $end_time_el_minute -Second 0

    $start_time_eon = Get-Date -Hour $start_time_eon_hour -Minute $start_time_eon_minute -Second 0
    $end_time_eon = Get-Date -Hour $end_time_eon_hour -Minute $end_time_eon_minute -Second 0


    # Define the intervals of the lunch break start and end times
    $start_lunch_start_time = Get-Date -Hour $start_lunch_start_time_hour -Minute $start_lunch_start_time_minute -Second 0
    $start_lunch_end_time = Get-Date -Hour $start_lunch_end_time_hour -Minute $start_lunch_end_time_minute -Second 0

    $end_lunch_start_time = Get-Date -Hour $end_lunch_start_time_hour -Minute $end_lunch_start_time_minute -Second 0
    $end_lunch_end_time = Get-Date -Hour $end_lunch_end_time_hour -Minute $end_lunch_end_time_minute -Second 0





    # Defining the start time for each type (start_late, start_ontime, ..) and their probabilities
    if($isExp_sae){
        $t_start_abnormal_early = GenerateTime-Exponential -start_time $start_time_sae -end_time $end_time_sae -lambda_val $lambda_sae -flipped $flipped_sae
    }else {
        $t_start_abnormal_early = GenerateTime-Normal -start_time $start_time_sae -end_time $end_time_sae
    }
    if($isVal_prob_t_sae){
        $prob_t_start_abnormal_early = $prob_t_sae_val
    }else{
        $prob_t_start_abnormal_early = Get-Random -Minimum $prob_t_sae_min -Maximum $prob_t_sae_max
    }


    if($isExp_sal){
        $t_start_abnormal_late = GenerateTime-Exponential -start_time $start_time_sal -end_time $end_time_sal -lambda_val $lambda_sal -flipped $flipped_sal
    }else {
        $t_start_abnormal_late = GenerateTime-Normal -start_time $start_time_sal -end_time $end_time_sal
    }
    if($isVal_prob_t_sal){
        $prob_t_start_abnormal_late = $prob_t_sal_val
    }else{
        $prob_t_start_abnormal_late = Get-Random -Minimum $prob_t_sal_min -Maximum $prob_t_sal_max
    }


    if($isExp_sl){
        $t_start_late = GenerateTime-Exponential -start_time $start_time_sl -end_time $end_time_sl -lambda_val $lambda_sl -flipped $flipped_sl
    }else {
        $t_start_late = GenerateTime-Normal -start_time $start_time_sl -end_time $end_time_sl
    }
    if($isVal_prob_t_sl){
        $prob_t_start_late = $prob_t_sl_val
    }else{
        $prob_t_start_late = Get-Random -Minimum $prob_t_sl_min -Maximum $prob_t_sl_max
    }


    if($isExp_son){
        $t_start_ontime = GenerateTime-Exponential -start_time $start_time_son -end_time $end_time_son -lambda_val $lambda_son -flipped $flipped_son
    }else {
        $t_start_ontime = GenerateTime-Normal -start_time $start_time_son -end_time $end_time_son
    }
    $prob_t_start_ontime = 1 - $prob_t_start_abnormal_early - $prob_t_start_abnormal_late - $prob_t_start_late





    # Defining the end time for each type (end_late, end_ontime, ..) and their probabilities
    if($isExp_eae){
        $t_end_abnormal_early = GenerateTime-Exponential -start_time $start_time_eae -end_time $end_time_eae -lambda_val $lambda_eae -flipped $flipped_eae
    }else {
        $t_end_abnormal_early = GenerateTime-Normal -start_time $start_time_eae -end_time $end_time_eae
    }
    if($isVal_prob_t_eae){
        $prob_t_end_abnormal_early = $prob_t_eae_val
    }else{
        $prob_t_end_abnormal_early = Get-Random -Minimum $prob_t_eae_min -Maximum $prob_t_eae_max
    }


    if($isExp_eal){
        $t_end_abnormal_late = GenerateTime-Exponential -start_time $start_time_eal -end_time $end_time_eal -lambda_val $lambda_eal -flipped $flipped_eal
    }else {
        $t_end_abnormal_late = GenerateTime-Normal -start_time $start_time_eal -end_time $end_time_eal
    }
    if($isVal_prob_t_eal){
        $prob_t_end_abnormal_late = $prob_t_eal_val
    }else{
        $prob_t_end_abnormal_late = Get-Random -Minimum $prob_t_eal_min -Maximum $prob_t_eal_max
    }


    if($isExp_el){
        $t_end_late = GenerateTime-Exponential -start_time $start_time_el -end_time $end_time_el -lambda_val $lambda_el -flipped $flipped_el
    }else {
        $t_end_late = GenerateTime-Normal -start_time $start_time_el -end_time $end_time_el
    }
    if($isVal_prob_t_el){
        $prob_t_end_late = $prob_t_el_val
    }else{
        $prob_t_end_late = Get-Random -Minimum $prob_t_el_min -Maximum $prob_t_el_max
    }


    if($isExp_eon){
        $t_end_ontime = GenerateTime-Exponential -start_time $start_time_eon -end_time $end_time_eon -lambda_val $lambda_eon -flipped $flipped_eon
    }else {
        $t_end_ontime = GenerateTime-Normal -start_time $start_time_eon -end_time $end_time_eon
    }
    $prob_t_end_ontime = 1 - $prob_t_end_abnormal_early - $prob_t_end_abnormal_late - $prob_t_end_late





    # Defining the lunch start and end times and the probability of having lunch
    if($isExp_lunch_start){
        $t_start_lunch = GenerateTime-Exponential -start_time $start_lunch_start_time -end_time $start_lunch_end_time -lambda_val $lambda_lunch_start -flipped $flipped_lunch_start
    }else {
        $t_start_lunch = GenerateTime-Normal -start_time $start_lunch_start_time -end_time $start_lunch_end_time -confidence_interval $CI_lunch_start
    }

    if($isExp_lunch_end){
        $t_end_lunch = GenerateTime-Exponential -start_time $end_lunch_start_time -end_time $end_lunch_end_time -lambda_val $lambda_lunch_end -flipped $flipped_lunch_end
    }else {
        $t_end_lunch = GenerateTime-Normal -start_time $end_lunch_start_time -end_time $end_lunch_end_time -confidence_interval $CI_lunch_end
    }

    if($isVal_probabilityLunch){
        $probabilityLunch = $probabilityLunch_val
    }else{
        $probabilityLunch = Get-Random -Minimum $probabilityLunch_min -Maximum $probabilityLunch_max
    }





    # Calculating the nolb and nola (number_of_logouts_before/after lunch)
    if($isExp_nolb){
        $nolb = GenerateInteger-Exponential -start_val $nolb_min -end_val $nolb_max -lambda_val $lambda_nolb -flipped $flipped_nolb
    }else {
        $nolb = GenerateInteger-Normal -start_val $nolb_min -end_val $nolb_max
    }

    if($isExp_nola){
        $nola = GenerateInteger-Exponential -start_val $nola_min -end_val $nola_max -lambda_val $lambda_nola -flipped $flipped_nola
    }else {
        $nola = GenerateInteger-Normal -start_val $nola_min -end_val $nola_max
    }





    # Creating a biased dice from the start times and their probabilites
    $start_time_dice = @(
        ($t_start_abnormal_early, $prob_t_start_abnormal_early),
        ($t_start_abnormal_late, $prob_t_start_abnormal_late),
        ($t_start_late, $prob_t_start_late),
        ($t_start_ontime, $prob_t_start_ontime)
    )


    # Creating a biased dice from the end times and their probabilites
    $end_time_dice = @(
        ($t_end_abnormal_early, $prob_t_end_abnormal_early),
        ($t_end_abnormal_late, $prob_t_end_abnormal_late),
        ($t_end_late, $prob_t_end_late),
        ($t_end_ontime, $prob_t_end_ontime)
    )


    # Rolling the dice to decide the final start time
    $t_start = Roll-Dice -dice $start_time_dice


    # Rolling the dice to decide the final end time
    $t_end = Roll-Dice -dice $end_time_dice


    # If the end_time is less than or equal the start_time then the employee is absent (normally the probability of this should be very small)
    if($t_end -le $t_start){
        $isAbsent = $true
    }





    # Checking the conditions of Lunch break to create the biased dice, if(conditions = False) $probabilityLunch = 0

    # This condition is defining the minimum amount of hours the employee is requried to work to get a lunch break
    if (($t_end.Subtract($t_start)).Hours -lt $min_tend_tstart_diff){$probabilityLunch = 0}

    # This condition is defining the minumum amount of hours the employee requried to work before getting a lunch break
    if (($t_start_lunch.Subtract($t_start)).Hours -lt $min_work_befor_lunch) {$probabilityLunch = 0}

    # This condition is defining the minumum amount of hours the employee requried to work after getting a lunch break
    if (($t_end.Subtract($t_end_lunch)).Hours -lt $min_work_after_lunch) {$probabilityLunch = 0}

    # This condition is defining the minumum amount of lunch break, this condition will also resolve the issure of t_start_lunch > t_end_lunch
    if (($t_end_lunch.Subtract($t_start_lunch).Hours)*60 + ($t_end_lunch.Subtract($t_start_lunch).Minutes) -lt $min_lunch_period) {$probabilityLunch = 0}


    # Creating a biased dice for lunch break
    $lunch_break_dice = @(
        ($true, $probabilityLunch),
        ($false, (1-$probabilityLunch))
    )


    $havingLunch = Roll-Dice -dice $lunch_break_dice

    $sessionsTiming = @()

    if($havingLunch -and  -not $isAbsent){

        # logout periods in minutes before/after lunch (array of minutes)
        $logout_periods_b = @()
        $logout_periods_a = @()
        
        # calcualting differences to apply the maximum percentage rule mentioned in the configuration of random logouts:
        # i.e., total time that the user will be logged out will be maximum of 30% of (t_end - t_end_lunch)
        $diff1 = $t_start_lunch - $t_start
        $diff2 = $t_end - $t_end_lunch
        
        # maximum_total_logout_time_before/after lunch in minutes
        $mtltb = [int](($mtltpb * ($diff1.hours * 60 + $diff1.minutes)) / 100)
        $mtlta = [int](($mtltpa * ($diff2.hours * 60 + $diff2.minutes)) / 100)

        if($isVal_iltb){
            $logout_periods_b = Generate-LogoutsPeriods -total_number_of_logouts $nolb -min_val $iltb_val -max_val $iltb_val -max_total_logouts_time $mtltb

        }else{
            $logout_periods_b = Generate-LogoutsPeriods -total_number_of_logouts $nolb -min_val $iltb_min -max_val $iltb_max -max_total_logouts_time $mtltb
        }


        if($isVal_ilta){
            $logout_periods_a = Generate-LogoutsPeriods -total_number_of_logouts $nola -min_val $ilta_val -max_val $ilta_val -max_total_logouts_time $mtlta

        }else{
            $logout_periods_a = Generate-LogoutsPeriods -total_number_of_logouts $nola -min_val $ilta_min -max_val $ilta_max -max_total_logouts_time $mtlta
        }

        

        # allocate the chosen logout periods in the timeline between t_start and t_start_lunch
        # mx1 refers to the number of logouts that the function "AllocatePoints" was able to fit in the timeline
        # between t_start and t_start_lunch out of "logout_periods_b", without violating the constratins defined in the configurations
        # mtbclb: minimum_time_between_consecutive_logouts_before_lunch
        if($isVal_mtbclb){ 
            $mx1, $logouts_b = AllocatePoints $t_start $t_start_lunch $logout_periods_b 0 $mtbclb_val $mtbclb_val
        }else{
            $mx1, $logouts_b = AllocatePoints $t_start $t_start_lunch $logout_periods_b 0 $mtbclb_min $mtbclb_max
        }

    
        

        # Sort the $trs array based on the start time and end time
        $sortedLogoutsB = @()
        foreach ($tr in $logouts_b) {
            $endTime = $tr.Time.AddMinutes($tr.Period)
            $sortedLogoutsB += [tuple]::Create($tr.Time, $endTime)
        }

        $sortedLogoutsB = $sortedLogoutsB | Sort-Object Item1


        if($isVal_mtbcla){
            $mx2, $logouts_a = AllocatePoints $t_end_lunch $t_end $logout_periods_a 0 $mtbcla_val $mtbcla_val
        }else{
            $mx2, $logouts_a = AllocatePoints $t_end_lunch $t_end $logout_periods_a 0 $mtbcla_min $mtbcla_max
        }

    
        # Sort the $trs array based on the start time and end time
        $sortedLogoutsA = @()
        foreach ($tr in $logouts_a) {
            $endTime = $tr.Time.AddMinutes($tr.Period)
            $sortedLogoutsA += [tuple]::Create($tr.Time, $endTime)
        }

        $sortedLogoutsA = $sortedLogoutsA | Sort-Object Item1

        
        
        $sessionsTiming += $t_start
        foreach ($item in $sortedLogoutsB) {
            $sessionsTiming += $item.Item1
            $sessionsTiming += $item.Item2
        }
        $sessionsTiming += $t_start_lunch
        $sessionsTiming += $t_end_lunch
        foreach ($item in $sortedLogoutsA) {
            $sessionsTiming += $item.Item1
            $sessionsTiming += $item.Item2
        }
        $sessionsTiming += $t_end

    }
    elseif(-not $havingLunch -and -not $isAbsent){

        # logout periods in minutes (array of minutes)
        $logout_periods = @()
        
        # calcualting differences to apply the maximum percentage rule mentioned in the configuration of random logouts:
        # i.e., total time that the user will be logged out will be maximum of 30% of (t_end - t_start)
        $diff1 = $t_end - $t_start
        
        # maximum total logout time in minutes
        $mtlt = [int](($mtltpb * ($diff1.hours * 60 + $diff1.minutes)) / 100)

        if($isVal_iltb){
            $logout_periods = Generate-LogoutsPeriods -total_number_of_logouts $nolb -min_val $iltb_val -max_val $iltb_val -max_total_logouts_time $mtlt

        }else{
            $logout_periods = Generate-LogoutsPeriods -total_number_of_logouts $nolb -min_val $iltb_min -max_val $iltb_max -max_total_logouts_time $mtlt
        }


        if($isVal_mtbcla){ 
            $mx3, $logouts = AllocatePoints $t_start $t_end $logout_periods 0 $mtbclb_val $mtbclb_val
        }else{
            $mx3, $logouts = AllocatePoints $t_start $t_end $logout_periods 0 $mtbclb_min $mtbclb_max
        }

    

        # Sort the $trs array based on the start time and end time
        $sortedLogouts = @()
        foreach ($tr in $logouts) {
            $endTime = $tr.Time.AddMinutes($tr.Period)
            $sortedLogouts += [tuple]::Create($tr.Time, $endTime)
        }

        $sortedLogouts = $sortedLogouts | Sort-Object Item1

        $sessionsTiming += $t_start
        foreach ($item in $sortedLogouts) {
            $sessionsTiming += $item.Item1
            $sessionsTiming += $item.Item2
        }
        $sessionsTiming += $t_end

    }


    $sessionsTimingArray += ,$sessionsTiming

    # foreach ($item in $sessionsTiming) {
    #     Write-Host $item
    # }
    # Write-Host "------------------------------------------"


}







###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################


# Define the log file path
$logFilePath = "C:\Users\Public\BDE_log.txt"
$errorLogFilePath = "C:\Users\Public\BDE_errors.txt"



# Define a global mutex (adjust the name as needed)
# $global:mutex = [System.Threading.Mutex]::new($false, "Global\MyLogFileMutex", [ref]$false)
# $mutex = New-Object System.Threading.Mutex($false, "Global\MyLogFileMutex")



# Check if the log file exists, if not, create it
if (-not (Test-Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File -Force
}
# Check if the error log file exists, if not, create it
if (-not (Test-Path $errorLogFilePath)) {
    New-Item -Path $errorLogFilePath -ItemType File -Force
}



function Log-Message {
    param (
        [string]$message,
        [string]$filePath
    )

    $mutex = New-Object System.Threading.Mutex($false, "MyLogFileMutex")


    # Acquire the mutex to ensure exclusive access to the log file
    $mutex.WaitOne()

    try {
        # Prepare the log entry with timestamp
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "$timestamp - $message"
        
        # Write the log entry to the specified file
        Add-Content -Path $filePath -Value $logEntry
    } finally {
        # Release the mutex
        $mutex.ReleaseMutex()
    }
}



# $sessionsTimingArray = @(
#     # User 1
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),
    
#     # User 2
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),
    
#     # User 3
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),
    
#     # User 4
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),
    
#     # User 5
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),
    
#     # User 6
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),
    
#     # User 7
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),

#     # User 8
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),

#     # User 9
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),

#     # User 10
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     ),

#     # User 11
#     @(
#         [datetime]"10/9/2024 2:03:00 PM",
#         [datetime]"10/9/2024 2:04:00 PM"
#     )
# )




Log-Message -message "<<<<<<<<Employess Sessions for today>>>>>>>>" -filePath $logFilePath


Write-Host "sessionsTimingArray Size: $($sessionsTimingArray.Count)"


$k = 0
foreach ($item in $sessionsTimingArray) {
    Log-Message -message "Sessions of user < $($Users_Hosts[$k][0].username) > on remote host < $($Users_Hosts[$k][1]) >" -filePath $logFilePath
    $k++

    foreach($i in $item){
        Write-Host $i
        Log-Message -message "$i" -filePath $logFilePath
    }
    
    Write-Host "------------------------------------------"
    Log-Message -message "------------------------------------------" -filePath $logFilePath
}



$NumberOfSessions = 0

# Start and terminate sessions based on session timing
for($i = 0 ; $i -lt $Users_Hosts.Count ; $i++) {
    $credential = $Users_Hosts[$i][0]
    $remoteComputer = $Users_Hosts[$i][1]
    $DeptID = $Users_Hosts[$i][2]
    $behavior = $BehaviouralScripts[$DeptID]
    $user_sessions = $sessionsTimingArray[$i]

    # Log the current user and remote computer
    Log-Message -message "Processing user: $($credential.username), remote computer: $remoteComputer" -filePath $logFilePath

    # The Employee is absent
    if($user_sessions.Count -eq 0) {
        Log-Message -message "No sessions for user: $($credential.username)" -filePath $logFilePath
        continue
    }


    $NumberOfSessions++
    
    $jobScript = {
        param ($credential, $remoteComputer, $behavior, $user_sessions)
    
        # Define the log file paths
        $logFilePath = "C:\Users\Public\BDE_log.txt"
        $errorLogFilePath = "C:\Users\Public\BDE_errors.txt"
        

        function Log-Message {
            param (
                [string]$message,
                [string]$filePath
            )

            $mutex = New-Object System.Threading.Mutex($false, "MyLogFileMutex")


            # Acquire the mutex to ensure exclusive access to the log file
            $mutex.WaitOne()

            try {
                # Prepare the log entry with timestamp
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $logEntry = "$timestamp - $message"
                
                # Write the log entry to the specified file
                Add-Content -Path $filePath -Value $logEntry
            } finally {
                # Release the mutex
                $mutex.ReleaseMutex()
            }
        }


        
        $behavior = [ScriptBlock]::Create($behavior) 
        for($j = 0 ; $j -lt $user_sessions.Count ; $j += 2) {
            $start_time = $user_sessions[$j]
            $end_time = $user_sessions[$j+1]

            # Calculate sleep duration until the start session time
            $sleepDuration = ($start_time - (Get-Date)).TotalSeconds
            if ($sleepDuration -gt 0) {
                Log-Message -message "Sleeping for $sleepDuration seconds before starting session for $($credential.username)" -filePath $logFilePath
                Start-Sleep -Seconds $sleepDuration
            }


            
            try {

                # Create a remote session for the current user
                $session = New-PSSession -ComputerName $remoteComputer -Credential $credential -Authentication CredSSP

                # Log the session start
                Log-Message -message "Starting session $($j/2) for $($credential.username) on $remoteComputer at $start_time" -filePath $logFilePath
                
                # Loop until the current time is greater than or equal to session end time
                while ((Get-Date) -lt $end_time) {
                    # Invoke the command with the script block
                    Invoke-Command -Session $session -ScriptBlock $behavior
        
                    # Sleep for a short duration before checking the condition again
                    Start-Sleep -Seconds 2  # Adjust the sleep duration as needed
                }

                # Terminate the session
                Remove-PSSession -Session $session

                # Log the session termination
                Log-Message -message "Ending session $($j/2) for $($credential.username) on $remoteComputer at $end_time" -filePath $logFilePath
            }
            catch{
                # Log the error
                Log-Message -message "ERROR in SESSION $($j/2) of USER $($credential.username) on HOST $($credential.username) with ERROR_MESSAGE: $($_.Exception.Message)" -filePath $errorLogFilePath
                Write-Host "ERROR in SESSION $($j/2) of USER $($credential.username) on HOST $($credential.username) with ERROR_MESSAGE: $($_.Exception.Message)"
            }

        }
        
    }
    

    Start-Job -ScriptBlock $jobScript -ArgumentList $credential, $remoteComputer, $behavior, $user_sessions
}

if($NumberOfSessions){
    # Wait for all jobs to complete
    Get-Job | Wait-Job

    # Retrieve job results if needed
    Get-Job | Receive-Job

    # Remove completed jobs
    Get-Job | Remove-Job
}


# $mutex.Close()
