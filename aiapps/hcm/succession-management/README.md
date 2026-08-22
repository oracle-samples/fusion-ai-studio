# Succession Planning

## Functional Solution Approach

The Succession Planning workspace is an AI-powered Oracle HCM experience for managers who need a single place to review succession coverage, talent strength, retention risk, role criticality, and compensation context for their direct teams. The solution is implemented through a parent workspace, Succession Readiness Workspace, and a person-level drill-down workspace, Person Succession Readiness Workspace.

The parent workspace presents manager-facing panels backed by AI Studio workflows that gather relevant HCM context, render business-facing views, and support direct follow-up through row actions or natural-language queries. The drill-down workspace receives selected employee context and presents focused person-level panels for succession readiness, risk of loss, impact of loss, and compensation history.

## Design Principles

| Principle | Functional meaning |
|---|---|
| Single pane | Bring succession readiness, performance, risk, impact, and compensation into one workspace so managers do not need to move across separate tools for the first review. |
| Progressive disclosure | Show a summary first, then let managers open employee-level detail only when they need deeper context. |
| AI-driven triage | Use workflow-backed panels to surface coverage gaps, higher-risk employees, high-impact roles, and performance-based talent groups. |
| Action-oriented | Connect insight to action through employee drill-down, successor suggestions, candidate review, and successor creation. |

## Panels in Scope

| Panel | Primary goal |
|---|---|
| Succession Overview | Review succession plan availability, successor readiness, and bench-strength gaps across direct reports. |
| Risk of Loss | Identify direct reports with elevated retention risk who may require manager attention. |
| Impact of Loss | Highlight employees whose departure could create meaningful business impact. |
| Top Performers | Surface higher-performing employees to support recognition, growth, and succession planning. |
| Talent Needing Assistance | Identify employees with lower performance ratings who may need coaching, support, or development planning. |
| Compensation Summary | Review compensation details for direct reports to support balanced talent and pay decisions. |
| Succession Information | Review person-level succession, performance, risk, impact, and compensation attributes in one drill-down view. |
| Risk of Loss Drill-Down | Review an individual employee's current risk rating and short explanatory summary. |
| Impact of Loss Drill-Down | Review an individual employee's impact rating and short explanatory summary. |
| Compensation History Drill-Down | Review an employee's annual salary trend over time. |

## Succession Overview Panel

### Goal

The Succession Overview panel helps managers identify which direct reports have succession coverage, which employees have no succession plan, and which covered roles have no ready-now successor. It is the main triage panel for successor readiness and follow-up action.

### Data Sources

| Data source | Functional use |
|---|---|
| Succession details lookup | Provides direct report identity, assignment, succession plan count, readiness categories, and candidate readiness data. |
| Logged-in employee context | Identifies the manager context used to fetch direct reports and pass manager identifiers through row actions. |
| Compensation details lookup | Adds current salary, quartile, and quintile context when a manager reviews employee detail. |
| Talent ratings lookup | Adds performance, risk of loss, and impact of loss context for an employee detail view. |
| Employee tree context | Supplies employee and manager hierarchy details used during detail and candidate review flows. |
| Succession plan creation services | Build and submit the payload needed to create a succession plan and add incumbents. |
| Supporting workflow | Potential Succession Candidates retrieves ranked successor candidates when the manager asks for suggestions. |

### User Flow

| Step | Result |
|---|---|
| 1 | Manager opens the workspace and sees succession coverage for direct reports. |
| 2 | Manager expands the panel and sees supporting risk, impact, and succession information views. |
| 3 | Manager selects an employee and reviews employee-level succession, compensation, and talent information. |
| 4 | Manager asks for successor suggestions when coverage is missing or incomplete. |
| 5 | Manager reviews a recommended candidate before confirming. |
| 6 | Manager confirms the successor and the succession plan creation flow runs. |

#### Step 1 - Overview Panel Initial Display

Succession Overview Advisor routes the initial display request to a succession overview workflow call with the `successionDetails` message. The rendered list focuses on direct reports and highlights plan availability and readiness gaps.

