# Human Resources Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Team Document Records Near Expiry

| Workflow Name | Team Document Records Near Expiry |
|---------------|---------------|
| **Code** | XX_TEAM_DOCUMENT_RECORDS_NEAR_EXPIRY |
| **Description** | Helps you monitor document records in your team that are expiring within the next 30 days by displaying the employee name, document type, document name, and expiration date. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay`. <br> <br> `InitDisplay` - Retrieves document records for team members that are due to expire within the next 30 days using the `Document Records Expiring Lookup` business object and displays them using a Message List widget. Fields displayed: Employee Name, Document Name, Document Type, Attachments Count, Last Update Date, Expiration Date, and Employee Image when available. It also provides a brief summary of the expiring records. |

#### Workflow : Worker About Me

| Workflow Name | Worker About Me |
|---------------|---------------|
| **Code** | XX_WORKER_ABOUTME |
| **Description** | Retrieves talent-profile information for the person in the app context, or for the current logged-in user when no person is selected. It shows the person's About Me information, including Expertise, Tags, and Interests, and answers questions concisely using only the available talent-profile data. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay` and `Query`. <br> <br> `InitDisplay` - Retrieves the person's About Me talent-profile information using the `Talent Person Profiles` business object and displays the result using a Multi Card widget. Fields displayed: Summary, Expertise, Interest, and Tags. <br> <br> `Query` - Retrieves the person's About Me talent-profile information using the `Talent Person Profiles` business object and answers the user's question concisely using only the available About Me data. |


#### Workflow : Worker Card

| Workflow Name | Worker Card |
|---------------|---------------|
| **Code** | XX_WORKER_CARD |
| **Description** | Retrieves employment and contact information for the person in the app context, or for the current logged-in user when no person is selected. It provides a concise summary of the person's name, role, organization, manager, work location, email, phone, communication accounts, and office address when available. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay`. <br> <br> `InitDisplay` - Retrieves worker identity, primary assignment, work email, phone, and other communication accounts using the `HCM GHR Employment` and `HCM GHR Worker Contact Details` business objects, then returns a concise employment and contact summary. Fields displayed when available: Name, Job or Position, Grade, Department or Business Unit, Manager, Location, Work Email, Work Phone, Other Communication Accounts, and Office Address. The result is displayed as concise text and does not include a widget or actions. |



#### Workflow : Worker Directs

| Workflow Name | Worker Directs |
|---------------|---------------|
| **Code** | XX_WORKER_DIRECTS |
| **Description** | Retrieves direct reports for the person in the app context, or for the current logged-in user when no person is selected. It shows each direct report's name and assignment, direct and total report counts, and the reporting hierarchy. It also answers questions using only the available reporting data and lets users select a direct report or view additional reports. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay`, `Query`, `InvokeAction`, and `AdditionalContent`. <br> <br> `InitDisplay` - Retrieves the selected worker's primary assignment, direct reports, direct-report count, all-reports count, and reporting hierarchy using the `HCM GHR Employment`, `Person Direct Reports V2`, and `HCM GHR Worker Contact Details` business objects. It displays up to five direct reports using a Message List widget. Fields displayed: Name and Assignment Name. The widget also displays the Direct Reports count, All Reports count, and Reporting Hierarchy. Clicking a direct report invokes the `selectDirect` action with the selected person's `personId`. <br> <br> `Query` - Retrieves the selected worker's direct-report and reporting-hierarchy data and answers the user's question concisely using only that data. <br> <br> `InvokeAction` : <br> `selectDirect` - Receives the selected person's `personId` and refreshes the application context for that person. <br> <br> `AdditionalContent` : <br> `allDirects` - Retrieves the remaining direct reports using the `Person Direct Reports V2` business object and displays them using a Message List widget. Fields displayed: Name and Assignment Name. |

#### Workflow : Worker Document Record Expiry

