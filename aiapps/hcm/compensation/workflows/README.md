# Compensation Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Direct Reports Below Compa Ratio

| Workflow Name | Direct Reports Below Compa Ratio |
|---------------|---------------|
| **Code** | XX_DIRECT_REPORTS_BELOW_COMPA_RATIO |
| **Description** | Displays the list of direct reports with compensation compa ratios below 100 |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves the logged-in person's personId and assignmentId using `LoggedIn Employee Context` business object and then retrieves the compensation details of directs using `My Team Compensation Details Lookup` business object and displays the list of employees with compa ration less than 100 using Message List widget. <br> Fields displayed : Person Image, Person Name, Business title, Salary Range, Current Salary and the Compa ratio. Sorted by Compa ration in ascending order |

#### Workflow : Team Overdue Salary Reviews

| Workflow Name | Team Overdue Salary Reviews |
|---------------|---------------|
| **Code** | XX_TEAM_OVERDUE_SALARY_REVIEWS |
| **Description** | Displays the direct reports, whose next salary review date has passed, helping compensation teams prioritize overdue review follow-up and maintain timely pay governance. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves the logged-in person's personId and assignmentId using `LoggedIn Employee Context` business object and then retrieves the list of compensation details of the team using `My Team Compensation Details Lookup` business object and filters the records whose compensation review date is already passed and displays the result using Messages List widget. <br> Fields displayed : Person Image, Person Name, Business Title, Current Salary and Badge showing days since review is due. |
<!-- END GENERATED WORKFLOWS -->
