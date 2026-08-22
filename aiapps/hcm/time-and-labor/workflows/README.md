# Time and Labor Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Team Under Reported Time Cards

| Workflow Name | Team Under Reported Time Cards |
|---------------|---------------|
| **Code** | XX_TEAM_UNDER_REPORTED_TIME_CARDS |
| **Description** | Shows the list of people who reported less hours in their timecard than their scheduled hours. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow calculates the last 30-day time card date range, validates it, retrieves time cards where reported hours are less than scheduled hours using `Time Card Searches Lookup`, and displays the result using the `messageListWidget` in `oraInfoDisplay`. Fields displayed include person name, time period start and end dates, status, scheduled hours, reported hours, and hours difference badge. |


#### Workflow : Time Card Exception Summary

| Workflow Name | Time Card Exception Summary |
|---------------|---------------|
| **Code** | XX_TIME_CARD_EXCEPTION_SUMMARY |
| **Description** | Shows time card exception types, counts, aggregate scheduled hours, reported hours, and absence hours with row actions for detail drilldown. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction. <br> <br> `InitDisplay` - Calculates the last 30-day time card date range, retrieves exception aggregations using `Time Card Exception Aggregations Lookup`, retrieves matching exception time cards using `Time Card Exception Searches Lookup`, and displays exception summary rows using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed include exception, count, total scheduled hours, total reported hours, and total absence hours. Action name: `viewExceptionTimeCards`. Trigger: clicking the Exception cell in a summary row; the app sends `OraMessageHint = InvokeAction`. Payload passed:  `exceptionCode`, `exceptionName`, and `timeCards` for the selected exception. <br> <br> `InvokeAction` - Parses `OraAction`, filters the selected exception payload, and displays the detailed time cards for that exception using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed include person name, time period dates, status, exception, scheduled hours, absence hours, reported hours, and total hours. |


#### Workflow : Time Card Status Aggregation

| Workflow Name | Time Card Status Aggregation |
|---------------|---------------|
| **Code** | XX_TIME_CARD_STATUS_AGGREGATION |
| **Description** | Displays the distribution of line manager team's time card statuses and missing person time cards for the last 30 days in a pie chart. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow calculates the last 30-day time card date range, validates it, retrieves status aggregations using `Time Card Status Aggregations Lookup`, retrieves missing-person time card aggregations using `Missing Person Time Card Aggregations Lookup`, combines the results into chart-ready slices, and displays a pie chart using the `chartWidget` in `oraInfoDisplay`. Fields displayed include status counts, missing-person time card count, percentages, and summary insights. |

<!-- END GENERATED WORKFLOWS -->