| Column | Content | Source |
|---|---|---|
| Employee Name | Direct report name. | Succession details lookup output. |
| Job Title | Current assignment or role title. | Succession details lookup output. |
| Succession plan availability | Whether the employee has one or more succession plans. | Succession plan count. |
| Readiness categories | Ready Now, Ready in 1-2 Years, Ready in 3-4 Years, and No Readiness candidate counts or names where available. | Succession readiness data. |

Employees without succession plans are configured as high-priority actions, and rows pass the selected employee and manager context into follow-up actions.

#### Step 2 - Expanded Panel View

The expanded panel uses route handling inside the overview advisor to show three related views without leaving the workspace.

| Expanded view | Functional content | Source |
|---|---|---|
| Impact Of Loss | Employee name, impact level, and impact score. | `impactOfLoss` workflow message. |
| Risk Of Loss | Employee name, risk level, and risk score. | `riskOfLoss` workflow message. |
| Succession Information | Employee succession summary and readiness coverage. | `successionDetails` workflow message. |

#### Step 3 - Review Employee Details

When the manager opens an employee row, the workflow parses the row payload and gathers succession, salary, and talent rating information for the selected person.

| Field | Content | Source |
|---|---|---|
| Name | Selected employee name. | Succession details lookup. |
| Assignment | Current assignment or job. | Succession details lookup. |
| Annual Salary | Current annual salary. | Compensation details lookup. |
| Quartile and Quintile | Compensation positioning. | Compensation details lookup. |
| Performance | Current performance rating. | Talent ratings lookup. |
| Risk of Loss | Employee risk rating. | Talent ratings lookup. |
| Impact of Loss | Employee impact rating. | Talent ratings lookup. |
| Succession Plan Count | Number of succession plans. | Succession details lookup. |
| Readiness Categories | Candidate counts and names by readiness horizon. | Succession details lookup. |

#### Step 4 - Suggest Successor

When successor suggestions are requested, the overview advisor invokes Potential Succession Candidates with the selected employee and manager context. The result is parsed and displayed as a candidate list.

| Column | Content | Source |
|---|---|---|
| Name | Candidate name. | Potential succession candidates workflow output. |
| Current Job Title | Candidate current role. | Potential succession candidates workflow output. |
| Fit Score | Candidate fit score as returned by the workflow. | Potential succession candidates workflow output. |
| Action | Candidate review or add-successor action. | Configured app actions. |

#### Step 5 - Review Candidate

Candidate review combines successor candidate data with succession, salary, and talent rating context for the selected candidate. The generated detail view includes candidate identity, job, fit score, common skills, and matching competencies when those fields are present in the candidate payload.

#### Step 6 - Confirm And Create

The successor creation path builds a succession plan payload, retrieves employee profile information needed for plan creation, calls the create-plan service, and adds incumbents to the created plan. The configured app action also includes a refresh step so the overview can show updated succession information after the action completes.

## Risk of Loss Panel

### Goal

The Risk of Loss panel helps managers see which direct reports may require retention attention. It shows employee risk levels and risk scores in a concise table and supports employee drill-down through row actions.

### Data Sources

| Data source | Functional use |
|---|---|
| Logged-in employee context | Establishes the manager context for the panel. |
| Succession overview agent team | Provides risk-of-loss records for direct reports when called with the `riskOfLoss` message. |

### User Flow

| Step | Manager action or system response | Result |
|---|---|---|
| 1 | Manager views the Risk of Loss panel. | Direct reports appear with risk indicators and scores. |
| 2 | Manager selects an employee. | The row action passes employee and manager context to the drill-down workspace. |
| 3 | Manager asks a question. | The workflow routes the question to the same supporting agent team and renders query results. |

### Initial Display

| Column | Content | Source |
|---|---|---|
| Employee Name | Direct report name. | Risk details workflow output. |
| Risk of Loss | Low, medium, high, or equivalent rating returned by the workflow. | Succession overview agent team. |
| Risk Score | Numeric score returned with the risk record. | Succession overview agent team. |

