## Business Objects
<br>

#### Business Object : **HR Attrition All Reports**

| Code | `ORA_HCM_GLOBALHUMA_XX_HR_ATTRITION_ALL_REPORTS` |
|---------------|---------------|
| Description | Retrieves active, payroll-eligible worker records from a manager's full line-manager reporting hierarchy. Employment and compensation views provide organization, job, location, tenure, assignment, and compensation-quartile data for attrition reports and drilldowns. |

## Functions


#### Function : **findAllReports_compensation**

Description: Retrieves active worker reports from the compensation view, including display name, department, service years, location, job, and compensation quartile.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier of the manager whose full reporting hierarchy is retrieved. |
| `assignmentId` | Assignment identifier of the manager whose full reporting hierarchy is retrieved. |

#### Function : **findAllReports**

Description: Retrieves active worker reports from the employment view, including assignment, business unit, department, employee, effective-start-date, grade, job, legal-employer, location, person, and service-years fields.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier of the manager whose full reporting hierarchy is retrieved. |
| `assignmentId` | Assignment identifier of the manager whose full reporting hierarchy is retrieved. |

---------------

#### Business Object : **HR Attrition Analytic Reports**

| Code | `ORA_HCM_GLOBALHUMA_XX_HR_ATTRITION_ANALYTIC_REPORTS` |
|---------------|---------------|
| Description | Provides the BI session and logical SQL execution functions used by attrition workflows. It authenticates to the BI resources and runs prepared logical SQL payloads for reason, manager, job, location, tenure, summary, and drilldown analytics. |

## Functions


#### Function : **run_sql_query_using_payload**

Description: Submits an OTBI logical SQL request and returns query rows, presentation metadata, and execution details supplied by the BI SQL resource.

| Parameter Name | Description |
|---------------|---------------|
| `runSqlQueryPayload` | JSON request payload containing the logical `sqlQuery`, `outputFormat`, execution options, and BI `sessionId`. |

#### Function : **perform_logon**

Description: Opens a BI session and returns the session token used by subsequent logical SQL requests.

| Parameter Name | Description |
|---------------|---------------|

---------------

#### Business Object : **HR Attrition Person Searches**

| Code | `ORA_HCM_GLOBALHUMA_XX_HR_ATTRITION_PERSON_SEARCHES` |
|---------------|---------------|
| Description | Searches secured worker aggregation data in the My Client Groups context and returns employee-count facets for a supplied business unit name. |

## Functions


#### Function : **get_WorkersCntByBusinessUnitName**

Description: Returns the `BusinessUnitName` facet and employee-count aggregation for workers matching a supplied business unit name.

| Parameter Name | Description |
|---------------|---------------|
| `pBusinessUnitName` | Business unit name used to filter the secured worker aggregation search. |
