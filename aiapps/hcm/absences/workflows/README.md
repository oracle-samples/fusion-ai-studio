# Absences Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : My Upcoming Absences

| Workflow Name | My Upcoming Absences |
|---------------|---------------|
| **Code** | XX_MY_UPCOMING_ABSENCES |
| **Description** | This workflow displays the list of existing absences for the employee. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves the upcoming absences for the logged-in employee using `Absence Details` business object and displays the result using Messages List widget <br> Fields displayed : Absence Type, Absence Period, Absence Duration, Absence Status|


#### Workflow : My Team Upcoming Absences

| Workflow Name | My Team Upcoming Absences |
|---------------|---------------|
| **Code** | XX_TEAM_UPCOMING_ABSENCES |
| **Description** | Displays upcoming absence summaries and absence type charts for a line manager's direct reports. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction. <br> <br> `InitDisplay` - Retrieves the list of directs using `HCM GHR Worker Search` business object, then Retrieves and aggregates the list of upcoming absenses by each direct using `Absence Details` business object and displays the result as a table using Multi Record widget. <br> Fields Displayed : Name, Business Title, Absence count, Absence Hours. <br> sSupports an action on clicking Person Name with action `displayRecords` with personId of the selected person in the action playload. <br> <br> `InvokeAction` : <br> `displayRecords` - Receives the personId of the selected person and displays the list of absences for that person. Fields Displayed : Absence Type, Period, Duration, Status|
<!-- END GENERATED WORKFLOWS -->
