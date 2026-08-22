# Business Objects
<br>



## Business Object : Shortage Units of Measure


| **Name** | Shortage Units of Measure |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORY_XX_SHORTAGE_UOM |
| **Description** | The Shortage Units of Measure Business Object provides access to units of measure specifically used for shortage-related inventory processes. |

### Functions

#### Function : get_unitsOfMeasure
Description : Retrieves specific units of measure. This function accesses the Shortage Units of Measure resource to filter and return relevant unit details based on provided criteria.

| **Parameter Name** | **Description**|
|---------------|---------------|
| fields | This parameter filters the resource fields returned by the service. |
| onlyData | When true, the response contains only data and excludes links. |
| limit | Restricts the number of records returned. |
| offset | Defines the starting position of the resource collection. |
| uomCodeList | Specifies a comma-separated list of single-quoted unit of measure codes (UOMCode) used to filter and retrieve only the relevant shortage units of measure. This parameter is required to identify which units to include in the inventory shortage query. |

## Business Object : Material Item Assignment Summaries


| **Name** | Material Item Assignment Summaries |
|---------------|---------------|
| **Code** | ORA_SCM_MAINTENANC_XX_MATERIALITEMASSIGNMENTSUMMARIES |
| **Description** | Material Item Assignment Summaries provides an overview of material requirements and shortage summaries for items within an organization. It supports retrieval of key information to help manage and monitor material assignments in maintenance operations. |

### Functions

#### Function : oraScmMnt_materialAssignmentSummary_byOrganization
Description : Retrieves a summary of material shortages for items within a specified organization, providing key information to support management and monitoring of material assignments in maintenance operations.

| **Parameter Name** | **Description**|
|---------------|---------------|
| OrganizationId | Organization identifier used in the fixed material shortage summaries query. |

## Business Object : Material Work Order Assignment Sequences


| **Name** | Material Work Order Assignment Sequences |
|---------------|---------------|
| **Code** | ORA_SCM_MAINTENANC_XX_MATERIALWORKORDERASSIGNMENTSEQUENCES |
| **Description** | Material Work Order Assignment Sequences provides visibility into material requirements and shortages for maintenance work orders, enabling retrieval of material availability and shortage information within specified timeframes or for specific work orders. It supports efficient planning and management of materials needed to complete assigned operations in maintenance processes. |

### Functions

#### Function : oraScmMnt_materialAssignments_shortageForDateRange
Description : Get material shortage for a specific Org in an given time period

| **Parameter Name** | **Description**|
|---------------|---------------|
| fromPlannedStartDate | Specifies the start date of the planned period to filter material requirements for work order operations. This required input defines the beginning of the date range used to retrieve relevant assignment sequences. |
| toPlannedStartDate | Specifies the end date of the planned period to filter material requirements for work order operations. This required input defines the closing date of the date range used to retrieve relevant assignment sequences. |
| pOrganizationId | Specifies the unique identifier of the organization to filter material requirements for work order operations within the selected date range. This required input ensures the data retrieved is specific to the given organization. |
| pLimit | Specifies the maximum number of material assignment records to retrieve for the selected organization and date range. |
| pOffset | Specifies the starting position for retrieving material assignment records within the selected organization and date range. |

#### Function : oraScmMnt_materialAssignments_materialShortageForWo
Description : Get material shortage of work order along with specific item shortage quantities

| **Parameter Name** | **Description**|
|---------------|---------------|
| workOrderNumberList | A required input parameter that specifies one or more work order numbers to filter the material requirements and shortages for the selected work orders. Provide the work order numbers as a comma-separated, single-quoted list to retrieve relevant assignment sequences. |
| pLimit | Specifies the maximum number of material assignment sequence records to return for the selected work orders. Provide this integer value to limit the result set size when retrieving material shortage details. |
| pOffset | Specifies the starting position within the result set to begin retrieving material assignment sequence records. Provide this integer value to paginate results when viewing material shortages for the selected work orders. |

## Business Object : Maintenance Work Order Searches By Filters