| Workflow Name | Worker Document Record Expiry |
|---------------|---------------|
| **Code** | XX_WORKER_DOCUMENT_RECORD_EXPIRY |
| **Description** | Retrieves document records for the logged-in user that are due to expire within the next 30 days, displaying the document type, document name, expiration date, and expiry date. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay`. <br> <br> `InitDisplay` - Retrieves document records for the current logged-in user that are due to expire within the next 30 days using the `Document Records Expiring Lookup` business object and displays them using a Message List widget. Fields displayed: Document Name, Document Type, Attachments Count, Last Update Date, and Expiration Date. It also provides a brief summary of the expiring records. |

#### Workflow : Worker Representatives

| Workflow Name | Worker Representatives |
|---------------|---------------|
| **Code** | XX_WORKER_REPS |
| **Description** | Retrieves representatives for the person in the app context, or for the current logged-in user when no person is selected. It shows each representative's name, responsibility, and image when available. It also answers questions using only the available representative data and lets users select a representative or view the complete representative list. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay`, `Query`, `InvokeAction`, and `AdditionalContent`. <br> <br> `InitDisplay` - Retrieves the selected person's primary assignment using the `HCM GHR Employment` business object, then retrieves up to two representatives using the `Representatives Search V2` business object and displays them using a Message List widget. Fields displayed: Representative Name and Responsibility Name. Clicking a representative invokes the `selectRepresentative` action with the selected representative's `personId`. <br> <br> `Query` - Retrieves the selected person's representatives and answers the user's question concisely using only the available representative data. <br> <br> `InvokeAction` : <br> `selectRepresentative` - Receives the selected representative's `personId` and refreshes the application context for that person. <br> <br> `AdditionalContent` : <br> `allRepresentatives` - Retrieves the full representatives list using the `Representatives Search V2` business object and displays it using a Message List widget. Fields displayed: Representative Name and Responsibility Name. |

#### Workflow : Worker Search

| Workflow Name | Worker Search |
|---------------|---------------|
| **Code** | XX_WORKER_SEARCH |
| **Description** | Searches for workers and representatives and provides About Me and feedback information based on the user's request. It supports searches by name, phone, email, location, department, position, job, manager, organization, reporting relationship, and time details, with filters and paging. It also lets users select a person, apply a result category, and view more results. This workflow is exposed to Ask Oracle in Agentic Apps. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `Query` and `InvokeAction`. <br> <br> `Query` - Interprets the Ask Oracle request and supports worker searches, representative searches, About Me summaries, and feedback summaries using the `HCM GHR Worker Search`, `HCM GHR Employment`, `Representatives Search V2`, `Talent Person Profiles`, and `Person Notes V2` business objects. Worker and representative results are displayed using a Message List widget. Clicking a worker or representative invokes the `selectPerson` action with the selected person's `personId`. Query results also expose the `selectFacet` action for applying a result category or filter and the `showMore` action for retrieving additional results. Worker fields displayed: Name, Job, Assignment, Department, Location, and Person Image. Representative fields displayed: Name, Responsibility Name, Responsibility Type, and Person Image. About Me and feedback requests return concise summaries using only the available profile or note data. Worker search supports name, phone, work email, location, city, country, department, position, job, manager, team, organization, direct reports, all reports, time range, time zone, current user, combined filters, grouped result categories, local-time filtering, paging, unresolved terms, retries after removing the latest filter, and no-result handling. Representative search supports Benefits, Human Resources, and Payroll representative requests. <br> <br> `InvokeAction` : <br> `selectFacet` - Applies the selected result category or filter and refreshes the relevant results. <br> `selectPerson` - Receives the selected person's `personId` and refreshes the application context for that person. <br> `showMore` - Retrieves the next page of worker or representative results while preserving the current filters and application context. |

#### Workflow : Worker Location Weather

