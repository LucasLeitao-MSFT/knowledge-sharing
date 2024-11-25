#Connect to MgGraph with the correct scopes
Connect-MgGraph -Scopes "User.Read.All","Group.Read.All","AuditLog.Read.All"


# Retrieve all members of the group
$groupId = '<Group_ObjectID>'
$groupMembers = Get-MgGroupMember -GroupId $groupId

# Loop through each member and retrieve additional properties
foreach ($member in $groupMembers) {
    $user = Get-MgUser -UserId $member.Id -Select id, displayName, userPrincipalName,SigninActivity
    # Output or process the user information as needed
    Write-Output "User ID: $($user.Id)"
    Write-Output "Display Name: $($user.DisplayName)"
    Write-Output "User Principal Name: $($user.UserPrincipalName)"
    Write-Output "Last SignInDateTime: $($user.signinactivity.lastSignInDateTime)"
}


