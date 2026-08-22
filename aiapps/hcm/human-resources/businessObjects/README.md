## Business Objects
<br>


## Business Object : Document Records Expiring Lookup

| Code | `ORA_HCM_GLOBALHUMA_XX_DOCUMENTRECORDSEXPIRINGLOOKUP` |
|---------------|---------------|
| Description | Retrieves document records with DateTo between the supplied current date and date after 30 days. Input: Current date and date after 30 days. Output: Document display name, document type, document name, and end date. |

## Functions

### Function : getDocumentRecordsExpiringWithinDateRange

Description: Retrieves document records that expire between the current date and 30 days later, and returns the display name, document type, document name, and DateTo for each matching record.

| Parameter Name | Description |
|---------------|---------------|
| `pPersonNumber` | Stores the person number |
| `pCurrentDate` | Stores the current date |
| `pDateAfter30Days` | Date after 30 days in YYYY-MM-DD format used as the end of the document DateTo range. |

### Function : getDocumentRecordsForPersonWithinDateRange

Description: Retrieves document records for the logged-in user's person number within the specified date range and returns the matching document record details from documentRecords.

| Parameter Name | Description |
|---------------|---------------|
| `pPersonNumber` | Person number of the logged-in user. |
| `pStartDate` | Start date in YYYY-MM-DD format for the document DateTo range. |
| `pEndDate` | End date in YYYY-MM-DD format for the document DateTo range. |

---------------

## Business Object : HCM GHR Employment

| Code | `ORA_HCM_GLOBALHUMA_XX_EMPLOYMENTGHR` |
|---------------|---------------|
| Description | Provides Global Human Resources employment functions for assignment history, manager hierarchy, worker connections, seniority, compensation, performance, representatives, profiles, notes, and reporting counts. |

## Functions


### Function : GetAssignmentHistoryUpdates

Description: Returns assignment history update records for the supplied assignment identifier as of the supplied effective date.

| Parameter Name | Description |
|---------------|---------------|
| `assignmentId` | Assignment identifier used to retrieve assignment history update records. |
| `effectiveDate` | Effective date used to retrieve assignment history updates, formatted as YYYY-MM-DD. |

### Function : GetWorkerConnections

Description: Returns worker connection records for the supplied person and assignment, including line-manager hierarchy relationships.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to locate the worker record in HCM. |
| `assignmentId` | Assignment identifier used with the person identifier for assignment-scoped lookups. |

### Function : GetWorkerManagers

Description: Returns manager details for the supplied person and assignment.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to locate the worker record in HCM. |
| `assignmentId` | Assignment identifier used with the person identifier for assignment-scoped lookups. |

### Function : GetWorkerPrimaryAssignmentInfo

Description: Returns the primary assignment identifier for the supplied person.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve the worker primary assignment. |

### Function : GetAssignmentInformationByPerson

Description: Returns assignment information for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve worker assignment records. |

### Function : GetPersonSeniorityInformation

Description: Returns seniority information for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve worker seniority records. |

### Function : GetTeamSeniorityInformationByManager

Description: Returns seniority information for workers in the supplied manager hierarchy.

| Parameter Name | Description |
|---------------|---------------|
| `managerPersonId` | Manager person identifier used to retrieve team seniority records. |

### Function : GetSalaryHistoryByPersonId

Description: Returns current and historical salary records for the supplied person identifier, including salary amount, annualized salary, compa-ratio, quartile, and salary range values.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Worker person identifier used to retrieve salary history. |

### Function : GetPerformanceRatingsByPersonId

Description: Returns talent profile performance rating records for the supplied person identifier, including expanded performance rating details.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Worker person identifier used to retrieve talent and performance ratings. |

### Function : GetAssignmentUpdatesBetweenDates

Description: Returns assignment history rows for the supplied assignment identifier and effective-date range.