| Workflow Name | Worker Location Weather |
|---------------|---------------|
| **Code** | XX_WORKER_WRK_LOC_WEATHER |
| **Description** | Retrieves the work location for the person in the app context, or for the current logged-in user when no person is selected. It shows the worker's location, current weather, timezone, and local time, with helpful weather and day-or-night icons when available. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow supports `InitDisplay`. <br> <br> `InitDisplay` - Retrieves the selected worker's primary assignment and work location using the `HCM GHR Employment` business object, determines the current weather, timezone, and local time for that location, and displays the result as a compact Weather Card. Fields displayed: Location, Weather, Timezone, and Local Time. Weather and day-or-night icons are included when the corresponding values are available. |


#### Workflow : Address Details of Worker

| Workflow Name | Address Details of Worker |
|---------------|---------------|
| **Code** | XX_WORKER_ADDRESS_BY_PERSON |
| **Description** | Returns the addresses for a worker using person identifier first, or person number when person identifier is not provided. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string)<br>personNumber (string) |
| **Output Parameters** | The workflow returns an array of address objects. Each object has the fields AddressId (integer), EffectiveStartDate (date), EffectiveEndDate (date), AddressLine1 (string), AddressLine2 (string), AddressLine3 (string), AddressLine4 (string), TownOrCity (string), Region1 (string), Region2 (string), Region3 (string), Country (string), PostalCode (string), LongPostalCode (string), AddlAddressAttribute1 (string), AddlAddressAttribute2 (string), AddlAddressAttribute3 (string), AddlAddressAttribute4 (string), AddlAddressAttribute5 (string), Building (string), FloorNumber (string), CreatedBy (string), CreationDate (datetime), LastUpdatedBy (string), LastUpdateDate (datetime), PersonAddrUsageId (integer), AddressType (string), ValidationStatusCode (string), Provider (string), Longitude (number), Latitude (number), and PrimaryFlag (boolean). |

#### Workflow : Assignment History

| Workflow Name | Assignment History |
|---------------|---------------|
| **Code** | XX_WORKER_ASG_HISTORY_BY_PERSON |
| **Description** | A workflow agent that takes person id or assignment id and returns assignment history update records. When person id is provided, it resolves the worker primary assignment from assignment rows before fetching assignment history. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | assignmentId (string)<br>personId (string) |
| **Output Parameters** | The workflow returns an array of assignment-history objects. Each object has the fields AssignmentId (integer), EffectiveEndDate (date), EffectiveStartDate (date), EffectiveLatestChange (string), EffectiveSequence (integer), AssignmentNumber (string), AssignmentName (string), JobId (integer), GradeId (integer), PositionId (integer), LocationId (integer), DepartmentId (integer), LegalEntityId (integer), WorkerCategory (string), AssignmentCategory (string), AssignmentStatusTypeId (integer), PersonId (integer), PersonNumber (string), PersonDisplayName (string), ManagerDisplayName (string), PeriodOfServiceId (integer), WorkerNumber (string), ManagerId (integer), ManagerAssignmentId (integer), ActionId (integer), Action (string), ActionReason (string), ActionReasonId (integer), ActionOccurrenceId (integer), ActionTypeCode (string), BusinessUnit (string), Businessunitid (integer), Department (string), LegalEmployer (string), OrganizationId (integer), Location (string), Job (string), Position (string), Grade (string), GradeLadderId (integer), Gradeladder (string), GradeStepId (integer), Gradestep (string), CollectiveAgreementId (integer), CollectiveAgreement (string), BargainingUnitCode (string), ContractId (integer), IsManager (string), DateProbationEnd (date), ProbationPeriod (number), ProbationUnit (string), NormalHours (number), Frequency (string), WorkAtHome (string), TimeNormalFinish (string), TimeNormalStart (string), NoticePeriod (integer), AssignmentStatusType (string), ExpenseCheckAddress (string), InternalBuilding (string), InternalFloor (string), InternalLocation (string), InternalMailstop (string), InternalOfficeNumber (string), SystemPersonType (string), FullPartTime (string), PermanentTemporary (string), GspEligibility (string), UnionId (integer), SeniorityBasis (string), OvertimePeriod (integer), LastWorkingDate (date), TerminationDate (date), StandardHours (number), StandardFrequency (string), StandardAnnualWorkingDuration (number), AnnualWorkingDurationUnits (string), AnnualWorkingDuration (number), AnnualWorkingRatio (number), AdjustedFTE (number), Headcount (number), FTE (number), PeopleGroupId (integer), IdFlexNumber (integer), DateStart (date), BargainingUnitName (string), and LabourUnionMember (string). |

