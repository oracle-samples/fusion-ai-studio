# Ledger Insights Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Accounting Exceptions

| Workflow Name | Accounting Exceptions |
|---------------|---------------|
| **Code** | XX_FIN_GL_ACCOUNTING_EXCEPTIONS_WORKFLOW |
| **Description** | Identifies accounting exceptions that can block period close, summarizes exception categories by ledger and period, drills into affected transactions, and supports corrective actions such as reviewing transaction details or submitting the related accounting process. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraMessageHint (string) <br> OraAppContext (string) <br> OraAction (string) - Supported actions: <br> validateFields - Displays confirmation before submitting the selected corrective process. <br> submitEss - Submits the selected supported ESS process. <br> drillDownToTransactions - Retrieves affected transactions for the selected accounting exception. <br> subledgerAccounting - Submits the subledger accounting ESS process. <br> journalImport - Submits the journal import ESS process. <br> postJournals - Submits the journal posting ESS process. |
| **Output Parameters** |  This workflow supports InitDisplay and InvokeAction. <br> `InitDisplay` - Retrieves and summarizes accounting exception categories for the ledger and period supplied through OraAppContext, including exception counts and amounts, and provides drilldown to affected transactions. <br> `InvokeAction` - Processes the selected action supplied through OraAction. It supports drilling into exception categories and transaction details and presents corrective actions such as providing an alternate account, reactivating an account, creating subledger accounting, using a suspense account, importing or posting journals, and creating a currency conversion rate. Supported ESS submissions cover subledger accounting, journal import, and journal posting. |

#### Workflow : Clearing Account Balances

| Workflow Name | Clearing Account Balances |
|---------------|---------------|
| **Code** | XX_FIN_GL_CLEARING_ACCOUNT_WORKFLOW |
| **Description** | Monitors clearing account insights for the selected ledger, highlights unreconciled or unusual clearing balances, and lets users drill into balances, journals, and supporting transactions to understand and resolve close risks. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraMessageHint (string) <br> OraAppContext (string) <br> OraAction (string) - Supported actions: <br> openClrAccBalInsight - Retrieves the selected clearing insight and displays its related balance or journal details. <br> markAsReviewed - Opens a form to enter review comments. <br> dismiss - Dismisses the selected insight and displays confirmation. <br> insight_review_record - Saves the review comments and marks the selected insight as reviewed. |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction. <br> `InitDisplay` - Retrieves open clearing account insights for the ledger supplied through OraAppContext, ranks and summarizes the top insights, and provides drilldown to the selected insight. <br> `InvokeAction` - Processes the selected action supplied through OraAction. It supports opening the insight, retrieving balance and journal details, marking the insight as reviewed with comments, and dismissing the insight. |

#### Workflow : Controls and Compliance

| Workflow Name | Controls and Compliance |
|---------------|---------------|
| **Code** | XX_FIN_GL_CONTROLS_COMPLIANCE_WORKFLOW |
| **Description** | Surfaces controls and compliance insights for ledger close, prioritizes policy exceptions and audit risks, supports review or dismissal of flagged issues, and provides drilldowns into journals, balances, and supporting details. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraMessageHint (string) <br> OraAppContext (string) <br> OraAction (string) - Supported actions: <br> openCtrlCmpInsight - Retrieves the selected control insight and displays its related balance or journal details. <br> markAsReviewed - Opens a form to enter review comments. <br> dismiss - Dismisses the selected insight and displays confirmation. <br> insight_review_record - Saves the review comments and marks the selected insight as reviewed. |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction. <br> `InitDisplay` - Retrieves open accounting control and period-end control insights for the ledger supplied through OraAppContext, ranks and summarizes the top insights, and provides drilldown to the selected insight. <br> `InvokeAction` - Processes the selected action supplied through OraAction. It supports opening the insight, retrieving balance and journal details, marking the insight as reviewed with comments, and dismissing the insight. |

#### Workflow : Ledger Closure Workflow

| Workflow Name | Ledger Closure Workflow |
|---------------|---------------|
| **Code** | XX_FIN_GL_LEDGER_CLOSURE_WORKFLOW |
| **Description** | Orchestrates the Ledger Close Workspace by loading application context, routing app message hints, invoking the period status, accounting exceptions, controls compliance, clearing account, and variance workflows in parallel, and rendering an executive close summary. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraMessageHint (string) <br> OraAppContext (string) |
| **Output Parameters** | This workflow supports the Ledger Insights summary. <br> `summary` - Uses the ledger application context to invoke the Period Status, Accounting Exceptions, Controls and Compliance, Clearing Account Balances, and Variance Analysis workflows in parallel and returns a consolidated executive close summary from their combined outputs. |

#### Workflow : Ledger Insights Context Workflow

