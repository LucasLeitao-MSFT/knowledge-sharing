#Insta MG Graph Module
Install-Module Microsoft.Graph -Scope CurrentUser

#Connect with the correct scope
Connect-MgGraph -Scopes "Group.Read.All"

#Initializing variables
$groupsWithNestedGroups = @()
$groups = Get-MgGroup -all


#Going through all groups and getting the respective group members.
#If one of group's members is another group, group object is added to the $groupsWithNestedGroups variable. 
foreach ($group in $groups) {
    $members = Get-MgGroupMember -GroupId $group.Id -All
    foreach ($member in $members) {
        if ($member.additionalproperties.'@odata.type' -eq "#microsoft.graph.group") {
            $groupsWithNestedGroups += $group
            break
        Write-Output $member.Id
        }

    }
}

$groupsWithNestedGroups | Select-Object DisplayName, Id