#### Workflow : Employment Information

| Workflow Name | Employment Information |
|---------------|---------------|
| **Code** | XX_WORKER_ASG_INFO_BY_PERSON |
| **Description** | Returns assignment and employment information for the supplied person identifier. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string) |
| **Output Parameters** | The workflow returns an array of assignment objects. Each object has the fields AssignmentId (integer), AssignmentNumber (string), AssignmentName (string), LegalEmployerName (string), StartDate (date), PrimaryFlag (boolean), PrimaryAssignmentFlag (boolean), WorkerType (string), WorkerNumber (string), WorkAtHomeFlag (boolean), FullPartTime (string), ManagerName (string), BusinessUnitName (string), DepartmentName (string), JobCode (string), JobName (string), PositionCode (string), PositionName (string), LocationCode (string), LocationName (string), GradeCode (string), GradeName (string), InternalBuilding (string), InternalFloor (string), InternalOfficeNumber (string), InternalMailstop (string), LocationAddressLine1 (string), LocationAddressLine2 (string), LocationAddressLine3 (string), LocationAddressLine4 (string), LocationRegion1 (string), LocationRegion2 (string), LocationRegion3 (string), LocationTownOrCity (string), LocationPostalCode (string), LocationCountry (string), LocationLongPostalCode (string), LocationTimezoneCode (string), LocationSingleLineAddress (string), LocationMultiLineAddress (string), LengthOfServiceYears (integer), LengthOfServiceMonths (integer), LengthOfServiceDays (integer), MarkedAsFavoriteFlag (boolean), DateProbationEnd (date), and ProjectedStartDate (date). |

#### Workflow : Number of Workers by Business Unit

| Workflow Name | Number of Workers by Business Unit |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_BU |
| **Description** | Returns the number of workers associated with the supplied business unit name. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | businessUnitName (string) |
| **Output Parameters** | The workflow returns a number representing the matching worker count. |

#### Workflow : Number of Workers by Department

| Workflow Name | Number of Workers by Department |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_DEPT |
| **Description** | Returns the number of workers associated with the supplied department name. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | departmentName (string) |
| **Output Parameters** | The workflow returns a number representing the matching worker count. |

#### Workflow : Number of Workers by Grade

| Workflow Name | Number of Workers by Grade |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_GRD |
| **Description** | A workflow agent that takes a grade as input and returns the count of employees with that grade. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | gradeName (string)<br>gradeCode (string) |
| **Output Parameters** | The workflow returns a number representing the matching worker count. |

#### Workflow : Number of Workers by Job

| Workflow Name | Number of Workers by Job |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_JOB |
| **Description** | Returns the number of workers associated with the supplied job code or job name. When both inputs are provided, the workflow uses job code first. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | jobCode (string)<br>jobName (string) |
| **Output Parameters** | The workflow returns a number representing the matching worker count. |

#### Workflow : Number of Workers by Location

| Workflow Name | Number of Workers by Location |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_LOCATION |
| **Description** | A workflow agent that takes a location as input and returns the count of employees at that location. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | locationCode (string)<br>locationName (string) |
| **Output Parameters** | The workflow returns a number representing the matching worker count. |

#### Workflow : Number of Workers by Position

