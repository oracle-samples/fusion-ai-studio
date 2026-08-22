# Business Objects
<br>



## Business Object : Team Unscheduled Check-In


| **Name** | Team Unscheduled Check-In |
|---------------|---------------|
| **Code** | ORA_HCM_TALENT_XX_TEAMUNSCHEDULEDCHECKIN |
| **Description** | Fetches direct reports for a logged-in manager or user, including each employee's last check-in date, performance, potential, and assignment details. |

### Functions

#### Function : getCheckIns
Description : Returns team member check-in details for the given person ID and assignment ID, limited to direct line-manager reports and including display name, assignment name, last check-in date, performance, and potential.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PersonId | Person ID of the logged-in user whose team check-in data should be fetched. |
| AssignmentId | Assignment ID of the logged-in user whose team check-in data should be fetched. |