| Parameter Name | Description |
|---------------|---------------|
| `AssignmentId` | Worker assignment identifier whose history should be returned. |
| `RangeStartDate` | Start date of the history extraction range in YYYY-MM-DD format. |
| `RangeEndDate` | End date of the history extraction range in YYYY-MM-DD format. |
| `pFields` | Comma-separated list of assignment history fields to return from employmentAssignmentHistoryDetails. |

### Function : GetWorkerRepresentatives

Description: Returns work-contact representatives for a worker assignment, including representative responsibility, person, assignment, contact, and effective-date details.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier of the worker whose assignment representatives are retrieved. |
| `assignmentId` | Assignment identifier used to retrieve representatives for the worker assignment. |

### Function : GetTalentPersonProfiles

Description: Returns eligible talent profile sections for a person, including profile summary, career ambassador details, expertise, interests, favorite links, tags, and skills.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier of the worker whose talentProfiles are to be retrieved. |

### Function : GetPersonNotesV2

Description: Returns person notes for a worker, including note text and note visibility details when available.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve person notes for the requested worker. |

### Function : GetManagerDirectReports

Description: Returns direct reports for the supplied manager assignment, including worker identifiers and report-count metadata.

| Parameter Name | Description |
|---------------|---------------|
| `managerPersonId` | Manager person identifier whose direct reports should be returned. |
| `managerAssignmentId` | Manager assignment identifier used to retrieve direct reports. |

### Function : GetWorkerDirectReportsCount

Description: Returns direct reports count metadata for the supplied worker assignment using totalResults.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier whose direct reports count should be returned. |
| `assignmentId` | Assignment identifier used to retrieve direct reports count. |

### Function : GetWorkerAllReportsCount

Description: Returns total reports count metadata for the supplied worker assignment using totalResults.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier whose total reports count should be returned. |
| `assignmentId` | Assignment identifier used to retrieve total reports count. |

---------------

## Business Object : Person Direct Reports V2

| Code | `ORA_HCM_GLOBALHUMA_XX_PERSONDIRECTREPORTSV2` |
|---------------|---------------|
| Description | This business object gives direct report information for a manager. It can be used to retrieve direct report records based on the input manager person id, manager assignment id, limit, and offset. |

## Functions


### Function : get_directReports

Description: This function gives direct report records for a manager based on the input manager person id, manager assignment id, limit, and offset.

| Parameter Name | Description |
|---------------|---------------|
| `managerPersonId` | Manager person identifier used to retrieve direct report records. |
| `managerAssignmentId` | Manager assignment identifier used to retrieve direct report records. |
| `limit` | Maximum number of direct report records to return. |
| `offset` | Zero-based offset used for paginated direct report results. |

---------------

## Business Object : Person Notes V2

| Code | `ORA_HCM_GLOBALHUMA_XX_PERSONNOTESV2` |
|---------------|---------------|
| Description | This business object gives person note information for a worker. It can be used to retrieve note text, visibility, author, worker, and context details based on the input person id. |

## Functions


### Function : get_person_notes

Description: This function gives person note records for a worker based on the input person id. It returns note text, visibility, author, worker, and context details when available.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve note records for the worker. |

---------------

## Business Object : HCM GHR Worker Search

| Code | `ORA_HCM_GLOBALHUMA_XX_PERSONSEARCHESGHR` |
|---------------|---------------|
| Description | Provides Global Human Resources Redwood worker search and aggregation functions for worker lists and counts by department, job, grade, business unit, position, location, and custom payload. |

## Functions


### Function : GetWorkerCount

Description: Returns worker aggregation counts for a supplied workerAggregationsV2 request payload.

| Parameter Name | Description |
|---------------|---------------|
| `payload` | JSON request payload for workerAggregationsV2, including security filters, facets, filters, and optional facet value query. |

### Function : GetWorkersCountByDepartmentName

Description: Returns the number of workers whose department name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `departmentName` | Department name used to filter worker records or count matching workers. |

### Function : GetWorkersByJobId

