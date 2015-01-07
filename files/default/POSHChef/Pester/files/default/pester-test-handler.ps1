
function Test-Handler {

    <#

    .SYNOPSIS
        Handler to run Pester tests on the server

    .DESCRIPTION
        This is a test handler that uses Pester to invoke tests.

        The default recipe should be include in the run list to ensure that the Pester module is installed and that this
        file is placed into the correct location for the POSHChef handler function to pick it up.

        This script will import the pester module and then run all the tests that are named correctly from the cookbook cache
        location as specified in attributes.

        The tests should also pick up the JSON file of the attributes that this script saves.  This is so that they are able
        to test that the changes that were supposed to be made have indeed been done so.

    #>

    [CmdletBinding()]
    param (

        [hashtable]
        # Hash table containing the status of the run
        $status,

        [hashtable]
        # Attributes for this node
        $attributes
    )

    # Define the return value variable
    $tests = @{
        total = 0
        failed = 0
        duration = 0
    }

    # Import the Pester module
    # As Pester has been installed by Chocolatey build up the path to the module data file
    $module_path = "C:\ProgramData\Chocolatey\lib\pester.{0}\tools\Pester.psd1" -f $attributes.pester.version

    if (Test-Path -Path $module_path) {
        
        Import-Module $module_path

        # Write out the attributes as a JSON file so that the tests can read it in to compare required
        # with actual values
        $json_file = [System.IO.Path]::GetTempFileName()
        Set-Content -Path $json_file -Value ($attributes | ConvertTo-Json -Depth 999)

        # Set a global variable that will contain the path to the json file so that the tests can read the
        # JSON file in
        Set-Variable -Name test_attributes -Scope Global -Value $json_file

        # Run tests
        # create the splat hash for the command
        $splat = @{
            path = "{0}\cookbooks" -f $attributes.poshchef.cache
            passthru = $true
        }

        # Determine if the version of Invoke-Pester supports the Quiet parameter
        if ((Get-Command Invoke-Pester).Parameters.ContainsKey("quiet")) {
            $splat.quiet = $true
        }

        $result = Invoke-Pester @splat

        # Set the number of tests that have failed
        $tests.total = $result.TotalCount
        $tests.failed = $result.FailedCount
        $tests.duration = $result.time.totalseconds

        # Remove the global variable and the temporary file
        Remove-Variable -Name test_attributes -Scope global
        Remove-Item -Path $json_file -Force | Out-Null

    }

    # Return the test_failed to the calling function
    return $tests

}