# Business Objects
<br>



## Business Object : Direct Reports Context


| **Name** | Direct Reports Context |
|---------------|---------------|
| **Code** | ORA_HCM_EMPINFO_XX_DIRECTREPORTSCONTEXT |
| **Description** | Provides the direct reports of a selected employee by using their person and assignment details. It returns the direct-report records required for team analysis and succession planning. |

### Functions

#### Function : getDirectReportsForPerson
Description : Retrieves the direct reports of the selected employee using their person ID and assignment ID. It returns the direct-report records used for team and successor analysis.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person Id of employee for whom direct reports are required to fetch |
| pAssignmentId | Assignment Id of employee for whom direct reports are required to fetch |

## Business Object : Employee Tree Context


| **Name** | Employee Tree Context |
|---------------|---------------|
| **Code** | ORA_HCM_EMPINFO_XX_EMPLOYEETREECONTEXT |
| **Description** | Provides information about a selected employee using the person's ID and assignment ID. It returns the employee's identity, assignment details, job, manager information, and manager assignment details. |

### Functions

#### Function : getAssignmentDetailsForPerson
Description : Retrieves detailed assignment information for a selected employee using the person's ID and assignment ID. It returns details such as assignment name and number, worker type, job, department, business unit, location, grade, manager, primary assignment status, and length of service.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person Id for the given person. |
| pAssignmentId | Assignment Id for the given person. |

#### Function : getManagerDetailsForPerson
Description : Retrieves employee and manager hierarchy information using the person's ID. It returns the employee's identity, assignment details, job, manager information, and manager assignment details.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person Id for a given employee |

## Business Object : LoggedIn Employee Context


| **Name** | LoggedIn Employee Context |
|---------------|---------------|
| **Code** | ORA_HCM_EMPINFO_XX_LOGGEDINEMPLOYEECONTEXT |
| **Description** | Provides the assignment details of the currently logged-in employee by using the current user session. It returns the Person ID, Assignment ID, assignment name, assignment number, and primary assignment status. |

### Functions

#### Function : getLoggedInEmployeeInfo
Description : Retrieves the assignment details of the currently logged-in employee using the current user session. It returns the Person ID, Assignment ID, assignment name, assignment number, and primary assignment status.

| **Parameter Name** | **Description**|
|---------------|---------------|

## Business Object : SuccessionOrgCharts createPayloadInfo


| **Name** | SuccessionOrgCharts createPayloadInfo |
|---------------|---------------|
| **Code** | ORA_HCM_EMPINFO_XX_SUCCESSIONORGCHARTSCREATEPAYLOADINFO |
| **Description** | Provides the employment information required to create a succession plan by using the worker or employment context. It returns the business unit and other employment attributes needed for plan creation. |

### Functions

#### Function : getGradeId
Description : Retrieves grade information using a grade code. It returns the grade ID, grade name, grade code, active status, set code, set name, and effective date range.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pGradeCode | Stores the Grade Code |

#### Function : getJobId
Description : Retrieves job information using a job code. It returns the job ID, job name, job code, active status, job family, manager level, set code, set name, and effective date range.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pJobCode | Stores the Job Code |

#### Function : getpublicWorkers_Jobcode_gradecode
Description : Retrieves worker assignment details using the role holder's assignment context. It returns employee and assignment information, including job code, job name, grade code, grade name, department, business unit, manager, location, worker type, assignment name, and assignment number.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pRoleHolderAId | Assignment Id of employee for whose succession plan is being created |

#### Function : getBusinessUnitId
Description : Retrieves the business unit and other employment attributes required for creating a succession plan by using the worker or employment context.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pRoleHolderpId | Person Id of the role holder |

## Business Object : Compensation Details Lookup


| **Name** | Compensation Details Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_GLOBALPAYR_XX_COMPENSATIONDETAILSLOOKUP |
| **Description** | Provides compensation and salary information for worker assignments using assignment IDs along with an effective date or salary history start date. It returns salary amount, annual salary, currency, effective dates, and salary component details. |

### Functions

#### Function : getCompensationHistory
Description : Retrieves the salary history of a worker assignment using the assignment ID and salary history start date. It returns the salary amount, annual salary, currency, and salary effective date range.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pAssignmentId | To store the assignment id of an employee. |
| pDate | To store the current date. |

#### Function : getCompensationByDateForAssignments
Description : Retrieves compensation details for multiple worker assignments using a list of assignment IDs and an effective date. It returns salary amount, annual salary, currency, effective dates, and salary component details for all matching assignments.

| **Parameter Name** | **Description**|
|---------------|---------------|
| EffectiveDate | Date used to find the salary applicable for the day (yyyy-MM-dd). |
| employees | List of assignmentIds of employees |

#### Function : getCompensationByAssignmentAndDate
Description : Retrieves compensation details for a worker assignment using the assignment ID and an effective date. It returns salary amount, annual salary, currency, effective dates, and salary component details.

| **Parameter Name** | **Description**|
|---------------|---------------|
| AssignmentId | Unique identifier for a worker assignment (finder bind variable). |
| EffectiveDate | Date used to find the salary applicable for the day (yyyy-MM-dd). |

## Business Object : Succession Details Lookup


| **Name** | Succession Details Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_SUCCESSION_XX_SUCCESSIONDETAILSLOOKUP |
| **Description** | Provides succession planning information for direct reports using the manager's assignment ID, with optional filtering by a selected employee. It returns succession plan details, readiness levels, successor candidates, risk of loss, and impact of loss information. |

