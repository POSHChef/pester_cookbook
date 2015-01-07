
# Recipes in POSHChef are built up using the new 'Configuration' keyword from DSC
# The follwing snippet shows how to build up the Default recipe

Configuration Pester_Default {

    <#

    .SYNOPSIS
        Copies the Test handler to the correct location on disk

    #>

    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)]
        [hashtable]
        # Node attributes
        $node
    )

    # Copy the handler script to the server
    CookbookFile ("Pester Tests Handler") {
        Source = "pester-test-handler.ps1"
        Destination = ("{0}\test\{1}" -f $node.POSHChef.handlers_path, "pester-test-handler.ps1")
        Cookbook = "Pester"
        Ensure = "Present"
    }

}
