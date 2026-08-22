# Talent Management Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Team Unscheduled Check-Ins

| Workflow Name | Team Unscheduled Check-Ins |
|---------------|---------------|
| **Code** | XX_TEAM_UNSCHEDULED_CHECK_INS |
| **Description** | Identifies team members for a logged-in user with last checkin date more that 30 days ago and displays recent check-in status of employees , performance, and potential to help prioritize unscheduled check-ins. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves team check-in data using the Team Unscheduled Check-In Business Object whose PersonId and AssignmentId parameters are obtained from LoggedIn Employee Context Business Object. The retrieved data is then displayed in a Multi Record widget with an executive summary. Each row shows the employee's name, business title, date of last check-in, team performance rating, and talent potential rating; performance and potential are displayed as badges to help the manager prioritize follow-up. The workflow prioritizes employees with check-ins older than 30 days, then those with no check-ins, using lower performance ratings as a tie-breaker. |
<!-- END GENERATED WORKFLOWS -->
