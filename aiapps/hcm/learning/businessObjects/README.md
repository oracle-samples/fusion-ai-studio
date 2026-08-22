# Business Objects
<br>


## Learning Searches

| **Name** | Learning Searches |
|---------------|---------------|
| **Code** | ORA_HCM_LEARNING_XX_LEARNINGSEARCHES |
| **Description** | The Learning Searches Business Object enables advanced searching and aggregation of learning records within the LEARNING product. It supports retrieving summarized data by learner, learning item, and enrollment status, as well as detailed searches of learning item records. With its focus on aggregation and search operations, it facilitates comprehensive insights into learning activities and related enrollment data. |


### Function : learner_aggregations
Description : This business object function gives learning aggregations by learner.

| **Parameter Name** | **Description**|
|---------------|---------------|

### Function : learning_item_aggregations
Description : This business object function gives learning aggregations by learning item.

| **Parameter Name** | **Description**|
|---------------|---------------|

### Function : enrollment_status
Description : This business object function give aggregation of status of all enrollments in my team.

| **Parameter Name** | **Description**|
|---------------|---------------|

### Function : learning_record_searches
Description : This business object fucntion searches learning item records by learning item id.

| **Parameter Name** | **Description**|
|---------------|---------------|
| learningItemId | Primary key identifier for the learning item id to search the learning records for a learning item |

### Function : get_current_learning
Description : Fetches the logged-in learner's current learning assignments and their status, due dates, and course details.

| **Parameter Name** | **Description**|
|---------------|---------------|
