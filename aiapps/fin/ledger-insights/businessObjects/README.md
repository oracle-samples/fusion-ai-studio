# Business Objects
<br>

## Business Object Name : Accounting Exceptions Lookup

| **Name** | Accounting Exceptions Lookup |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_ACCOUNTINGEXCEPTIONS_LOOKUP |
| **Description** | Provides lookup functions for accounting exception summaries and transaction details by issue category, ledger, and accounting period. |

## Functions

#### Function : getTransactionCategorySummaryforErrorCategory
Description : Gets accounting exception counts grouped by transaction category for a selected issue category.

| **Parameter Name** | **Description**|
|---------------|---------------|
| programCode | Program Code |
| transactionNumber | Transaction Number |
| period | Accounting Period |
| errorCategory | Error Category |
| ledgerId | Ledger Id |


#### Function : getTransactionsforErrorCategory
Description : Gets transaction-level accounting exception details for a selected issue category, sorted by total amount.

| **Parameter Name** | **Description**|
|---------------|---------------|
| programCode | Program Code |
| transactionNumber | Transaction Number |
| period | Accounting period |
| errorCategory | Error Category |
| ledgerId | Ledger Id |


#### Function : getAccountingExceptions
Description : Gets accounting exception totals grouped by issue category for a selected ledger and accounting period.

| **Parameter Name** | **Description**|
|---------------|---------------|
| ledgerId | Ledger Id |
| programCode | Program Code |
| period | Accounting Period |


## Business Object Name : Accounting Exceptions ESS Jobs

| **Name** | Accounting Exceptions ESS Jobs |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_ACCOUNTINGEXCEPTIONSESSJOBS |
| **Description** | The Accounting Exceptions ESS Jobs Business Object enables the submission and monitoring of ESS jobs related to accounting exceptions within the General Ledger. It supports creating job requests and retrieving their status, facilitating the management of automated accounting exception processes. |

## Functions

#### Function : submitEssJob
Description : Submits an ESS job request within the Accounting Exceptions ESS Jobs Business Object to initiate automated processing of accounting exceptions in the General Ledger. This function posts the job details to the ERP integrations resource for execution and monitoring.

| **Parameter Name** | **Description**|
|---------------|---------------|
| jobPackageName | ESS job package path for the accounting process being submitted. Use the workflow-derived package value for the selected accounting action; examples in this BO use placeholder package identifiers only. |
| jobDefName | ESS job definition name that identifies the accounting process to run. Use the workflow-derived job definition for the selected accounting action; examples in this BO use placeholder job definition identifiers only. |
| essParams | Comma-separated ESS parameter string passed to the selected job definition. The value is prepared by the workflow for the selected accounting action and must match the parameter order expected by that ESS job. |


#### Function : getEssJobStatus
Description : Retrieves the current status of an ESS job request related to accounting exceptions by using the provided request ID. This function enables monitoring of automated job processes within the General Ledger.

| **Parameter Name** | **Description**|
|---------------|---------------|
| requestId | ESS request id returned as ReqstId by submitESSJobRequest. |


## Business Object Name : Chart of Accounts Details

| **Name** | Chart of Accounts Details |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_CHART_OF_ACCOUNTS_DETAILS |
| **Description** | The Chart of Accounts Metadata Business Object provides access to detailed information about the chart of accounts structure within the general ledger. It supports retrieving metadata records and related child resources to help configure and understand account hierarchies and classifications. This object currently enables metadata retrieval through a dedicated operation, facilitating integration and reporting needs. |

## Functions

#### Function : getChartOfAccountDetails
Description : Retrieves detailed metadata about the chart of accounts structure within the general ledger, including key account segments and their classifications. This function supports accessing account hierarchy information to aid in configuration, integration, and reporting.

| **Parameter Name** | **Description**|
|---------------|---------------|
| chartOfAccountsId | Specifies the unique identifier of the chart of accounts to retrieve detailed metadata for. This required parameter is used as an input token to identify the specific chart of accounts within the general ledger structure. |


## Business Object Name : Execute BOSS Query Helper

| **Name** | Execute BOSS Query Helper |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_EXECUTE_BOSS_QUERY_HELPER |
| **Description** | Insights - Execute BOSS Query Helper enables the execution of specialized BOSS queries within the General Ledger domain, supporting data extraction for various financial aggregates. It facilitates creating and managing query requests through multiple POST operations, including handling related child resources for detailed extraction processes. This Business Object streamlines access to aggregated financial insights by coordinating core and supporting query functions. |

## Functions

#### Function : bossExtract
Description : Executes a specialized BOSS query to extract financial data within the General Ledger domain. This function submits a payload to initiate the extraction process, enabling access to aggregated financial insights through the Insights - Execute BOSS Query Helper.

| **Parameter Name** | **Description**|
|---------------|---------------|
| payload | Payload for the boss extract |


#### Function : extractAV
Description : Executes a specialized BOSS query to extract aggregated AV data within the General Ledger domain, enabling detailed financial insights through a secure POST operation.

