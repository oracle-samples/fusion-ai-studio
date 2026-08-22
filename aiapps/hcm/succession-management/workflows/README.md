# Succession Management Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Bottom Talent Advisor

| Workflow Name | Bottom Talent Advisor |
|---------------|---------------|
| **Code** | XX_BOTTOM_TALENT_ADVISOR |
| **Description** | Represents employees who need assistance, coaching, or development support to improve readiness and succession potential. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | REST trigger inputs: inputMessage (string, scope: JOB), OraMessageHint (string, scope: JOB) |
| **Output Parameters** | This workflow supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Fetches the logged-in employee context, retrieves direct reports, calls `Fetch Performers` for Bottom Performers and to fetch Query Response, and displays employees who may need coaching or development support using the `messageListWidget` in `oraInfoDisplay`. Fields displayed: Employee Name, Performance Level, Performance Level Code badge, and badge priority. Each row is clickable and navigates to the drill-down app using `appNavigate`, with payload values for the selected direct report `pId` and `aId`, plus manager `managerPId` and `managerAId`. <br> <br> `Query` - Routes the user query to `Fetch Performers` and renders the query results table. |


#### Workflow : Compensation Advisor

| Workflow Name | Compensation Advisor |
|---------------|---------------|
| **Code** | XX_COMPENSATION_ADVISOR |
| **Description** | Shows compensation position for direct reports so managers can review salary, quartile, and quintile context. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Calls `Fetch Compensation Details` and renders compensation details for direct reports using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed: Employee Name, Annual Salary, Quartile, and Quintile. Each row is clickable and navigates to the drill-down app using `appNavigate`, with payload values for the selected direct report `pId` and `aId`, plus manager `managerPId` and `managerAId`. <br> <br> `Query` - Fetches logged-in manager context and direct reports, calls `Fetch Compensation Details`, and generates a query response for compensation questions. |


#### Workflow : Compensation Analysis

| Workflow Name | Compensation Analysis |
|---------------|---------------|
| **Code** | XX_COMPENSATION_ANALYSIS |
| **Description** | Shows salary history for the selected worker assignment. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | Uses app context in the following format:<br>`pId` - PersonId of the employee <br> `aId` - AssignmentId of the employee <br> `managerPId` - PersonId of the manager <br> `managerAId` - AssignmentId of the manager |
| **Output Parameters** | This workflow uses app context to identify the selected worker assignment, validates that the selected person is a direct report of the logged-in manager, retrieves salary history using `Compensation Details Lookup`, and displays the compensation history chart for that person using a chart widget in `oraInfoDisplay`. Fields displayed in `initDisplay`: annual salary by year in USD. Invalid or unauthorized context is routed to an error display. |


#### Workflow : Fetch Compensation Details

| Workflow Name | Fetch Compensation Details |
|---------------|---------------|
| **Code** | XX_FETCH_COMPENSATION_DETAILS |
| **Description** | Fetches compensation details for the manager's direct reports as of the requested date. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This child workflow fetches logged-in manager context, retrieves direct reports, gets compensation details for the direct-report assignments using `Compensation Details Lookup`, and returns either initDisplay compensation data or query-specific compensation results. Fields passed for `initDisplay`: Employee Name, Person ID, Assignment ID, Annual Salary, Currency, Quartile, and Quintile. |


#### Workflow : Fetch Performers

| Workflow Name | Fetch Performers |
|---------------|---------------|
| **Code** | XX_FETCH_PERFORMERS |
| **Description** | Fetches direct-report talent ratings so workflows can identify both top performers and employees needing assistance. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This child workflow fetches logged-in manager context, retrieves direct reports, gets talent ratings using `Talent Ratings Lookup`, and routes output for `Top Performers`, `Bottom Performers`, or `Query` responses. Fields passed for `initDisplay`: Employee Name, Person ID, Assignment ID, Performance Level, Performance Level Code, Badge Type, and performer classification for Top Performers or Bottom Performers. |


#### Workflow : Impact of Loss Advisor

| Workflow Name | Impact of Loss Advisor |
|---------------|---------------|
| **Code** | XX_IMPACT_OF_LOSS_ADVISOR |
| **Description** | Retrieves impact of loss details of direct reports, so that managers can assess the business impact if the employee were lost, highlighting criticality, coverage gaps, and potential disruption. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Calls `Succession Overview Agent Team` for impact-of-loss details and renders the impact overview table using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed: Employee Name, Impact, and Impact Score. Each row is clickable and navigates to the drill-down app using `appNavigate`/`drillDownAction`, with payload values for the selected direct report `pId` and `aId`, plus manager `managerPId` and `managerAId`. <br> <br> `Query` - Sends the user query to `Succession Overview Agent Team` and renders impact query results. |