Description: Lists workers whose job identifier matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `jobId` | Job identifier used to filter worker records or retrieve job details. |

### Function : GetWorkersCountByBusinessUnitName

Description: Returns the number of workers whose business unit name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `businessUnitName` | Business unit name used to filter worker records or count matching workers. |

### Function : GetWorkersByName

Description: Lists workers whose display name matches the supplied full or partial worker name.

| Parameter Name | Description |
|---------------|---------------|
| `workerName` | Full or partial worker display name used for workerSearchesV2 name matching. |

### Function : GetWorkersCountByGradeCode

Description: Returns the number of workers whose grade code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `gradeCode` | Grade code used to filter worker records or count matching workers. |

### Function : GetWorkersCountByGradeName

Description: Returns the number of workers whose grade name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `gradeName` | Grade name used to filter worker records or count matching workers. |

### Function : GetWorkersByGradeName

Description: Lists workers whose grade name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `gradeName` | Grade name used to filter worker records or count matching workers. |

### Function : GetWorkersByGradeCode

Description: Lists workers whose grade code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `gradeCode` | Grade code used to filter worker records or count matching workers. |

### Function : GetWorkersByGradeId

Description: Lists workers whose grade identifier matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `gradeId` | Grade identifier used to filter worker records. |

### Function : GetWorkersByBusinessUnitName

Description: Lists workers whose business unit name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `businessUnitName` | Business unit name used to filter worker records or count matching workers. |

### Function : GetWorkersByDepartmentName

Description: Lists workers whose department name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `departmentName` | Department name used to filter worker records or count matching workers. |

### Function : GetWorkersCountByJobCode

Description: Returns the number of workers whose job code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `jobCode` | Job code used to filter worker records or count matching workers. |

### Function : GetWorkersCountByJobName

Description: Returns the number of workers whose job name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `jobName` | Job name used to filter worker records or count matching workers. |

### Function : GetWorkersByJobName

Description: Lists workers whose job name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `jobName` | Job name used to filter worker records or count matching workers. |

### Function : GetWorkersByJobCode

Description: Lists workers whose job code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `jobCode` | Job code used to filter worker records or count matching workers. |

### Function : GetWorkersByBusinessUnitId

Description: Lists workers whose business unit identifier matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `businessUnitId` | Business unit identifier used to filter worker records. |

### Function : GetWorkersCountByPositionName

Description: Returns the number of workers whose position name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `positionName` | Position name used to filter worker records or count matching workers. |

### Function : GetWorkersCountByPositionCode

Description: Returns the number of workers whose position code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `positionCode` | Position code used to filter worker records or count matching workers. |

### Function : GetWorkersCountByLocationName

Description: Returns the number of workers whose location name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `locationName` | Location name used to filter worker records or count matching workers. |

### Function : GetWorkersByPositionCode

Description: Lists workers whose position code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `positionCode` | Position code used to filter worker records or count matching workers. |

### Function : GetWorkersByPositionName

Description: Lists workers whose position name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `positionName` | Position name used to filter worker records or count matching workers. |

### Function : GetWorkersByPositionId

Description: Lists workers whose position identifier matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `positionId` | Position identifier used to filter worker records. |

### Function : GetWorkersCountByLocationCode

Description: Returns the number of workers whose location code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `locationCode` | Location code used to filter worker records or count matching workers. |

### Function : GetWorkersByLocationId

Description: Lists workers whose location identifier matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `locationId` | Location identifier used to filter worker records. |

### Function : GetWorkersByLocationName

Description: Lists workers whose location name matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `locationName` | Location name used to filter worker records or count matching workers. |

### Function : GetWorkersByLocationCode

Description: Lists workers whose location code matches the supplied value.

| Parameter Name | Description |
|---------------|---------------|
| `locationCode` | Location code used to filter worker records or count matching workers. |

### Function : GetWorkers

