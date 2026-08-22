# Learning Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Team Learning Item Recommendations

| Workflow Name | Team Learning Item Recommendations |
|---------------|---------------|
| **Code** | XX_TEAM_LEARNING_ITEM_RECOMMENDATIONS |
| **Description** | Displays recommended learning items for a manager audience to assign for the team. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves the top 5 learning item recommendations using `WLF Recommendation Aggregations Lookup` business object and further retrieves the detailed information of these top learning item recommendations using `Learning Item Searches Lookup` business object and displays the list of top learning item recommendations using Message List widget. <br> Fields displayed : Learning Item Title, Learning Item Type, Number of active learners, Learning item rating. <br> Clicking on a row navigates to the assign learning page for the selected learning item. |

#### Workflow : Team Learning Status

| Workflow Name | Team Learning Status |
|---------------|---------------|
| **Code** | XX_TEAM_LEARNING_STATUS |
| **Description** | Displays the summary of a team's learning progress by status in a pie chart to the line manager |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves the team learning status aggregation using `Learning Searches` business object and displays the list of statuses and their percentages in a pie chart using a Chart Widget. |

#### Workflow : Team Overdue Learners

| Workflow Name | Team Overdue Learners |
|---------------|---------------|
| **Code** | XX_TEAM_OVERDUE_LEARNERS |
| **Description** | Displays the list of learners having overdue learning assignments in a line manager's team |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves the list of direct report learners having overdue learning assignments using `Learning Searches` business object and displays the result using Messages List widget. <br> Fields displayed : Learner Profile image, Learner Name, Count of learning items in each status (overdue, required and voluntary) and a badge indicating overdue learning items for the learner |

#### Workflow : Team Overdue Learning Items

| Workflow Name | Team Overdue Learning Items |
|---------------|---------------|
| **Code** | XX_TEAM_OVERDUE_LEARNING_ITEMS |
| **Description** | Displays the list of overdue learning items assigned to a line manager's team members |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction <br> <br> `InitDisplay` - Retrieves the list of learning items sorted by due date using `Learning Searches` business object and displays the list of learning items having overdue learners using a Multi Record widget. <br> Fields displayed : Learning Item Title, Learning Item Type, Number of total learners, Number of Overdue learners, Badge indicating overdue learning items. <br> Clicking on the learning item title invokes the action `displayRecords` with learningItemId as payload. <br><br> `Actions` : <br> `displayRecords` - Receives the learningItemId of the selected learning item in the payload and fetches the list of all learners of the selected learning item. <br> Fields displayed : Learner Name, Learning Assignment Type, Enrollment Status and Overall Status as a badge for overdue items. |
<!-- END GENERATED WORKFLOWS -->