### Functions

#### Function : getSuccessionForDirectReportsUnderManager
Description : Retrieves succession information for all direct reports using the manager's assignment ID. It returns employee and assignment details along with succession plans, readiness levels, candidate information, and risk and impact assessments.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pAssignmentId | assignment identifier for a given user whose direct reports data needs to be fetched. |

#### Function : getSuccessionForPersonUnderManager
Description : Retrieves succession information for a selected direct report using the manager's assignment ID and the selected employee's person ID. It returns the matching employee's assignment details, succession plans, readiness levels, candidate information, and risk and impact assessments.

| **Parameter Name** | **Description**|
|---------------|---------------|
| assigmentId | Assignment ID for a manager's direct report. |
| pPersonId | Person ID for a manager's direct report. |

## Business Object : Succession Plan Creation


| **Name** | Succession Plan Creation |
|---------------|---------------|
| **Code** | ORA_HCM_SUCCESSION_XX_SUCCESSIONPLANCREATION |
| **Description** | Creates succession plans and adds incumbents by using succession plan payloads and existing plan identifiers. It returns the created plan details and the response after incumbents are added. |

### Functions

#### Function : addIncumbentsToPlan
Description : Adds incumbents to an existing succession plan using the plan ID of the newly created plan. It returns a confirmation that the incumbents have been successfully added.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPlanId | Created Succession Plan Id |

#### Function : createPlan
Description : Creates a succession plan using a payload containing plan, incumbent, owner, and candidate details. It returns the created succession plan along with the generated Plan ID.

| **Parameter Name** | **Description**|
|---------------|---------------|
| IncumbentPersonId | Stores IncumbentPersonId |
| BusinessUnitId | Stores BusinessUnitId |
| StatusCode | Stores StatusCode |
| AccessTypeCode | Stores AccessTypeCode |
| PlanTypeCode | Stores PlanTypeCode |
| PlanName | Stores PlanName |
| Description | Stores Description |
| OwnerPersonId | Stores OwnerPersonId |
| OwnerTypeCode | Stores OwnerTypeCode |
| EnableAlertFlag | Stores EnableAlertFlag |
| OwnerSourceCode | Stores OwnerSourceCode |
| OwnerSourceKey | Stores OwnerSourceKey |
| CandidatePersonId | Stores CandidatePersonId |
| CandidateType | Stores CandidateType |
| CandidateReadinessCode | Stores CandidateReadinessCode |
| CandidateStatusCode | Stores CandidateStatusCode |
| CandidateSourceCode | Stores CandidateSourceCode |
| CandidateSourceKey | Stores CandidateSourceKey |
| SourceCode | Stores SourceCode |
| SourceKey | Stores SourceKey |

## Business Object : Job Competencies Lookup


| **Name** | Job Competencies Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TALENT_XX_JOBCOMPETENCIESLOOKUP |
| **Description** | Provides job profile and competency requirements for successor-fit comparisons by using a selected employee's person ID, followed by the profile ID and section ID. It returns the job profile details and competency requirements with proficiency and weight information. |

### Functions

#### Function : getProfileIdbyPersonId
Description : Retrieves the job profile of a selected employee using the person's ID. It returns the profile ID, profile code, and profile name.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person id of the role holder |

#### Function : getCompetenciesForJobProfile
Description : Retrieves the competency requirements for a job profile using the profile ID and section ID. It returns competency details, including competency IDs, names, proficiency ratings, weights, and minimum weight values.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pProfileId | Job Profile Id |
| pSectionId | Section id (Fixed to 9901) |

## Business Object : Skills and Competencies Lookup


| **Name** | Skills and Competencies Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TALENT_XX_SKILLSANDCOMPETENCIESLOOKUP |
| **Description** | Provides the skills and competencies of a selected employee by using the employee's person information. It returns skill and competency details, including proficiency information, for successor-fit comparisons. |

### Functions

#### Function : getCompetenciesForPerson
Description : Retrieves the competencies of a selected employee using the employee's person information. It returns competency details along with proficiency information used for successor comparisons.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person Id of the Employee |

#### Function : getPublicSkillsForPerson
Description : Retrieves the public skills of a selected employee using the person's ID. It returns employee profile details along with public skill records, including skill name, skill group, proficiency level code, and proficiency level.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | PersonId of the employee |

## Business Object : Talent Ratings Lookup


| **Name** | Talent Ratings Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TALENT_XX_TALENTRATINGSLOOKUP |
| **Description** | Provides talent and performance ratings for employees using either a single person ID or a list of person IDs. It returns performance ratings, talent scores, career potential, impact-of-loss ratings, and risk-of-loss ratings. |

### Functions

#### Function : getTalentRatingsForAll
Description : Retrieves talent ratings for multiple employees using a list of person IDs. It returns performance ratings, talent scores, career potential, impact-of-loss ratings, and risk-of-loss ratings for all matching employees.

| **Parameter Name** | **Description**|
|---------------|---------------|
| personIds | List of Person Ids |

#### Function : getTalentRatingsForPerson
Description : Retrieves talent ratings for a selected employee using the person's ID. It returns performance ratings, talent scores, career potential, impact-of-loss ratings, and risk-of-loss ratings.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pPersonId | Person Id of the employee |
