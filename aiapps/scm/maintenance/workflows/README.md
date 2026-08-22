# Maintenance Workflows

<!-- BEGIN GENERATED WORKFLOWS -->
<br/>

#### Workflow : Maintenance Material Readiness

| Workflow Name | Maintenance Material Readiness |
|---------------|---------------|
| **Code** | XX_MAINTENANCE_MATERIAL_READINESS |
| **Description** | Review organization-wide material readiness by identifying item shortages, available quantities, and the affected maintenance work orders that may be delayed due to insufficient materials. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraAppContext: OrganizationId is retrieved from OraAppContext<br>OraAction: Supported Actions: `actionMaterialReadiness` |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction.<br>InitDisplay - Retrieves material shortages for maintenance work orders using `Material Work Order Assignment Sequences` business object and displays the result as a table using `multiRecordWidget`. <br>Fields Displayed : Work Order Number, Work Order Description, Asset Number, Work Order Status, Item Shortages, Material Available Status. Supports an action on clicking Work Order Number with action `actionMaterialReadiness` with OrganizationId and WorkOrderNumber of the selected work order in the action payload.<br>InvokeAction :<br>actionMaterialReadiness - Displays material shortage details for that work order as a table using `multiRecordWidget`. <br>Fields Displayed : Op Seq, Material Seq, Item Number, Item Description, Required Date, Required Qty, Shortage Qty, UOM |

#### Workflow : Maintenance Material Shortage

| Workflow Name | Maintenance Material Shortage |
|---------------|---------------|
| **Code** | XX_MAINTENANCE_MATERIAL_SHORTAGE |
| **Description** | Analyze material shortages for selected maintenance work orders by showing required items, shortage quantities, and availability details needed to support timely work order execution. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraAppContext: OrganizationId is retrieved from OraAppContext<br>OraAction: Supported Actions: `actionMaterialShortageOrgs` |
| **Output Parameters** | This workflow supports InitDisplay and InvokeAction.<br>InitDisplay - Retrieves item shortage summaries using `Material Item Assignment Summaries` business object, enriches item availability using `On Hand Qty by Item` business object, retrieves unit of measure names using `Shortage Units of Measure` business object, and displays the result as a table using `multiRecordWidget`. <br>Fields Displayed : Item, Required Qty, Shortage Qty, UOM, Orgs with Stocks, Item Description. Supports an action on clicking Item with action `actionMaterialShortageOrgs` with OrganizationId and InventoryItemId of the selected item in the action payload.<br>InvokeAction :<br>actionMaterialShortageOrgs - Displays item availability across organizations for an item as a table using `multiRecordWidget`. <br>Fields Displayed : Organization, Available Quantity, UOM. |

#### Workflow : Work Execution Open Exceptions

| Workflow Name | Work Execution Open Exceptions |
|---------------|---------------|
| **Code** | XX_WORK_EXECUTION_EXCEPTIONS |
| **Description** | Monitor open production exceptions by reviewing unresolved manufacturing issues, severity, and related work execution details so teams can prioritize actions and reduce operational disruption. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraAppContext: OrganizationId is retrieved from OraAppContext |
| **Output Parameters** | This workflow retrieves open production exceptions using `Open Production Exceptions` business object and displays the result using `messageListWidget`.<br>Fields displayed : Exception Number, Exception Type, Affected Operations, Reported By, Severity, Reported Date |

#### Workflow : Current Work Orders

| Workflow Name | Current Work Orders |
|---------------|---------------|
| **Code** | XX_WORK_ORDER_CURRENT |
| **Description** | Work orders that are actively in progress or ready for execution within the selected organization. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraAppContext: OrganizationId is retrieved from OraAppContext |
| **Output Parameters** | This workflow retrieves current work orders using `Maintenance Work Order Searches By Filters` business object and displays the result using `messageListWidget`.<br>Fields displayed : Work Order Number, Asset Number, Asset Description, Work Order Status, Planned Start Date |

#### Workflow : Future Work Orders

| Workflow Name | Future Work Orders |
|---------------|---------------|
| **Code** | XX_WORK_ORDER_FUTURE |
| **Description** | Work orders scheduled for upcoming execution, helping teams prepare resources, materials, and timelines in advance. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraAppContext: OrganizationId is retrieved from OraAppContext |
| **Output Parameters** | This workflow retrieves future work orders using `Maintenance Work Order Searches By Filters` business object and displays the result using `messageListWidget`.<br>Fields displayed : Work Order Number, Asset Number, Asset Description, Work Order Status, Planned Start Date |

#### Workflow : Overdue Work Orders

| Workflow Name | Overdue Work Orders |
|---------------|---------------|
| **Code** | XX_WORK_ORDER_OVERDUE |
| **Description** | Work orders that have passed their planned completion date and require attention to reduce delay and backlog. |
| **Exposed to Agentic Apps** | Yes |
| **Input Parameters** | OraAppContext: OrganizationId is retrieved from OraAppContext |
| **Output Parameters** | This workflow retrieves overdue work orders using `Maintenance Work Order Searches By Filters` business object and displays the result using `messageListWidget`.<br>Fields displayed : Work Order Number, Asset Number, Asset Description, Work Order Status, Planned Start Date |
<!-- END GENERATED WORKFLOWS -->
