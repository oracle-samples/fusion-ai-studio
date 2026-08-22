# Business Objects
<br>


## My Team Compensation Details Lookup

| **Name** | My Team Compensation Details Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_COMP_XX_MYTEAMCOMPENSATIONDETAILSLOOKUP |
| **Description** | Retrieves compensation details for a selected employee's direct reports using the employee selected through the myTeamDetails findByObject action. It uses the person's ID and assignment ID to return compensation information such as salary basis, current salary, annual salary, currency, range position, compa ratio, quartile, quintile, and salary review dates |


### Function : findMyTeamCompensationDetails
Description : Retrieves compensation details for direct reports using the `myTeamDetails` `findByObject` action, based on the person's ID and assignment ID. It returns compensation details for those direct reports.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person ID used to retrieve direct report compensation details |
| pAssignmentId | Assignment ID used to retrieve direct report compensation details |