## Impact of Loss Panel

### Goal

The Impact of Loss panel shows which direct reports are most critical from a continuity perspective. It helps managers understand where a departure could have higher operational or business impact.

### Data Sources

| Data source | Functional use |
|---|---|
| Logged-in employee context | Establishes the manager context for the panel. |
| Succession overview agent team | Provides impact-of-loss records for direct reports when called with the `impactOfLoss` message. |

### User Flow

| Step | Manager action or system response | Result |
|---|---|---|
| 1 | Manager views the Impact of Loss panel. | Direct reports appear with impact indicators and scores. |
| 2 | Manager selects an employee. | The row action passes employee and manager context to the drill-down workspace. |
| 3 | Manager asks a question. | The workflow routes the question to the supporting agent team and renders query results. |

### Initial Display

| Column | Content | Source |
|---|---|---|
| Employee Name | Direct report name. | Impact details workflow output. |
| Impact | Low, medium, high, or equivalent impact rating returned by the workflow. | Succession overview agent team. |
| Impact Score | Numeric impact score returned with the record. | Succession overview agent team. |

## Top Performers Panel

### Goal

The Top Performers panel surfaces higher-performing direct reports so managers can recognize strong talent and consider growth, retention, and succession opportunities.

### Data Sources

| Data source | Functional use |
|---|---|
| Logged-in employee context | Establishes the manager context. |
| Succession details lookup | Provides direct report context before performer filtering. |
| Performer workflow | Fetch Performers is called with the `Top Performers` message. |

### User Flow

| Step | Manager action or system response | Result |
|---|---|---|
| 1 | Manager views the Top Performers panel. | The panel displays direct reports returned by the top-performer workflow path. |
| 2 | Manager selects an employee. | The row action passes employee and manager context to the drill-down workspace. |
| 3 | Manager asks a question. | The workflow routes the question to `XX_FETCH_PERFORMERS` and renders query results. |

### Initial Display

| Column | Content | Source |
|---|---|---|
| Employee Name | Employee returned by the top-performer path. | Performer workflow output. |
| Performance Label | Performance label displayed as part of the item subtitle. | Performer workflow output. |
| Performance Score | Performance code displayed as a badge. | Performer workflow output. |

## Talent Needing Assistance Panel

### Goal

The Talent Needing Assistance panel gives managers visibility into employees who may need coaching, support, training, or performance follow-up.

### Data Sources

| Data source | Functional use |
|---|---|
| Logged-in employee context | Establishes the manager context. |
| Succession details lookup | Provides direct report context before performer filtering. |
| Performer workflow | Fetch Performers is called with the `Bottom Performers` message. |

### User Flow

| Step | Manager action or system response | Result |
|---|---|---|
| 1 | Manager views the Talent Needing Assistance panel. | The panel displays direct reports returned by the bottom-performer workflow path. |
| 2 | Manager selects an employee. | The row action passes employee and manager context to the drill-down workspace. |
| 3 | Manager asks a question. | The workflow routes the question to `XX_FETCH_PERFORMERS` and renders query results. |

### Initial Display

| Column | Content | Source |
|---|---|---|
| Employee Name | Employee returned by the bottom-performer path. | Performer workflow output. |
| Performance Label | Performance label displayed as part of the item subtitle. | Performer workflow output. |
| Performance Score | Performance level code displayed as a badge. | Performer workflow output. |

## Compensation Summary Panel

### Goal

The Compensation Summary panel gives managers a consolidated view of compensation details for direct reports, including current salary and pay positioning.

### Data Sources

| Data source | Functional use |
|---|---|
| Logged-in employee context | Establishes manager context for direct report lookup. |
| Succession details lookup | Provides direct report assignments used to request compensation details. |
| Compensation workflow | Fetch Compensation Details provides salary detail and query responses. |

### User Flow