#### Workflow : Impact of Loss Analysis

| Workflow Name | Impact of Loss Analysis |
|---------------|---------------|
| **Code** | XX_IMPACT_OF_LOSS_ANALYSIS |
| **Description** | Displays the impact assessment if the worker were lost, highlighting business criticality and coverage gaps. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | Uses app context in the following format:<br>`pId` - PersonId of the employee <br> `aId` - AssignmentId of the employee <br> `managerPId` - PersonId of the manager <br> `managerAId` - AssignmentId of the manager |
| **Output Parameters** | This workflow uses app context to identify the selected employee and manager context. It supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Validates the selected direct report, retrieves person-level impact-of-loss details using `Succession Details Lookup`, and renders the impact summary using the `messageListWidget` in `oraInfoDisplay`. Fields displayed: Current Impact Rating, impact summary bullets, and severity priority. <br> <br> `Query` - Calls `Succession Overview Agent Team` and renders impact query results. |


#### Workflow : Potential Succession Candidates

| Workflow Name | Potential Succession Candidates |
|---------------|---------------|
| **Code** | XX_POTENTIAL_SUCCESSION_CANDIDATES |
| **Description** | Finds potential successor candidates for a selected employee by comparing role requirements and candidate context. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | REST trigger inputs: pId (string, scope: JOB), aId (string, scope: JOB) |
| **Output Parameters** | This workflow validates the selected person, retrieves job profile attributes and job competencies, fetches peer and direct-report candidate pools, and uses the configured candidate suggestion path to recommend potential successors for the selected employee. Fields passed to the parent action display: selected employee details, candidate Employee Name, Person ID, Assignment ID, Current Job Title, Fit Score, Common Skills, Matching Competencies, and Performance Level. |


#### Workflow : Risk Of Loss Advisor

| Workflow Name | Risk Of Loss Advisor |
|---------------|---------------|
| **Code** | XX_RISK_OF_LOSS_ADVISOR |
| **Description** | Assesses the likelihood that the employee may leave or become unavailable, helping identify retention risk and succession exposure. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Calls `Succession Overview Agent Team` for risk-of-loss details and renders the risk overview table using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed: Employee Name, Risk of Loss, and Risk Score. Each row is clickable and navigates to the drill-down app using `appNavigate`/`drillDownAction`, with payload values for the selected direct report `pId` and `aId`, plus manager `managerPId` and `managerAId`. <br> <br> `Query` - Sends the user query to `Succession Overview Agent Team` and renders risk query results. |


#### Workflow : Risk of Loss Analysis

| Workflow Name | Risk of Loss Analysis |
|---------------|---------------|
| **Code** | XX_RISK_OF_LOSS_ANALYSIS |
| **Description** | Shows the risk-of-loss assessment for the worker, helping identify how likely it is that this person could leave or become unavailable. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | Uses app context in the following format:<br>`pId` - PersonId of the employee <br> `aId` - AssignmentId of the employee <br> `managerPId` - PersonId of the manager <br> `managerAId` - AssignmentId of the manager |
| **Output Parameters** | This workflow uses app context to identify the selected employee and manager context. It supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Validates the selected direct report, retrieves person-level risk-of-loss details using `Succession Details Lookup`, and renders the risk summary using the `messageListWidget` in `oraInfoDisplay`. Fields displayed: Current Risk Rating, risk summary bullets, and severity priority. <br> <br> `Query` - Calls `Succession Overview Agent Team` and renders risk query results. |


#### Workflow : Succession Analysis