| Workflow Name | Ledger Insights Context Workflow |
|---------------|---------------|
| **Code** | XX_FIN_GL_LEDGER_INSIGHTS_CONTEXT_WORKFLOW |
| **Description** | This workflow identifies the user's preferred default ledger and available ledger access, then initializes or switches the active ledger context based on the specified ledger to ensure all subsequent operations are performed in the correct financial context. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | OraMessageHint (string) <br> OraAction (string) - Supported actions: <br> selectLedger - Validates the selected ledger and its open accounting periods and returns the updated application context. <br> OraAppContext (string) <br> inputMessage (string) <br> fetchGlRuleCategoryLookups (boolean) <br> fetchFunRulePriorityLookups (boolean) |
| **Output Parameters** | This workflow initializes the ledger application context and supports Query and InvokeAction for ledger selection. <br> `Query` - Uses inputMessage to identify a ledger-switch request, searches ledgers available to the user, and returns either a matching ledger context or a list of ledger choices. <br> `InvokeAction` - Processes a selectLedger action from OraAction, validates the selected ledger and its open accounting periods, and returns the updated context to refresh the application. |

#### Workflow : Ledger Insights Query Helper

| Workflow Name | Ledger Insights Query Helper |
|---------------|---------------|
| **Code** | XX_FIN_GL_LEDGER_INSIGHTS_QUERY_HELPER |
| **Description** | Builds a Journals BV journal-line drilldown query payload from an analytic-view request using chart-of-accounts metadata, ledger information, and configured field aliases. |
| **Exposed to Agentic Apps** | No |
| **Input Parameters** | inputParams (object) |
| **Output Parameters** | This workflow returns a Journals BV journal-line query payload. <br> It parses filters from the analytic-view request, maps chart-of-accounts segment metadata, builds hierarchy queries and conditions, and constructs the JournalLine fact view, returns the query payload |

#### Workflow : Ledger Switch Workflow

| Workflow Name | Ledger Switch Workflow |
|---------------|---------------|
| **Code** | XX_FIN_GL_LEDGER_SWITCH_WORKFLOW |
| **Description** | Manages ledger context selection for the Ledger Close Workspace by reading the current application context, listing ledgers available to the signed-in user, validating selection or refresh requests, and returning the updated ledger context for the app. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | QueryMode (boolean) <br> OraMessageHint (string) <br> OraAction (string) - Supported actions: <br> selectLedger - Applies the selected ledger context and refreshes the application. <br> OraAppContext (string) |
| **Output Parameters** | This workflow supports InitContextSuggestions, QueryContextSuggestions, Query, and InvokeAction. <br> `InitContextSuggestions` - Returns the default ledger and period application context or provides selectable ledger suggestions. <br> `QueryContextSuggestions` - Searches ledgers available to the user based on the query text and returns selectable ledger suggestions. <br> `Query` - Processes a ledger-switch request, validates matching ledgers and open accounting periods, and either returns ledger choices or refreshes the application with the selected context. <br> `InvokeAction` - Processes a selectLedger action from OraAction and refreshes the application with the validated ledger and period context. |

#### Workflow : Period Status

| Workflow Name | Period Status |
|---------------|---------------|
| **Code** | XX_FIN_GL_PERIOD_STATUS_WORKFLOW |
| **Description** | Retrieves and displays period status for General Ledger and the Payables and Receivables subledgers for the selected ledger and accounting period. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraMessageHint (string) <br> OraAppContext (string) |
| **Output Parameters** | This workflow supports InitDisplay. <br> `InitDisplay` - Uses the ledger and period from OraAppContext to retrieve General Ledger, Payables, and Receivables period statuses and displays each status as a badge. |

#### Workflow : Variance Analysis

| Workflow Name | Variance Analysis |
|---------------|---------------|
| **Code** | XX_FIN_GL_VARIANCE_ANALYSIS_WORKFLOW |
| **Description** | Analyzes significant balance variances for the selected ledger and period, ranks variance insights by business impact, and supports drilldowns into balances and review or dismissal actions. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraMessageHint (string) <br> OraAppContext (string) <br> OraAction (string) - Supported actions: <br> openVarInsight - Retrieves the selected variance insight and displays its related balance details. <br> markAsReviewed - Opens a form to enter review comments. <br> dismiss - Dismisses the selected insight and displays confirmation. <br> insight_review_record - Saves the review comments and marks the selected insight as reviewed. |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction. <br> `InitDisplay` - Retrieves open variance insights for the ledger supplied through OraAppContext, ranks and summarizes the top insights, and provides drilldown to the selected insight. <br> `InvokeAction` - Processes the selected action supplied through OraAction. It supports opening the insight, retrieving balance details, marking the insight as reviewed with comments, and dismissing the insight. |
<!-- END GENERATED WORKFLOWS -->
