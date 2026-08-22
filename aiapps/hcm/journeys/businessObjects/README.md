# Business Objects
<br>

## Business Object : Collection Task Aggregations

| **Name** | Collection Task Aggregations |
|---------------|---------------|
| **Code** | ORA_HCM_JOURNEYS_XX_COLLECTIONTASKAGGREGATIONS |
| **Description** | Collection Task Aggregations provides summarized insights into collection tasks within worker journeys by enabling search-based retrieval of aggregated task data. It supports analysing task statuses to help monitor and manage the collection process effectively through a single operation. |

### Functions

#### Function : get_aggregations

Description : Retrieves aggregated data on collection tasks by posting search criteria to the worker journey task aggregations resource, enabling analysis of task statuses within the collection process.

| **Parameter Name** | **Description** |
|---------------|---------------|
| None | No input parameters required. |

## Business Object : Journey Task Collections

| **Name** | Journey Task Collections |
|---------------|---------------|
| **Code** | ORA_HCM_JOURNEYS_XX_JOURNEYTASKCOLLECTIONS |
| **Description** | Journey Task Collections manages the creation and retrieval of tasks assigned to users within the Journeys product. It supports adding new tasks to user collections and retrieving existing tasks to facilitate task tracking and management throughout the journey process. |

### Functions

#### Function : add_task

Description : Adds a new task with specified details to a particular user's journey task collection, enabling task management within the Journeys business object.

| **Parameter Name** | **Description** |
|---------------|---------------|
| name | Specifies the name of the new task to be added to the user's journey task collection. This required parameter identifies the task and must be provided when creating a task. |
| description | Specifies a detailed summary or explanation of the new task being added to the user's journey task collection. This required parameter provides context about the task and must be included when creating a task. |
| type | Specifies the category or classification of the new task being added to the user's journey task collection. This required parameter identifies the task type and must be provided when creating a task. |
| startDate | Specifies the start date of the new task being added to the user's journey task collection. This required parameter defines when the task begins and must be provided when creating a task. |
| endDate | Specifies the end date of the new task being added to the user's journey task collection. This required parameter defines when the task is scheduled to be completed and must be provided when creating a task. |
| notes | Provides detailed information or comments about the new task being added to the user's journey task collection. This required parameter should be included to describe the task’s purpose or any relevant notes when creating the task. |
| URL | Specifies the URL associated with the new task being added to the user's journey task collection. This required parameter provides a reference link relevant to the task and must be included when creating the task. |

#### Function : get_tasks

Description : Retrieves a list of tasks from the Journey Task Collections, providing detailed information about each task created for user collections. This function supports managing and tracking task creation within the Journeys business process.

| **Parameter Name** | **Description** |
|---------------|---------------|
| None | No input parameters required. |



## Business Object : Journey Searches and Aggregation


| **Name** | Journey Searches and Aggregation |
|---------------|---------------|
| **Code** | ORA_HCM_JOURNEYS_XX_JOURNEYSEARCHESANDAGGREGATION |
| **Description** | Journey Searches and Aggregation enables efficient retrieval and aggregation of worker journey and team task information within the HCM Journeys product. It supports searching and summarizing journey-related records through multiple POST operations, facilitating insights into worker journeys and associated team tasks. |

### Functions

#### Function : get_workerTeamJourneyTasks
Description : Retrieves detailed information about worker team journey tasks based on specified status, categories, and task name filters. This function supports searching and aggregating journey-related team tasks within the HCM Journeys product to provide insights into task progress and assignment. It performs a POST operation on the workerJourneyTaskSearches resource to deliver relevant task data.

| **Parameter Name** | **Description**|
|---------------|---------------|
| Status | Status of the tasks to be searched. |
| Categories | Categories of the tasks to be searched. |
| pTaskName | Name of the tasks to be searched. |

#### Function : getWorkerTeamJourney
Description : Retrieves detailed information about Worker Team Journey Tasks by searching for team journeys based on specified journey status and categories. This function supports filtering and aggregation of journey-related tasks for direct reports within the HCM Journeys product.

| **Parameter Name** | **Description**|
|---------------|---------------|
| Status | Status of the journey to search for. |
| Categories | Categories of the journey to search for. |

#### Function : getWorkerJourneyAggregations
Description : Retrieves aggregated data on worker journeys by searching and summarizing journey records within a team or organization. This function supports filtering and grouping journey information to provide insights into worker activities and associated tasks. It represents a POST operation on the workerJourneyAggregations resource in the Journey Searches and Aggregation business object.

| **Parameter Name** | **Description**|
|---------------|---------------|

## Business Object : Career Development Tasks

| **Name** | Career Development Tasks |
|---------------|---------------|
| **Code** | ORA_HCM_JOURNEYS_XX_CAREERDEVELOPMENTTASKS |
| **Description** | The Career Development Tasks Business Object provides access to open career development journey tasks assigned to the logged-in user. It supports retrieving task records related to individual career growth activities within the HCM Journeys product, enabling users to view and manage their current development responsibilities. |

### Functions

#### Function : getCareerDevelopmentTasks
Description : Fetches the open career development tasks assigned to the logged-in person.

| **Parameter Name** | **Description**|
|---------------|---------------|
