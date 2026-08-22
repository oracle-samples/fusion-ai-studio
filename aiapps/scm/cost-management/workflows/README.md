# Cost Management Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Inventory Valuation Comparison Advisor

| Workflow Name | Inventory Valuation Comparison Advisor |
|---------------|---------------|
| **Code** | XX_INVENTORY_VALUATION_COMPARISON_ADVISOR |
| **Description** | Retrieves inventory valuation records and compares inventory values across reporting periods. It provides comparisons between the current period, the previous period, and the same period in the prior year, along with variance percentages for valuation types such as Asset, Expense, and Consigned inventory. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow uses the Cost Accounting Review app context to obtain the Cost Organization, Cost Book, and accounting period. It validates the context and retrieves the Cost Book Code using `Inventory Valuation Comparison Advisor` business object. The workflow then retrieves current-period valuation data and prior-year valuation data in parallel for Asset, Expense, and Consigned inventory valuation units. It calculates the current-period inventory value, previous-period inventory value, prior-year inventory value, month-over-month (MoM) variance, and year-over-year (YoY) variance for each valuation unit. The result is displayed as a table using Multi Record widget, with MoM and YoY values shown as badges based on the variance magnitude. <br> Fields displayed : Valuation Type, current period inventory value, prior period inventory value, MoM variance, prior-year period inventory value, YoY variance. |

#### Workflow : Period Validation Exceptions Advisor

| Workflow Name | Period Validation Exceptions Advisor |
|---------------|---------------|
| **Code** | XX_PERIOD_VALIDATION_EXCEPTIONS_ADVISOR |
| **Description** | Retrieves cost accounting validation exceptions for the selected cost organization, cost book, and accounting period. It surfaces exception details in the Cost Accounting Review page, helping users identify and prioritize validation issues that may affect cost accounting review or period close. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | No input parameters required |
| **Output Parameters** | This workflow uses the Cost Accounting Review app context to obtain and validate the Cost Organization, Cost Book, and accounting period. It retrieves the cost accounting period context, including the last validation run date, and then retrieves validation exception records using `Period Validation Exceptions Advisor` business object. The workflow excludes records with zero, missing, or invalid error counts, so the output focuses on validation issues that require attention. It displays the remaining exception records as a table using Multi Record widget, titled with the last validation run date. Error counts are displayed as badges, with warning priority for counts up to 1000 and alert priority for counts above 1000. <br> Fields displayed : Source, Type, Errors as a badge. |
<!-- END GENERATED WORKFLOWS -->