| **Parameter Name** | **Description**|
|---------------|---------------|
| payload | Payload |


## Business Object Name : Fetch Accounting Periods

| **Name** | Fetch Accounting Periods |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_FETCH_ACCOUNTING_PERIODS |
| **Description** | The Accounting Periods Business Object provides access to records defining financial reporting periods within the general ledger. It supports retrieval of accounting period data to facilitate financial processes and reporting, enabling users to query period information based on specific criteria. Currently, it focuses on fetching accounting period details without supporting creation or modification operations. |

## Functions

#### Function : getAccountingPeriods
Description : Retrieves accounting period records from the Accounting Periods Business Object based on a specified period set name and date, enabling users to access financial reporting periods relevant to their query.

| **Parameter Name** | **Description**|
|---------------|---------------|
| periodSetName | Period set name |
| date | Today's date |


## Business Object Name : General Standard Lookups

| **Name** | General Standard Lookups |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_GENERAL_STANDARD_LOOKUPS |
| **Description** | The Standard Lookups Business Object provides access to predefined lookup data used within the General Ledger product. It supports retrieving comprehensive lists of standard lookup values to facilitate consistent data selection and validation across financial processes. Currently, it enables read-only operations to fetch all relevant lookup records without supporting modifications or related child entities. |

## Functions

#### Function : getall_standardLookupsLOV
Description : Retrieves all standard lookup values for a specified lookup type from the Standard Lookups Business Object, enabling consistent selection and validation of predefined data within the General Ledger product.

| **Parameter Name** | **Description**|
|---------------|---------------|
| lookupType | Lookup Type |


## Business Object Name : Insight Review Actions

| **Name** | Insight Review Actions |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_INSIGHT_REVIEW_ACTIONS |
| **Description** | Insight Actions is a Business Object designed to manage and update insight records within the General Ledger domain, enabling users to perform key actions such as dismissing, marking as reviewed, or reopening insights. It supports straightforward lifecycle operations focused on modifying the status of insights to facilitate financial analysis and decision-making. |

## Functions

#### Function : reopen
Description : The reopen function updates the status of specified insights to open and adds user comments, enabling users to reactivate and provide context for insights within the Insight Actions business object in the General Ledger domain.

| **Parameter Name** | **Description**|
|---------------|---------------|
| InsightRecipientId | Id of Insight Recipient |
| Comments | Comments provided by User |


#### Function : dismissInsight
Description : The dismissInsight function allows users to mark selected insights as dismissed within the General Ledger domain. It updates the status of specified insight records to reflect their dismissal, supporting effective management of financial insights.

| **Parameter Name** | **Description**|
|---------------|---------------|
| InsightRecipientId | Id of the Insight Recipient |


#### Function : markInsightAsReviewed
Description : Marks specified insights as reviewed by updating their status and adding comments, enabling users to track the review progress within the Insight Actions business object for General Ledger insights.

| **Parameter Name** | **Description**|
|---------------|---------------|
| InsightRecipientId | Id of Insight Recipient |
| Comments | Comments provided by User |


## Business Object Name : Insights List

| **Name** | Insights List |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_INSIGHTS_LIST |
| **Description** | The Sensor Insights List Business Object provides access to a comprehensive list of sensor-generated insights within the General Ledger domain. It supports retrieval of these insights and includes related child resources, enabling users to efficiently fetch and manage associated sensor insight records. |

## Functions

#### Function : getall_sensorInsightList
Description : Retrieves a comprehensive list of sensor-generated insights within the General Ledger domain, allowing filtering by categories such as Accounting Controls, Account Analysis, Intercompany, and others. This function enables users to efficiently access detailed financial insight records to support ledger performance monitoring and analysis.

| **Parameter Name** | **Description**|
|---------------|---------------|
| qParam | Query Parameter for the endpoint |


## Business Object Name : Ledger Lookup

| **Name** | Ledger Lookup |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_LEDGER_LOOKUP |
| **Description** | Ledger Search provides comprehensive retrieval capabilities for ledger records within the General Ledger product, supporting pattern-based and full-list searches for both primary and all ledgers. It enables efficient querying of ledger data through multiple search functions, covering related ledger subsets to facilitate detailed financial data exploration. |

## Functions

#### Function : getAllLedgersMatchByPattern
Description : Retrieves a list of ledgers that match a specified name pattern, providing key details such as ledger ID, category, and currency. This function supports efficient pattern-based searching within the Ledger Search business object for the General Ledger product.

| **Parameter Name** | **Description**|
|---------------|---------------|
| partialLedgerName | Partial Ledger Name using pattern matching |


#### Function : getAllLedgersByPayload
Description : Retrieves a comprehensive list of ledger records based on the provided payload, enabling detailed extraction of ledger data within the General Ledger product. This function supports targeted searches by submitting specific criteria to the ledger extraction API.

| **Parameter Name** | **Description**|
|---------------|---------------|
| payload | Payload |