| Workflow Name | Succession Analysis |
|---------------|---------------|
| **Code** | XX_SUCCESSION_ANALYSIS |
| **Description** | Shows a selected worker's succession readiness, plan coverage, candidate count, and supporting talent context. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | Uses app context in the following format:<br>`pId` - PersonId of the employee <br> `aId` - AssignmentId of the employee <br> `managerPId` - PersonId of the manager <br> `managerAId` - AssignmentId of the manager |
| **Output Parameters** | This workflow uses app context to identify the selected worker and supports `initDisplay`, `Query`, and `initSubtitle`. <br> <br> `initDisplay` - Validates the selected direct report, retrieves succession details, compensation, and talent ratings, then renders person-level succession details using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed: Name, Job, Annual Salary, Quartile, Quintile, Performance, Risk of Loss, Impact of Loss, Succession Plan Count, Ready Now, Ready in 1-2 yrs, Ready in 3-4 yrs, and No Readiness. <br> <br> `Query` - Calls `Succession Overview Agent Team` and renders query results. <br> <br> `initSubtitle` - Retrieves employee name and job details for subtitle context. |


#### Workflow : Succession Overview Advisor

| Workflow Name | Succession Overview Advisor |
|---------------|---------------|
| **Code** | XX_SUCCESSION_OVERVIEW_ADVISOR |
| **Description** | Provides the main succession planning summary for an employee, combining readiness, risk, impact, and successor information into one overview. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | REST trigger inputs: oraMessageHint (string)<br>Uses app panel name from `$OraPanelName` for additional panel routing|
| **Output Parameters** | This workflow supports `initDisplay`, `Query`, `additionalContent`, `Summary`, `initActions`, `initSubtitle`, and `invokeAction`. <br> <br> `initDisplay` - Fetches logged-in manager context, direct reports, and `Succession Overview Agent Team` data, then renders the initial succession overview using the `multiRecordWidget` in `oraInfoDisplay`. Fields displayed: Employee Name, Job Title, Succession Plans, Ready Now, Ready in 1-2 Years, Ready in 3-4 Years, and No Readiness. <br> <br> Additional panels: `riskOfLoss`, `impactOfLoss`, and `successionInformation` are routed through the additional content path and rendered as separate panel views using `multiRecordWidget` table-style displays in `oraInfoDisplay`. Additional panel fields: `riskOfLoss` displays Employee Name, Risk, and Risk Score; `impactOfLoss` displays Employee Name, Impact, and Impact Score; `successionInformation` displays Employee Name, Job Title, Succession Plans, and readiness columns. <br> <br> `invokeAction` - Handles `successionCandidates`, `viewSuccessorInfo`, `rowNavigate`, `addSuccessor`, and `viewSuccessorDetails`; these paths can call `Potential Succession Candidates`, create succession plans, add incumbents, and render candidate or employee succession details. <br> <br> `Query`, `Summary`, `initActions`, and `initSubtitle` render query answers, summary content, high-priority actions, and employee subtitle context. |


#### Workflow : Succession Overview Agent Team

| Workflow Name | Succession Overview Agent Team |
|---------------|---------------|
| **Code** | XX_SUCCESSION_OVERVIEW_AGENT_TEAM |
| **Description** | Fetches manager-scoped succession, readiness, risk-of-loss, and impact-of-loss data for direct reports. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This child workflow fetches logged-in manager context and direct-report succession data, then routes intent to `successionDetails`, `riskOfLoss`, `impactOfLoss`, or `generalQuery`. It renders manager-scoped succession overview, risk-of-loss, impact-of-loss, or query-shaped responses for parent workflows. Fields passed for `initDisplay`/parent panel rendering: Employee Name, Person ID, Assignment ID, Job Title, Succession Plans, Ready Now, Ready in 1-2 Years, Ready in 3-4 Years, No Readiness, Risk, Risk Score, Impact, and Impact Score. |


#### Workflow : Top Talent Advisor

| Workflow Name | Top Talent Advisor |
|---------------|---------------|
| **Code** | XX_TOP_TALENT_ADVISOR |
| **Description** | Represents employees who are performing strongly and are well-positioned for succession planning or future advancement. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | REST trigger inputs: OraMessageHint (string, scope: JOB) |
| **Output Parameters** | This workflow supports `initDisplay` and `Query`. <br> <br> `initDisplay` - Fetches logged-in manager context, retrieves direct reports, calls `Fetch Performers` for Top Performers, and displays strong performers for succession planning or advancement using the `messageListWidget` in `oraInfoDisplay`. Fields displayed: Employee Name, Performance Level, Performance Level Code badge, and badge priority. Each row is clickable and navigates to the drill-down app using `appNavigate`, with payload values for the selected direct report `pId` and `aId`, plus manager `managerPId` and `managerAId`. <br> <br> `Query` - Routes the user query to `Fetch Performers` and renders the query results table. |

<!-- END GENERATED WORKFLOWS -->
