# Career Development Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
## Workflows

#### Workflow : My Career Development Tasks

| Workflow Name | My Career Development Tasks |
|---------------|---------------|
| **Code** | XX_MY_CAREER_DEVELOPMENT_TASKS |
| **Description** | Fetches open career development tasks assigned to the logged-in person and displays them as a message list with activity name, journey name, person context, required marker, and due or overdue badge. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow retrieves open career development tasks using `Career Development Journey Searches and Aggregation` business object and displays the result using Message List widget. <br> Fields displayed : Activity Name, Journey Name, Journey Person Name, required marker, and due or overdue badge. |

#### Workflow : My Current Learning

| Workflow Name | My Current Learning |
|---------------|---------------|
| **Code** | XX_MY_CURRENT_LEARNING |
| **Description** | Displays the logged-in learner's current learning assignments with their status, due or completion date, and course details. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | The InitDisplay view retrieves the logged-in learner's current learning assignments using the Learning Searches Business Object. It evaluates each assignment's status and dates, then displays up to five assignments in a message-list widget. Each item shows the learning title, assignment context, a due, completion, withdrawal, rejection, or enrollment date summary, and a status badge. The display is read-only and does not include row actions or links. |

#### Workflow : My Self Developing Skills

| Workflow Name | My Self Developing Skills |
|---------------|---------------|
| **Code** | XX_MY_SELF_DEVELOPING_SKILLS |
| **Description** | Fetches skills currently under development for the logged-in person and displays them as a multi-record widget with skill name, current proficiency, required proficiency, and endorsement count. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | The InitDisplay view derives and validates the logged-in person id from the app user context, retrieves skills currently in development using the Career development skills lookup business object, and displays them in a multi-record widget. Fields displayed: Skill, My Proficiency, Required Proficiency, and Endorsements. |

<!-- END GENERATED WORKFLOWS -->
