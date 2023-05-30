##Managing Azure Role Policy aka Role Setting
#Defining Relevant Variables
$Scope = "/subscriptions/<SubscriptionId>"
$AzRole = "<Display Name of Azure Role>" 
$PrimaryApprover = "<ObjectId of Primary Approver>"

#Geting Azure Role Policy for a certain role at a certain scope
$Assignment = Get-AzRoleManagementPolicyAssignment -Scope $scope | Where-Object { $_.roleDefinitionDisplayName -eq $AzRole }
$PolicyId = $Assignment.PolicyId.split('/')[-1]
$Policy = get-AzRoleManagementPolicy -scope $scope -name $policyId


#To change 'isExpirationRequired' policy:
($Policy.Rule |Where-Object{$_.id -eq "Expiration_Admin_Eligibility"}).IsExpirationRequired=$false
Update-AzRoleManagementPolicy -scope $Scope -name $PolicyId -Rule $Policy.rule



#Change 'IsApprovalRequiredSetting' + Primary approver
 ($Policy.Rule |Where-Object{$_.id -eq "Approval_EndUser_Assignment"}).SettingApprovalStage = @( [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.ApprovalStage]@{
           EscalationApprover =  $null;
           EscalationTimeInMinute =  0;
           IsApproverJustificationRequired = $true;
           IsEscalationEnabled = $false;
           TimeOutInDay =  1;
           PrimaryApprover =  [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.UserSet]@{
                   Id = $PrimaryApprover;

           };};)

Update-AzRoleManagementPolicy -scope $Scope -name $PolicyId -Rule $Policy.rule

#Require MFA at assignment
($policy.Rule |Where-Object{$_.id -eq "Enablement_Admin_Assignment"}).EnabledRule = @('Justification','MultiFactorAuthentication')
Update-AzRoleManagementPolicy -scope $Scope -name $PolicyId -Rule $Policy.rule



#For more details on additional Rules possible to change, consult:
#https://learn.microsoft.com/en-us/rest/api/authorization/role-management-policies/update?tabs=HTTP
#https://learn.microsoft.com/en-us/powershell/module/az.resources/update-azrolemanagementpolicy?view=azps-9.7.1&viewFallbackFrom=azps-9.7.0


#-------------------------------------------------------------------------------------------------------------




##Assign Permanent Role Eligibility
#Defining Relevant Variables
$startTime = Get-Date -Format o
$Guid = "<ResultFromGUIDGenerator>" # Get value from: https://guidgenerator.app/
$TargetUser = "<ObjectIdOfTargetUser>"


#Add a Role Eligibility (Permanent)
$AzRoleDefinition= Get-AzRoleDefinition -Name $AzRole -Scope $Scope
$RoleDefinitionId= $Scope + "/providers/Microsoft.authorization/roledefinitions/" + $Szroledefinition.id
New-AzRoleEligibilityScheduleRequest -Name $Guid -Scope $Scope -ExpirationType NoExpiration -PrincipalId $TargetUser -RequestType AdminAssign -RoleDefinitionId $RoleDefinitionId -ScheduleInfoStartDateTime $StartTime


#For more details on how to create Role Eligibility Requests:
#https://learn.microsoft.com/en-us/rest/api/authorization/role-eligibility-schedule-requests
#https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azroleeligibilityschedulerequest?view=azps-9.7.1