| Workflow Name | Number of Workers by Position |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_POS |
| **Description** | A workflow agent that takes a position as input and returns the count of employees with that position. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | positionCode (string)<br>positionName (string) |
| **Output Parameters** | The workflow returns a number representing the matching worker count. |

#### Workflow : Count of Workers by Location, Job, Position, Grade and Business Unit

| Workflow Name | Count of Workers by Location, Job, Position, Grade and Business Unit |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_BY_WORKSTR |
| **Description** | Agent team which gives count of Workers by Location, Job, Position, Grade and Business Unit |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | LocationName (string)<br>LocationCode (string)<br>JobName (string)<br>JobCode (string)<br>GradeName (string)<br>GradeCode (string)<br>DepartmentName (string)<br>PositionName (string)<br>PositionCode (string)<br>BusinessUnitName (string) |
| **Output Parameters** | The workflow returns a string containing the matching worker count after all supplied filters are applied. |

#### Workflow : Count of Workers by Grade

| Workflow Name | Count of Workers by Grade |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_GRD_BY_MGR |
| **Description** | Returns worker counts grouped by grade for the supplied manager person identifier. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | managerId (string) |
| **Output Parameters** | The workflow returns an array of aggregation objects. Each object has the fields value (string) and count (number). |

#### Workflow : Count of Workers by Job

| Workflow Name | Count of Workers by Job |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_JOB_BY_MGR |
| **Description** | Returns worker counts grouped by job for the supplied manager person identifier. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | managerId (string) |
| **Output Parameters** | The workflow returns an array of aggregation objects. Each object has the fields value (string) and count (number). |

#### Workflow : Count of Workers by Location

| Workflow Name | Count of Workers by Location |
|---------------|---------------|
| **Code** | XX_WORKER_CNT_LOC_BY_MGR |
| **Description** | Returns worker counts grouped by location for the supplied manager person identifier. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | managerId (string) |
| **Output Parameters** | The workflow returns an array of aggregation objects. Each object has the fields value (string) and count (number). |

#### Workflow : Email Details of Worker

| Workflow Name | Email Details of Worker |
|---------------|---------------|
| **Code** | XX_WORKER_EMAIL_BY_PERSON |
| **Description** | Returns the email addresses for a worker using person identifier first, or person number when person identifier is not provided. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string)<br>personNumber (string) |
| **Output Parameters** | The workflow returns an array of email objects. Each object has the fields EmailAddressId (integer), EmailType (string), EmailAddress (string), FromDate (date), ToDate (date), CreatedBy (string), CreationDate (datetime), LastUpdatedBy (string), LastUpdateDate (datetime), and PrimaryFlag (boolean). |

#### Workflow : Workers by Business Unit

