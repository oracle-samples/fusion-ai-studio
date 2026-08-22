# Business Objects
<br>


## Inventory Valuation Comparison Advisor

| **Name** | Inventory Valuation Comparison Advisor |
|---------------|---------------|
| **Code** | ORA_SCM_XX_COSTMANAGE_INVENTORYVALUATIONCOMPARISONADVISOR |
| **Description** | Provides inventory valuation data for asset, expense, and consigned valuation units across current and prior comparison periods. |


### Function : getCostBookCode
Description : Retrieves the cost book code for a given cost book identifier.

| **Parameter Name** | **Description**|
|---------------|---------------|
| CostBookId | Identifier of the cost book used to retrieve the cost book code. |

### Function : getConsignedInventoryValue
Description : Retrieves consigned inventory value, prior inventory value, and cost organization name for the selected period, cost book, and cost organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PeriodName | Accounting period used to retrieve inventory valuation data. |
| CostOrganizationId | Identifier of the cost organization used to filter inventory valuation data. |
| CostBookCode | Cost book code used to filter inventory valuation data. |

### Function : getPriorAssetInventoryValue
Description : Retrieves asset inventory value for the prior comparison period, cost book, and cost organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PeriodName | Accounting period used to retrieve inventory valuation data. |
| CostOrganisationId | Identifier of the cost organization used to filter inventory valuation data. |
| CostBookCode | Cost book code used to filter inventory valuation data. |

### Function : getAssetInventoryValue
Description : Retrieves asset inventory value, prior inventory value, and cost organization name for the selected period, cost book, and cost organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PeriodName | Accounting period used to retrieve inventory valuation data. |
| CostOrganisationId | Identifier of the cost organization used to filter inventory valuation data. |
| CostBookCode | Cost book code used to filter inventory valuation data. |

### Function : getPriorConsignedInventoryValue
Description : Retrieves consigned inventory value for the prior comparison period, cost book, and cost organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PeriodName | Accounting period used to retrieve inventory valuation data. |
| CostOrganisationId | Identifier of the cost organization used to filter inventory valuation data. |
| CostBookCode | Cost book code used to filter inventory valuation data. |

### Function : getExpenseInventoryValue
Description : Retrieves expense inventory value, prior inventory value, and cost organization name for the selected period, cost book, and cost organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PeriodName | Accounting period used to retrieve inventory valuation data. |
| CostOrganisationId | Identifier of the cost organization used to filter inventory valuation data. |
| CostBookCode | Cost book code used to filter inventory valuation data. |

### Function : getPriorExpenseInventoryValue
Description : Retrieves expense inventory value for the prior comparison period, cost book, and cost organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| PeriodName | Accounting period used to retrieve inventory valuation data. |
| CostOrganisationId | Identifier of the cost organization used to filter inventory valuation data. |
| CostBookCode | Cost book code used to filter inventory valuation data. |

## Period Validation Exceptions Advisor

| **Name** | Period Validation Exceptions Advisor |
|---------------|---------------|
| **Code** | ORA_SCM_XX_COSTMANAGE_VALIDATIONEXCEPTIONSADVISOR |
| **Description** | Provides validation exception details, cost organization context, and available cost organization names and IDs. |


### Function : getValidationExceptions
Description : Returns validation exception details for a cost book, cost organization, and accounting period.

| **Parameter Name** | **Description**|
|---------------|---------------|
| CostBookID | book iD |
| CostOrganizationId | org id |
| PeriodName | period name |

### Function : getLastRunDate
Description : Returns cost organization and cost book context for the selected organization and cost book name.

| **Parameter Name** | **Description**|
|---------------|---------------|
| CostOrganisationId | org id |
| CostBookId | book ID |

### Function : getOrganisationId
Description : Returns available cost organization names and IDs.

| **Parameter Name** | **Description**|
|---------------|---------------|
