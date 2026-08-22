# Business Objects
<br>


## Fetch Default Organization

| **Name** | Fetch Default Organization |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORYM_XX_FETCHESDEFAULTO |
| **Description** | Fetches the default organization of the user |


### Function : get_default_organization
Description : Fetches the default organization of the user

| **Parameter Name** | **Description**|
|---------------|---------------|

## Inventory Organizations List

| **Name** | Inventory Organizations List |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORYM_XX_INVENTORYORGANIZATIONSLIST |
| **Description** | Retrieves the list of inventory organizations accessible to the user, including the OrganizationName , which can be used to display and switch the active inventory organization context. |


### Function : searchOrganizationsByName
Description : Searches accessible inventory organizations by OrganizationName or OrganizationCode using a server-side case-insensitive query predicate.

| **Parameter Name** | **Description**|
|---------------|---------------|
| SearchQuery | Organization Name |

### Function : getOrganizationsNameAndId
Description : Retrieves the list of inventory organizations accessible to the user, including the OrganizationName, which can be used to display and switch the active inventory organization context.

| **Parameter Name** | **Description**|
|---------------|---------------|

### Function : getDefaultOrganizationName
Description : For getting the default organization name

| **Parameter Name** | **Description**|
|---------------|---------------|
| ProfileOptionValue | Profile  option value |

## Expiring Inventory Lots

| **Name** | Expiring Inventory Lots |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORYM_XX_EXPIRING_INVENTORY_LOTS |
| **Description** | Retrieves on-hand inventory lots for a specified inventory organization whose expiration dates fall within a date range beginning today, enabling warehouse and inventory teams to identify lots expiring in the coming days. The start date, end date, and organization ID are required inputs. |


### Function : GetExpiringInventoryLots
Description : Retrieves on-hand inventory lots for a specified inventory organization whose expiration dates fall within a date range beginning today.

| **Parameter Name** | **Description**|
|---------------|---------------|
| currentDate | Start of the expiration window in YYYY-MM-DD format. Supply the current date at runtime. |
| endDate | End of the upcoming expiration window in YYYY-MM-DD format. |
| pOrganizationId | Unique identifier of the inventory organization whose expiring lots are requested. |

## Fetch Items Awaiting Inspection

| **Name** | Fetch Items Awaiting Inspection |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORYM_XX_FETCHITEMSAWAITINGINSPECTION |
| **Description** | Fetches the items that are awaiting inspection in an inventory organization. The organization ID is required as input. |


### Function : fetch_items_awaiting_inspection
Description : Fetches the items that are awaiting inspection in a particular inventory organization.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pOrganizationId | Unique identifier of the inventory organization. |

## Retrieve Item Stockout Subinventory Locations BO

| **Name** | Retrieve Item Stockout Subinventory Locations BO |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORYM_XX_RETRIEVEITEMSTOCKOUTSUBINVENTORYLOCATIONSBO |
| **Description** | Retrieves the list of subinventories where a particular item is stocked out using the organization ID and item number. |


### Function : fetch_item_stockout_subinventories
Description : Retrieves the list of subinventories where a particular item is stocked out.

| **Parameter Name** | **Description**|
|---------------|---------------|
| pCatalogId | Inventory item catalog identifier. |
| pCategoryId | Inventory item category identifier. |
| pOrganizationId | Inventory organization identifier. |
| pItemNumber | Inventory item number used to retrieve the subinventory locations where the item is stocked out. |

## Transfer Lots to Stockout Subinventories

| **Name** | Transfer Lots to Stockout Subinventories |
|---------------|---------------|
| **Code** | ORA_SCM_INVENTORYM_XX_TRANSFER_LOTS_TO_STOCKOUT_SUBINVENTORIES |
| **Description** | Transfers a particular inventory lot to a stockout subinventory. |


### Function : create_inventoryStagedTransactions
Description : Creates a subinventory transfer for a selected expiring lot to a subinventory where the item is stocked out.

| **Parameter Name** | **Description**|
|---------------|---------------|
| OrganizationId | Unique identifier of the inventory organization where the lot transfer is processed. |
| CurrentSystemDate | Current system date in ISO 8601 format with a time-zone offset, for example, 2026-08-05T12:34:00+05:30. |
| TransactionQuantity | On-hand quantity to transfer. |
| SubinventoryCode | Code of the source subinventory containing the expiring lot. |
| DestinationSubinventoryCode | Code of the destination subinventory where the item is stocked out. |
| ItemNumber | Item number associated with the lot being transferred. |
| LotNumber | Lot number to transfer to the stockout subinventory. |