Description: Returns workers for a supplied workerSearchesV2 request payload.

| Parameter Name | Description |
|---------------|---------------|
| `payload` | JSON request payload for workerSearchesV2, including security filters, display fields, filters, offset, and limit. |

### Function : GetWorkersByManager

Description: Gets the list of workers who are directs for a line manager

| Parameter Name | Description |
|---------------|---------------|
| `context` | security context for filtering the workers by directs of a manager |

---------------

## Business Object : Representatives Search V2

| Code | `ORA_HCM_GLOBALHUMA_XX_REPRESENTATIVESSEARCHV2` |
|---------------|---------------|
| Description | This business object gives representative information for a worker. It can be used to retrieve representatives based on the input person id, assignment id, responsibility type, limit, and offset. |

## Functions


### Function : get_representatives

Description: This function gives representative records for a worker based on the input person id, assignment id, limit, and offset.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve representatives for the worker. |
| `assignmentId` | Assignment identifier used to retrieve representatives for the worker assignment. |
| `limit` | Maximum number of representative records to return. |
| `offset` | Zero-based offset used for paginated representative results. |

### Function : get_representatives_by_responsibility_type

Description: This function gives representative records for a worker based on the input person id, assignment id, responsibility type, limit, and offset.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve representatives for the worker. |
| `assignmentId` | Assignment identifier used to retrieve representatives for the worker assignment. |
| `responsibilityType` | Responsibility type used to filter representative records. |
| `limit` | Maximum number of representative records to return. |
| `offset` | Zero-based offset used for paginated representative results. |

---------------

## Business Object : Talent Person Profiles

| Code | `ORA_HCM_GLOBALHUMA_XX_TALENTPERSONPROFILES` |
|---------------|---------------|
| Description | This business object gives talent profile information for a person. It can be used to retrieve about me, expertise, interests, tags, and skills based on the input person id. |

## Functions


### Function : getall_talentPersonProfiles

Description: This function gives talent profile information for a person based on the input person id.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve records for the person. |

---------------

## Business Object : HCM GHR Worker Contact Details

| Code | `ORA_HCM_GLOBALHUMA_XX_WORKERDETAILSGHR` |
|---------------|---------------|
| Description | Provides Global Human Resources public worker and contact information by person identifier or person number, including worker profile, email, phone, address, and other communication account details. |

## Functions


### Function : GetWorkerEmailsByPersonId

Description: Returns worker email details for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve worker contact detail records. |

### Function : GetWorkerPhonesByPersonId

Description: Returns worker phone details for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve worker contact detail records. |

### Function : GetWorkerEmailsByPersonNumber

Description: Returns worker email details for the supplied person number.

| Parameter Name | Description |
|---------------|---------------|
| `personNumber` | Person number used to retrieve worker contact detail records. |

### Function : GetWorkerPhonesByPersonNumber

Description: Returns worker phone details for the supplied person number.

| Parameter Name | Description |
|---------------|---------------|
| `personNumber` | Person number used to retrieve worker contact detail records. |

### Function : GetWorkerAddressesByPersonId

Description: Returns worker address details for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve worker contact detail records. |

### Function : GetWorkerAddressesByPersonNumber

Description: Returns worker address details for the supplied person number.

| Parameter Name | Description |
|---------------|---------------|
| `personNumber` | Person number used to retrieve worker contact detail records. |

### Function : GetWorkerDetailsByPersonId

Description: Returns worker details for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve worker details. |

### Function : GetWorkerDetailsByPersonNumber

Description: Returns worker details for the supplied person number.

| Parameter Name | Description |
|---------------|---------------|
| `personNumber` | Person number used to retrieve worker details. |

### Function : GetWorkerOtherCommunicationAccountsByPersonId

Description: Returns a worker's other communication account details for the supplied person identifier.

| Parameter Name | Description |
|---------------|---------------|
| `personId` | Person identifier used to retrieve the worker's other communication account details. |
