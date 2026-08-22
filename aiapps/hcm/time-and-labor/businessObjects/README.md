# Business Objects
<br/>

## Business Object : Missing Person Time Card Aggregations Lookup


| **Name** | Missing Person Time Card Aggregations Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TIMEANDLAB_XX_MISSINGPERSONTIMECARDAGGREGATIONSLOOKUP |
| **Description** | Retrieves missing person time card summaries for a line manager over the specified date range, from 30 days before the current date through the current date, and returns the missing person timecard aggregation facets. |

### Functions

#### Function : getMissingPersonTimeCardAggregations
Description : Retrieves missing person time card summary data for a line manager's organization and direct reports over the specified date range, from 30 days before the current date through the current date in YYYY-MM-DD format, and returns the missing person timecard aggregation facet results.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pDateBefore30Days | Start date in YYYY-MM-DD format, usually 30 days before the current date. |
| pCurrentDate | Current date in YYYY-MM-DD format used as the end of the time period range. |

## Business Object : Time Card Exception Aggregations Lookup


| **Name** | Time Card Exception Aggregations Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TIMEANDLAB_XX_TIMECARDEXCEPTIONAGGREGATIONSLOOKUP |
| **Description** | Retrieves time card exception summary data for a line manager over the specified date range, from 30 days before the current date through the current date, and returns the time card exception aggregation facets. |

### Functions

#### Function : getTimeCardAggregationsByException
Description : Retrieves time card exception summaries for line manager security over the specified date range, from 30 days before the current date through the current date in YYYY-MM-DD format, and returns the exception aggregation facet results.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pDateBefore30Days | Start date in YYYY-MM-DD format, usually 30 days before the current date. |
| pCurrentDate | Current date in YYYY-MM-DD format used as the end of the time period range. |

## Business Object : Time Card Exception Searches Lookup


| **Name** | Time Card Exception Searches Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TIMEANDLAB_XX_TIMECARDEXCEPTIONSEARCHESLOOKUP |
| **Description** | Searches time cards for the specified exception codes over the date range from 30 days before the current date through the current date, and returns the time card detail fields for matching exceptions. |

### Functions

#### Function : searchTimeCardsByException
Description : Searches time cards for one or more exception codes over the date range from 30 days before the current date through the current date, using a JSON array string such as ["WARN","INCOMPLETE"], and returns the person name, time period dates, status, exception, scheduled hours, absence hours, reported hours, and total hours.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pDateBefore30Days | Start date in YYYY-MM-DD format, usually 30 days before the current date. |
| pCurrentDate | Current date in YYYY-MM-DD format used as the end of the time period range. |
| ExceptionCode | JSON array string of exception codes from the exception aggregation response, for example ["WARN","INCOMPLETE"]. |

## Business Object : Time Card Searches Lookup


| **Name** | Time Card Searches Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TIMEANDLAB_XX_TIMECARDSEARCHESLOOKUP |
| **Description** | Searches time cards where reported hours are less than scheduled hours over the date range from 30 days before the current date through the current date, and returns the person name, time period dates, status, scheduled hours, and reported hours. |

### Functions

#### Function : searchTimeCardsWithReportedHoursLessThanScheduled
Description : Searches time cards where reported hours are less than scheduled hours over the date range from 30 days before the current date through the current date in YYYY-MM-DD format, and returns the person name, time period start and end dates, status code, scheduled hours, and reported hours.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pDateBefore30Days | Start date in YYYY-MM-DD format, usually 30 days before the current date. |
| pCurrentDate | Current date in YYYY-MM-DD format used as the end of the time period range. |

## Business Object : Time Card Status Aggregations Lookup


| **Name** | Time Card Status Aggregations Lookup |
|---------------|---------------|
| **Code** | ORA_HCM_TIMEANDLAB_XX_TIMECARDSTATUSAGGREGATIONSLOOKUP |
| **Description** | Retrieves time card status summary data for a line manager over the specified date range, from 30 days before the current date through the current date, and returns the time card status aggregation facets. |

### Functions

#### Function : getTimeCardAggregationsByStatus
Description : Retrieves time card status summary data for line manager security over the specified date range, from 30 days before the current date through the current date in YYYY-MM-DD format, and returns the time card status aggregation facet results.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pDateBefore30Days | Start date in YYYY-MM-DD format, usually 30 days before the current date. |
| pCurrentDate | Current date in YYYY-MM-DD format used as the end of the time period range. |