| Workflow Name | Workers by Business Unit |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_BU |
| **Description** | Lists workers associated with the supplied business unit identifier or business unit name. When both inputs are provided, the workflow uses business unit identifier first. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | businessUnitId (string)<br>businessUnitName (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : Workers by Department

| Workflow Name | Workers by Department |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_DEPT |
| **Description** | Lists workers associated with the supplied department name. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | departmentName (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : Workers by Grade

| Workflow Name | Workers by Grade |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_GRD |
| **Description** | A workflow agent that takes a grade as input and lists all workers associated with that grade. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | gradeId (string)<br>gradeName (string)<br>gradeCode (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : Workers by Job

| Workflow Name | Workers by Job |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_JOB |
| **Description** | Lists workers associated with the supplied job identifier, job code, or job name. When multiple job inputs are provided, the workflow uses job identifier first, then job code, then job name. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | jobId (string)<br>jobCode (string)<br>jobName (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : Workers By Location

| Workflow Name | Workers By Location |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_LOCATION |
| **Description** | A workflow agent that takes a work location as input and lists all workers assigned to that location. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | locationId (string)<br>locationName (string)<br>locationCode (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : Workers by Position

| Workflow Name | Workers by Position |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_POS |
| **Description** | A workflow agent that takes a position as input and lists all workers associated with that position. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | positionName (string)<br>positionId (string)<br>positionCode (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : List of Workers by Location, Job, Position, Grade and Business Unit

| Workflow Name | List of Workers by Location, Job, Position, Grade and Business Unit |
|---------------|---------------|
| **Code** | XX_WORKER_LIST_BY_WORKSTR |
| **Description** | A workflow agent that takes Location, Job, Grade, Department, Position and Business Unit as input and returns the list of workers associated with the given input |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | departmentName (string)<br>businessUnitId (string)<br>businessUnitName (string)<br>gradeName (string)<br>gradeCode (string)<br>gradeId (string)<br>positionId (string)<br>positionName (string)<br>positionCode (string)<br>jobName (string)<br>jobCode (string)<br>jobId (string)<br>locationId (string)<br>locationName (string)<br>locationCode (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |

#### Workflow : Manager Information

| Workflow Name | Manager Information |
|---------------|---------------|
| **Code** | XX_WORKER_MANAGER_BY_PERSON |
| **Description** | A workflow agent that takes person id and returns manager information. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string) |
| **Output Parameters** | The workflow returns an array of manager objects. Each object has the fields AssignmentSupervisorId (integer), ManagerPersonId (integer), ManagerPersonNumber (string), FirstName (string), LastName (string), DisplayName (string), KnownAs (string), ManagerAssignmentId (integer), ManagerAssignmentNumber (string), ManagerAssignmentName (string), ManagerType (string), ManagerTypeMeaning (string), JobCode (string), JobName (string), PositionCode (string), PositionName (string), PhotoId (integer), PhotoName (string), and WorkEmail (string). |

#### Workflow : Manager Hierarchy

| Workflow Name | Manager Hierarchy |
|---------------|---------------|
| **Code** | XX_WORKER_MNGR_HIERARCHY_BY_PERSON |
| **Description** | A workflow agent that takes person id and returns manager hierarchy till top person. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string) |
| **Output Parameters** | The workflow returns an array of manager-hierarchy objects. Each object has the fields DisplayName (string), ManagerPersonId (integer), ManagerAssignmentId (integer), RelationshipType (string), RelationshipTypeMeaning (string), and Level (integer). |

#### Workflow : Phone Details of Worker

| Workflow Name | Phone Details of Worker |
|---------------|---------------|
| **Code** | XX_WORKER_PHONE_BY_PERSON |
| **Description** | Returns the phone numbers for a worker using person identifier first, or person number when person identifier is not provided. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string)<br>personNumber (string) |
| **Output Parameters** | The workflow returns an array of phone objects. Each object has the fields PhoneId (integer), PhoneType (string), LegislationCode (string), CountryCodeNumber (string), AreaCode (string), PhoneNumber (string), Extension (string), FromDate (date), ToDate (date), Validity (string), CreatedBy (string), CreationDate (datetime), LastUpdatedBy (string), LastUpdateDate (datetime), and PrimaryFlag (boolean). |

#### Workflow : Seniority Information

| Workflow Name | Seniority Information |
|---------------|---------------|
| **Code** | XX_WORKER_SENR_INFO_BY_MGR |
| **Description** | Returns seniority information for workers in the supplied manager person identifier hierarchy. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | managerPersonId (string) |
| **Output Parameters** | The workflow returns an array of team-seniority objects. Each object has the fields SeniorityDateId (integer), PersonId (integer), AssignmentId (integer), ManagerId (integer), ManagerAssignmentId (integer), SeniorityDate (date), ExitDate (date), LevelCode (string), SeniorityField (string), SeniorityFieldKey (string), DisplayName (string), SeniorityFieldName (string), SeniorityFieldValue (string), TotalSeniorityHours (number), SeniorityLosYears (number), SeniorityLosMonths (number), SeniorityLosDays (number), ManualAdjustmentDays (number), TotalManualAdjustmentDays (number), AutoAdjustmentDays (number), TotalAutoAdjustmentDays (number), TotalAdjustmentDays (number), ManualAdjustmentHours (number), TotalManualAdjustmentHours (number), AutoAdjustmentHours (number), TotalAutoAdjustmentHours (number), TotalAdjustmentHours (number), SeniorityEffectiveDate (date), ManagerLevel (integer), and IsDirect (string). |

#### Workflow : Seniority Information of Worker

| Workflow Name | Seniority Information of Worker |
|---------------|---------------|
| **Code** | XX_WORKER_SENR_INFO_BY_PERSON |
| **Description** | Returns seniority information for the supplied person identifier. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | personId (string) |
| **Output Parameters** | The workflow returns an array of seniority objects. Each object has the fields ActionOccurrenceId (integer), AutoAdjustmentComments (string), AutoAdjustmentDays (number), AutoAdjustmentHours (number), BaseSeniorityDate (date), CalculationType (string), CreatedBy (string), CreationDate (datetime), EffectiveEndDate (date), EffectiveStartDate (date), EntryDate (date), ExitDate (date), LastUpdateDate (datetime), LastUpdatedBy (string), LevelCode (string), LevelObjectId (integer), ManualAdjustmentComments (string), ManualAdjustmentDays (number), ManualAdjustmentHours (number), PersonId (integer), SourceIdentifier (string), SeniorityDate (date), SeniorityDateCode (string), SeniorityDateId (integer), SeniorityAttributeCode (string), SeniorityAttributeIdentifier (string), SeniorityHours (number), SeniorityLengthOfServiceHours (string), TotalAdjustmentDays (number), TotalAdjustmentHours (number), TotalAutoAdjustmentDays (number), TotalAutoAdjustmentHours (number), TotalManualAdjustmentDays (number), TotalManualAdjustmentHours (number), TotalSeniorityHours (number), JobName (string), JobId (integer), LocationName (string), LocationId (integer), GradeName (string), GradeId (integer), DepartmentName (string), DepartmentId (integer), SeniorityDateCodeMeaning (string), BusinessUnitName (string), BusinessUnitId (integer), CollectiveAgreementName (string), CollectiveAgreementId (integer), LegislationCodeName (string), LegislationCode (string), EnterpriseName (string), GradeStepName (string), GradeStepId (integer), LegalEntityId (integer), PositionId (integer), PositionName (string), UnionName (string), UnionId (integer), AssignmentCategoryMeaning (string), AssignmentCategory (string), BargainingUnitMeaning (string), BargainingUnitCode (string), SeniorityAttributeIdentifierName (string), BusinessTitle (string), AssignmentNumber (string), WorkerType (string), EssRequestId (integer), ESSLastRunDate (datetime), SeniorityLengthOfServiceDays (number), SeniorityLengthOfServiceMonths (number), SeniorityLengthOfServiceTotalDays (number), SeniorityLengthOfServiceYears (number), LevelCodeMeaning (string), SeniorityAttributeCodeMeaning (string), WorkerTypeMeaning (string), AssignmentLegalEmployerName (string), RequestedEffectiveDate (date), SeniorityBasis (string), LegalEmployerName (string), SeniorityBasisMeaning (string), AssignmentStatusType (string), AssignmentStatusTypeId (integer), and AssignmentStatusTypeName (string). |

#### Workflow : Worker By Name

| Workflow Name | Worker By Name |
|---------------|---------------|
| **Code** | XX_WORKER_SRCH_BY_NAME |
| **Description** | A workflow agent that takes a worker's name or partial name as input and returns the matching worker record. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | workerName (string) |
| **Output Parameters** | The workflow returns an array of worker objects. Each object has the fields DisplayName (string), DepartmentName (string), JobName (string), LocationName (string), PositionName (string), PersonId (string), PersonNumber (string), and AssignmentNumber (string). |
<!-- END GENERATED WORKFLOWS -->
