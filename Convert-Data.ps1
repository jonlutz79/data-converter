# Convert-Data.ps1

<#
REQUIREMENTS:

write code that takes your copy of the provided "input.csv" file
and produces the following output:

1. a. Output to the screen or console that for each record in the
input file shows the display name, a single space, and the internet
email address, in that order; the email address only must be
surrounded by angle brackets. For our purposes, the display
name is defined as the first name followed by a single space,
the middle initial and a space if a middle initial exists,
followed by the last name.

1. b. Also, output to a file named "output.csv", comma-delimited,
producing for each record in the input file a single row
showing, in order, the fields firstname, lastname, and email.
If possible, also include headers on the initial row.

Do not modify the original input.csv file in any way.
#>

<#
The action of Write-Debug is dependent on the value of $DebugPreference
If $DebugPreference = 'Continue' powershell will show the debug message.
If $DebugPreference = 'SilentlyContinue' powershell will not show the message.
If $DebugPreference = 'Stop' powershell will show the message and then halt.
If $DebugPreference = 'Inquire' powershell will prompt the user.
#>
$DebugPreference = 'SilentlyContinue'

# Clear screen
clear-host

$OUTFILENAME = 'output.csv'

# Create output file w/ header row
'firstname,lastname,email' > $OUTFILENAME

# Loop through line of input file (skip header row)
foreach ($inputLine in Get-Content .\input.csv | select-object -skip 1) {
    $hasMiddle = $false

    # DEBUG
    write-debug ('inputLine = ' + $inputLine)

    # Parse line into fields using comma delimiter
    $fields = $inputLine.Split(',')

    # Assign fields (ignore beverage)
    $email = $fields[0]
    $last = $fields[1]
    $first = $fields[2].Split(' ')[0]
    $middle = $fields[2].Split(' ')[1]
    $beverage = $fields[3]

    # DEBUG
    write-debug ('email = ' + $email)
    write-debug ('last = ' + $last)
    write-debug ('first = ' + $first)
    write-debug ('middle = ' + $middle)
    write-debug ('beverage = ' + $beverage)

    # Check if middle name exists
    if (-not [string]::IsNullOrWhiteSpace($middle)) {
        # Middle name exists, assign middle initial
        $hasMiddle = $true
        $mi = $middle.Substring(0, 1)
    }

    # Build output line
    # Format: first [mi] last <email>
    $outputLine = $first + ' ' +
    $(If ($hasMiddle) { $mi + ' ' }) +
    $last +
    ' <' + $email + '>'

    # Write output line to screen
    $outputLine

    # Write output line to file
    # Format: firstname,lastname,email
    ($first + ',' + $last + ',' + $email) >> $OUTFILENAME
}