| Step | Manager action or system response | Result |
|---|---|---|
| 1 | Manager views the Compensation Summary panel. | The panel displays salary and positioning details for direct reports. |
| 2 | Manager selects an employee. | The row action passes employee and manager context to the drill-down workspace. |
| 3 | Manager asks a question. | The workflow routes the query to `XX_FETCH_COMPENSATION_DETAILS`. |

### Initial Display

| Column | Content | Source |
|---|---|---|
| Employee Name | Direct report name. | Compensation details workflow output. |
| Annual Salary | Current salary. | Compensation details workflow output. |
| Quartile | Quartile positioning. | Compensation details workflow output. |
| Quintile | Quintile positioning. | Compensation details workflow output. |

## Succession Information Drill-Down

### Goal

The Succession Information drill-down gives the manager a consolidated employee-level view combining succession, compensation, performance, risk, and impact context.

### Data Sources

| Data source | Functional use |
|---|---|
| App context from selected row | Supplies selected employee and manager identifiers. |
| Succession details lookup | Provides person-level succession coverage and readiness information. |
| Compensation details lookup | Provides current annual salary and pay positioning. |
| Talent ratings lookup | Provides performance, risk, and impact ratings. |
| Employee tree context | Provides subtitle identity and job information. |

### User Flow

| Step | Result |
|---|---|
| 1 | The drill-down workspace receives selected employee context. |
| 2 | Succession Analysis fetches succession, salary, and talent rating records. |
| 3 | The view renders a two-column detail display with readiness categories and supporting talent context. |

### Initial Display

| Field | Content | Source |
|---|---|---|
| Name | Selected employee name. | Succession details lookup. |
| Job | Selected employee assignment or role. | Succession details lookup. |
| Annual Salary | Current salary. | Compensation details lookup. |
| Quartile and Quintile | Pay positioning. | Compensation details lookup. |
| Performance | Current performance rating. | Talent ratings lookup. |
| Risk of Loss | Current risk rating. | Talent ratings lookup. |
| Impact of Loss | Current impact rating. | Talent ratings lookup. |
| Succession Plan Count | Number of succession plans. | Succession details lookup. |
| Ready Now, Ready in 1-2 yrs, Ready in 3-4 yrs, No Readiness | Candidate counts and names by readiness category. | Succession details lookup. |

## Risk of Loss Drill-Down

### Goal

The Risk of Loss drill-down gives managers a focused explanation of the selected employee's current attrition-risk assessment.

### Data Sources

| Data source | Functional use |
|---|---|
| App context from selected row | Supplies selected employee and manager identifiers. |
| Succession details lookup | Provides person-level risk-of-loss rating and numeric rating. |
| Succession overview agent team | Handles natural-language follow-up questions. |

### User Flow

| Step | Result |
|---|---|
| 1 | The drill-down receives selected employee context. |
| 2 | Risk of Loss Analysis fetches the selected employee's succession details. |
| 3 | The workflow renders a message-list summary with current rating and explanatory bullets. |

### Initial Display

| Element | Content | Source |
|---|---|---|
| Current Rating | Current risk-of-loss rating. | Succession details lookup. |
| Summary | Concise explanation of the assessment without displaying numeric values. | Risk analysis rendering prompt. |
| Employee image | Person image URL when the person identifier is available. | Selected employee context. |

## Impact of Loss Drill-Down

### Goal

The Impact of Loss drill-down gives managers a focused explanation of the selected employee's business criticality and potential continuity impact.

### Data Sources

| Data source | Functional use |
|---|---|
| App context from selected row | Supplies selected employee and manager identifiers. |
| Succession details lookup | Provides person-level impact-of-loss rating and numeric rating. |
| Succession overview agent team | Handles natural-language follow-up questions. |

### User Flow

| Step | Result |
|---|---|
| 1 | The drill-down receives selected employee context. |
| 2 | Impact of Loss Analysis fetches the selected employee's succession details. |
| 3 | The workflow renders a message-list summary with current rating and explanatory bullets. |

### Initial Display