| **Name** | Maintenance Work Order Searches By Filters |
|---------------|---------------|
| **Code** | ORA_SCM_MAINTENANC_XX_WO_SEARCHES |
| **Description** | This Business Object enables retrieval of maintenance work order records by applying various filters, including date ranges and organizational criteria. It supports flexible search operations to efficiently access detailed work order information within the maintenance domain. |

### Functions

#### Function : oraScmMnt_searchWorkOrders_filters_query
Description : Retrieve work orders based on filters and query

| **Parameter Name** | **Description**|
|---------------|---------------|
| pEndRange | Specifies the planned completion end date for filtering maintenance work orders, formatted as YYYY-MM-DD. This required parameter is used as an input to define the upper limit of the completion date range in the search criteria. |
| pOrganizationId | Specifies the organization ID to identify and filter maintenance work orders in the search. This required parameter must contain digits only and is used as an input to limit results to the relevant organization. |
| pWorkOrders | Specifies the maintenance work order identifiers to filter the search results. This required input parameter should be provided in the request body to retrieve details for specific work orders. |
| pOffset | Specifies the starting position for retrieving maintenance work order results, enabling pagination of the search output. This required input parameter should be provided to control which subset of records is returned in the response. |

#### Function : oraScmMnt_searchWorkOrders_dates_and_org
Description : Retrieve work orders based on dates provided for range start and range end, along with organizationId

| **Parameter Name** | **Description**|
|---------------|---------------|
| pWorkOrders | Specifies the work order identifiers to retrieve details for. This required input parameter filters the search results to include only the listed maintenance work orders within the specified date range and organization. |
| pStartRange | Specifies the start date of the date range used to filter maintenance work orders. This required input parameter defines the beginning of the period for which work order details are retrieved. Provide this value to limit the search results to work orders created or updated on or after this date. |
| pEndRange | Specifies the end date of the date range used to filter maintenance work orders. Provide this value to limit the search results to work orders created or updated on or before this date. This required input parameter works alongside the start range to define the search period. |
| pOrganizationId | Specifies the organization identifier used to filter maintenance work orders within the search. This required input parameter must be a numeric string and ensures that only work orders belonging to the given organization are retrieved. Provide this value to limit results to a specific organization. |
| pOffset | Specifies the starting point for retrieving maintenance work order results within the filtered search. Provide this integer value to control the offset for paginated results when querying work orders by date range and organization. This parameter is required to manage result navigation. |

## Business Object : Open Production Exceptions


| **Name** | Open Production Exceptions |
|---------------|---------------|
| **Code** | ORA_SCM_MANUFACTURING_XX_PROD_EXPV2 |
| **Description** | The Open Production Exceptions Business Object provides access to current unresolved production issues within manufacturing operations. It supports retrieving detailed records of open exceptions using filtering, sorting, and pagination to help monitor and manage production disruptions effectively. |

### Functions

#### Function : get_openProductionExceptions
Description : Get open production exceptions using filters, sort order, pagination, and selected fields.

| **Parameter Name** | **Description**|
|---------------|---------------|
| fields | Specifies the list of data fields to include in the response for each open production exception record. This parameter is required to define which details are returned when retrieving unresolved production issues. |
| onlyData | Specifies whether to return only the core data records without any additional framework metadata. |
| organizationId | Manufacturing organization identifier used in the fixed open production exceptions query. |
| limit | Maximum number of records to return. |
| offset | Starting offset for pagination. |

## Business Object : On Hand Qty by Item


| **Name** | On Hand Qty by Item |
|---------------|---------------|
| **Code** | ORA_SCM_PRODUCTMAN_XX_ONHANDQTYBYITEM |
| **Description** | The On Hand Qty by Item Business Object provides detailed retrieval of current inventory quantities for specified items within an organization, including measurements in primary and secondary units. It supports read-only access to on-hand quantity data, enabling visibility into available stock levels for effective product and supply chain management. |

### Functions

#### Function : getall_onhandQuantityDetails
Description : Retrieves detailed on-hand quantity information for a specified item number within an organization, including primary and secondary unit of measure data. This function accesses inventory details through the onhandQuantityDetails resource.

| **Parameter Name** | **Description**|
|---------------|---------------|
| ItemId | Specifies the unique identifier of the product or item for which on-hand quantity details are retrieved. This required parameter is used as an input token to filter inventory information for the specified item. |
