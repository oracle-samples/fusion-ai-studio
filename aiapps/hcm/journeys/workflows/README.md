# Journeys Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Add to Collection

| Workflow Name | Add to Collection |
|---------------|---------------|
| **Code** | XX_ADD_TO_COLLECTION |
| **Description** | This agent workflow takes information regarding a new task from the user and creates a new task in user collections through the business object. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | Optional REST inputs: `name`, `startDate`, `endDate`, `description`, `taskURL`, `chatHistory`, and `instructions`. The workflow can also collect missing task details conversationally. |
| **Output Parameters** | Returns a success message with a deep link to the created task, a validation error message, or a prompt for any task details that still need to be provided. |

#### Workflow : Display Insights

| Workflow Name | Display Insights |
|---------------|---------------|
| **Code** | XX_DISPLAY_INSIGHTS |
| **Description** | Retrieves tasks from the user's Journey Task Collection and task-status aggregations, generates task deep links, and renders the highest-priority open tasks as an insights message list. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves self collection tasks from the `Journey Task Collections` Business Object and status counts from `Collection Task Aggregations`, then displays up to five tasks, ordered with overdue tasks first, including task name, description, due-status details, a status summary, and a navigation action. Root level description is generated from the status counts from `Collection Task Aggregations`. |

#### Workflow : Overdue Onboarding Team Journeys

| Workflow Name | Overdue Onboarding Team Journeys |
|---------------|---------------|
| **Code** | XX_OVERDUE_ONBOARDING_TEAM_JOURNEYS |
| **Description** | Fetches Enterprise Onboarding and Onboarding team journeys, renders the top journey records as a message list with person image, person name, journey name, person number, and an alert badge for overdue task count for review by manager. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves overdue Enterprise Onboarding and Onboarding team journeys from ``Journey Searches and Aggregation`` Business Object and displays them in a Messages List widget. Fields displayed: person image, person name, journey name, person number, and overdue task count. |

#### Workflow : Overdue Onboarding Team Journeys Tasks

| Workflow Name | Overdue Onboarding Team Journeys Tasks |
|---------------|---------------|
| **Code** | XX_OVERDUE_ONBOARDING_TEAM_JOURNEYS_TASKS |
| **Description** | Fetches overdue Enterprise Onboarding and Onboarding team journey tasks, filters them to the top five tasks, enriches each task with due-date timing details, and renders them as a message list with task name, journey name, owner details, and overdue status for review by manager. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves overdue Enterprise Onboarding and Onboarding team journey tasks from `Journey Searches and Aggregation` Business Object, displays them in a Messages List widget. Fields displayed: task name, journey name, owner details, and due-date or overdue status. |

#### Workflow : Overdue Team Journey Tasks

| Workflow Name | Overdue Team Journey Tasks |
|---------------|---------------|
| **Code** | XX_OVERDUE_TEAM_JOURNEY_TASKS |
| **Description** | Fetches overdue team journey tasks, filters them to the top five tasks, enriches each task with due-date timing details, and renders them as a message list with task name, journey name, owner details, and overdue status for review by manager. If overdue tasks are not present then presents the open tasks which are due ordered by end date. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves the top overdue team journey tasks from `Journey Searches and Aggregation` Business Object, or open tasks ordered by end date when no overdue tasks are present, and displays them in a Messages List widget. Fields displayed: task name, journey name, owner details, and due-date or overdue status. |

#### Workflow : Overdue Team Journeys

| Workflow Name | Overdue Team Journeys |
|---------------|---------------|
| **Code** | XX_OVERDUE_TEAM_JOURNEYS |
| **Description** | Fetches overdue team journeys, renders the top journey records as a message list with person image, person name, journey name, person number, and an alert badge for overdue task count, and provides navigation to the Team Journeys page for viewing more journeys for review by manager. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves overdue team journeys from `Journey Searches and Aggregation` Business Object and displays them in a Messages List widget. Fields displayed: person image, person name, journey name, person number, and overdue task count. Provides a Show Team Journeys action to open the Team Journeys page. |

#### Workflow : Team Journey Aggregation Chart

| Workflow Name | Team Journey Aggregation Chart |
|---------------|---------------|
| **Code** | XX_TEAM_JOURNEY_AGGREGATION_CHART |
| **Description** | Displays team journey category distribution as a pie chart using aggregation data from the Worker Journey business object, with absolute category counts shown below the chart for easy comparison for review by manager. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | Retrieves team journey category aggregations from `Journey Searches and Aggregation` Business Object and displays categories with positive counts as a pie chart and a multi-record table showing the category and its count. |
<!-- END GENERATED WORKFLOWS -->