| Element | Content | Source |
|---|---|---|
| Current Rating | Current impact-of-loss rating. | Succession details lookup. |
| Summary | Concise explanation of the impact assessment without displaying numeric values. | Impact analysis rendering prompt. |
| Employee image | Person image URL when the person identifier is available. | Selected employee context. |

## Compensation History Drill-Down

### Goal

The Compensation History drill-down shows annual salary progression over time for the selected employee.

### Data Sources

| Data source | Functional use |
|---|---|
| App context from selected row | Supplies selected employee assignment context. |
| Compensation history lookup | Retrieves dated compensation records for the selected assignment. |
| Compensation history transformation | Converts dated salary ranges into annual values when salary data exists for those years. |

### User Flow

| Step | Result |
|---|---|
| 1 | The drill-down receives selected employee context. |
| 2 | Compensation Analysis fetches compensation history for the selected assignment. |
| 3 | The workflow renders a line chart for annual salary values. |

### Chart Elements

| Element | Content | Source |
|---|---|---|
| X-Axis | Year labels derived from compensation history. | Compensation history transformation. |
| Y-Axis | Annual salary values. | Compensation history lookup. |
| Data Points | One salary value per year when salary history covers that year. | Compensation history transformation. |
| Trend Line | Line chart connecting annual salary values. | Chart rendering prompt. |

## Artifact Guide Index

| Artifact | Type | Role |
| --- | --- | --- |
| Person Succession Readiness Workspace | App | Person-level drill-down workspace with succession, risk, impact, and compensation panels. |
| Succession Readiness Workspace | App | Parent workspace with manager-facing Succession Planning panels. |
| Bottom Talent Advisor | Workflow | Parent-panel workflow for the Talent Needing Assistance panel. |
| Compensation Advisor | Workflow | Parent-panel workflow for the Compensation Summary panel. |
| Compensation Analysis | Workflow | Person-level drill-down workflow for the selected employee compensation-history line chart. |
| Fetch Compensation Details | Workflow | Supporting workflow that retrieves current compensation details for direct reports and handles compensation-related follow-up questions. |
| Fetch Performers | Workflow | Supporting workflow that filters direct reports into top performer and talent-needing-assistance lists based on current performance ratings. |
| Impact of Loss Advisor | Workflow | Parent-panel workflow for the Impact of Loss panel. |
| Impact of Loss Analysis | Workflow | Person-level drill-down workflow for the selected employee impact-of-loss explanation. |
| Potential Succession Candidates | Workflow | Supporting workflow that ranks possible successor candidates for a selected employee using profile, skills, competency, and manager-context data. |
| Risk Of Loss Advisor | Workflow | Parent-panel workflow for the Risk of Loss panel. |
| Risk of Loss Analysis | Workflow | Person-level drill-down workflow for the selected employee risk-of-loss explanation. |
| Succession Analysis | Workflow | Person-level drill-down workflow for consolidated succession, compensation, performance, risk, and impact details. |
| Succession Overview Advisor | Workflow | Main parent-panel workflow for succession coverage, expanded views, employee detail, successor candidate suggestions, and successor creation. |
| Succession Overview Agent Team | Workflow | Shared workflow used by parent-panel advisors to return succession details, risk of loss, and impact of loss records for direct reports. |
| Top Talent Advisor | Workflow | Parent-panel workflow for the Top Performers panel. |

Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at https://oss.oracle.com/licenses/upl/

<!-- BEGIN GENERATED WORKFLOWS -->
## Workflows

#### Workflow : Bottom Talent Advisor

| Workflow Name | Bottom Talent Advisor |
|---------------|---------------|
| **Code** | XX_BOTTOM_TALENT_ADVISOR |
| **Description** | Represents employees who need assistance, coaching, or development support to improve readiness and succession potential. |
| **Input Parameters** | inputMessage (string, scope: JOB)<br>OraMessageHint (string, scope: JOB) |
| **Output Parameters** | None specified |

#### Workflow : Compensation Advisor

| Workflow Name | Compensation Advisor |
|---------------|---------------|
| **Code** | XX_COMPENSATION_ADVISOR |
| **Description** | Shows compensation position for direct reports so managers can review salary, quartile, and quintile context. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Compensation Analysis