#### Function : getPrimaryLedgersMatchByPattern
Description : Retrieves a list of primary ledgers that match a specified name pattern, enabling targeted searches within the General Ledger. This function supports efficient querying of key ledger details through pattern-based filtering via the ledger search extraction API.

| **Parameter Name** | **Description**|
|---------------|---------------|
| partialLedgerName | Partial Ledger Name using pattern matching |


#### Function : getAllPrimaryLedgers
Description : Retrieves a list of all primary ledgers accessible within the General Ledger system, providing key details such as ledger ID, name, category, currency, and related accounting information. This function supports comprehensive ledger data extraction through the Ledger Search business object.

| **Parameter Name** | **Description**|
|---------------|---------------|

#### Function : getLedgersMatchByPattern
Description : Retrieves a list of ledger records from the General Ledger based on a partial ledger name using pattern matching. This function enables efficient searching of ledgers accessible within the user's data access sets, returning key ledger details to support financial data exploration.

| **Parameter Name** | **Description**|
|---------------|---------------|
| partialLedgerName | Partial Ledger Name using pattern matching |


#### Function : getAllLedgers
Description : Retrieves a comprehensive list of ledgers accessible within the General Ledger system, including key details such as ledger ID, name, category, and associated accounting structures. This function supports efficient exploration of ledger records through the Ledger Search business object.

| **Parameter Name** | **Description**|
|---------------|---------------|

## Business Object Name : Ledger Open Periods

| **Name** | Ledger Open Periods |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_LEDGER_OPEN_PERIODS |
| **Description** | The Open Periods By Ledger Business Object provides access to records of open accounting periods within general ledgers, enabling retrieval of all open periods or those filtered by specific ledger and period identifiers. It supports extraction operations focused on listing these periods, facilitating financial period management and reporting within the general ledger domain. |

## Functions

#### Function : openPeriodsListAll
Description : Retrieves a complete list of all open accounting periods across general ledgers, enabling users to view current financial periods for reporting and management purposes. This function performs an extraction operation on the Open Periods By Ledger Business Object.

| **Parameter Name** | **Description**|
|---------------|---------------|


#### Function : openPeriodsListAllunderLedger
Description : Lists all Open Periods for GLs for given ledger Id

| **Parameter Name** | **Description**|
|---------------|---------------|
| ledgerId | Ledger Id |


#### Function : openPeriodsList
Description : Lists Open Periods for GLs for given ledgerId and periodName

| **Parameter Name** | **Description**|
|---------------|---------------|
| periodName | Period Name |
| ledgerId | Ledger Id |


## Business Object Name : Ledger Preference Settings

| **Name** | Ledger Preference Settings |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_LEDGER_PREFERENCE_SETTINGS |
| **Description** | Fetch Preferences provides read-only access to user or system configuration settings within the General Ledger domain, enabling retrieval of preferred ledger options that influence financial processes. It supports fetching specific preference records but does not manage related entities or perform updates. |

## Functions

#### Function : getPreference
Description : Retrieves a specific user or system preference within the General Ledger domain by its code. This function accesses configuration settings that influence financial processes through a read-only operation.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pref | Preference Code |


## Business Object Name : Period Expression Resolver

| **Name** | Period Expression Resolver |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_PERIOD_EXPRESSION_RESOLVER |
| **Description** | The Resolve Period Expression Business Object converts relative period expressions into specific accounting period values to support Insights rule execution within the General Ledger domain. It provides a focused operation to process these expressions, enabling accurate period resolution for financial analysis and reporting. |

## Functions

#### Function : resolvePeriodExpression
Description : The resolvePeriodExpression function processes relative period expressions to generate specific accounting period values, supporting accurate Insights rule execution within the General Ledger domain. It enables precise financial analysis by converting period queries into concrete data through a dedicated API operation.

| **Parameter Name** | **Description**|
|---------------|---------------|
| payload | Accepts an Insights query with context, category, resolve flag, and optional conditions to resolve period expressions and apply variance threshold transformations.Accepts an Insights query with context, category, resolve flag, and optional conditions to resolve period expressions and apply variance threshold transformations. |


## Business Object Name : Period Status

| **Name** | Period Status |
|---------------|---------------|
| **Code** | ORA_FIN_GL_XX_PERIOD_STATUS |
| **Description** | Period Status By Source provides access to period status information within the General Ledger, including detailed data by source and fixed asset periods. It supports retrieval operations through extraction queries, enabling users to obtain current period statuses and related sub-resource details efficiently. This Business Object facilitates comprehensive period status reporting and analysis across multiple ledger sources. |

## Functions

#### Function : getPeriodWithSource
Description : Retrieves the status of accounting periods for a specified ledger and period, including detailed information by source such as subledgers within the General Ledger. This function enables users to obtain current period statuses and related ledger details through extraction queries.

| **Parameter Name** | **Description**|
|---------------|---------------|
| ledgerId | Ledger Id |
| periodName | Period Name |