| Workflow Name | Compensation Analysis |
|---------------|---------------|
| **Code** | XX_COMPENSATION_ANALYSIS |
| **Description** | Shows salary history for the selected worker assignment. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Fetch Compensation Details

| Workflow Name | Fetch Compensation Details |
|---------------|---------------|
| **Code** | XX_FETCH_COMPENSATION_DETAILS |
| **Description** | Fetches compensation details for the manager's direct reports as of the requested date. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Fetch Performers

| Workflow Name | Fetch Performers |
|---------------|---------------|
| **Code** | XX_FETCH_PERFORMERS |
| **Description** | Fetches direct-report talent ratings so workflows can identify both top performers and employees needing assistance. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Impact of Loss Advisor

| Workflow Name | Impact of Loss Advisor |
|---------------|---------------|
| **Code** | XX_IMPACT_OF_LOSS_ADVISOR |
| **Description** | Retrieves impact of loss details of direct reports, so that managers can assess the business impact if the employee were lost, highlighting criticality, coverage gaps, and potential disruption. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Impact of Loss Analysis

| Workflow Name | Impact of Loss Analysis |
|---------------|---------------|
| **Code** | XX_IMPACT_OF_LOSS_ANALYSIS |
| **Description** | Displays the impact assessment if the worker were lost, highlighting business criticality and coverage gaps. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Potential Succession Candidates

| Workflow Name | Potential Succession Candidates |
|---------------|---------------|
| **Code** | XX_POTENTIAL_SUCCESSION_CANDIDATES |
| **Description** | Finds potential successor candidates for a selected employee by comparing role requirements and candidate context. |
| **Input Parameters** | pId (string, scope: JOB)<br>aId (string, scope: JOB) |
| **Output Parameters** | None specified |

#### Workflow : Risk Of Loss Advisor

| Workflow Name | Risk Of Loss Advisor |
|---------------|---------------|
| **Code** | XX_RISK_OF_LOSS_ADVISOR |
| **Description** | Assesses the likelihood that the employee may leave or become unavailable, helping identify retention risk and succession exposure. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Risk of Loss Analysis

| Workflow Name | Risk of Loss Analysis |
|---------------|---------------|
| **Code** | XX_RISK_OF_LOSS_ANALYSIS |
| **Description** | Shows the risk-of-loss assessment for the worker, helping identify how likely it is that this person could leave or become unavailable. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Succession Analysis

| Workflow Name | Succession Analysis |
|---------------|---------------|
| **Code** | XX_SUCCESSION_ANALYSIS |
| **Description** | Shows a selected worker's succession readiness, plan coverage, candidate count, and supporting talent context. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Succession Overview Advisor

| Workflow Name | Succession Overview Advisor |
|---------------|---------------|
| **Code** | XX_SUCCESSION_OVERVIEW_ADVISOR |
| **Description** | Provides the main succession planning summary for an employee, combining readiness, risk, impact, and successor information into one overview. |
| **Input Parameters** | oraMessageHint (string) |
| **Output Parameters** | None specified |

#### Workflow : Succession Overview Agent Team

| Workflow Name | Succession Overview Agent Team |
|---------------|---------------|
| **Code** | XX_SUCCESSION_OVERVIEW_AGENT_TEAM |
| **Description** | Fetches manager-scoped succession, readiness, risk-of-loss, and impact-of-loss data for direct reports. |
| **Input Parameters** | None specified |
| **Output Parameters** | None specified |

#### Workflow : Top Talent Advisor

| Workflow Name | Top Talent Advisor |
|---------------|---------------|
| **Code** | XX_TOP_TALENT_ADVISOR |
| **Description** | Represents employees who are performing strongly and are well-positioned for succession planning or future advancement. |
| **Input Parameters** | OraMessageHint (string, scope: JOB) |
| **Output Parameters** | None specified |
<!-- END GENERATED WORKFLOWS -->
