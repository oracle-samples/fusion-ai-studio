# Business Objects

## Compliance Checklist

| **Name** | Compliance Checklist |
|---|---|
| **Code** | ORA_PRC_PURCHASING_XX_COMPLIANCECHECKLIST |
| **Description** | Retrieves active compliance checklist items for review and follow-up. |

### Function: `fetchComplianceChecklists`

Retrieves active compliance checklist items for review.

| **Parameter Name** | **Description** |
|---|---|
| — | No parameters required. |

## Purchase Agreements

| **Name** | Purchase Agreements |
|---|---|
| **Code** | ORA_PRC_PURCHASING_XX_MANAGEPURCHASEAGREEMENTS |
| **Description** | Provides purchase agreement summary metrics and filtered purchase agreement details for a selected reporting period. |

### Function: `fetchPurchaseAgreementCounts`

Retrieves purchase agreement counts for the reporting period.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date for the reporting period. |
| endDate | End date for the reporting period. |

### Function: `fetchAllPurchaseAgreements`

Retrieves purchase agreements.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date for the reporting period. |
| endDate | End date for the reporting period. |

### Function: `fetchDraftAndRejectedPurchaseAgreements`

Retrieves draft and rejected purchase agreements.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchPurchaseAgreementsWithProcessingErrors`

Retrieves purchase agreements with processing errors.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchPurchaseAgreementsExpiringIn30Days`

Retrieves purchase agreements expiring in 30 days.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchPurchaseAgreementStatusFacets`

Retrieves purchase agreement counts grouped by status for the reporting period.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date for the reporting period. |
| endDate | End date for the reporting period. |

### Function: `fetchExpiringPurchaseAgreementCounts`

Retrieves counts of purchase agreements approaching expiration for the reporting period.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date for the reporting period. |
| endDate | End date for the reporting period. |

## Manage Purchase Orders

| **Name** | Manage Purchase Orders |
|---|---|
| **Code** | ORA_PRC_PURCHASING_XX_MANAGEPURCHASEORDERS |
| **Description** | Provides purchase order counts and details for a selected category. |

### Function: `fetchPurchaseOrderCounts`

Retrieves purchase order counts for key categories.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchOverduePurchaseOrders`

Retrieves overdue purchase orders.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchDraftAndRejectedPurchaseOrders`

Retrieves draft and rejected purchase orders.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchInvoiceHoldPurchaseOrders`

Retrieves purchase orders on invoice hold.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchProcessingErrorPurchaseOrders`

Retrieves purchase orders with processing errors.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date. |
| endDate | End date. |

### Function: `fetchPurchaseOrderStatusFacets`

Retrieves purchase order status counts.

| **Parameter Name** | **Description** |
|---|---|
| startDate | Start date for the reporting period. |
| endDate | End date for the reporting period. |

## My Requisitions

| **Name** | My Requisitions |
|---|---|
| **Code** | ORA_PRC_PURCHASING_XX_MYREQUISITIONS |
| **Description** | Retrieves the signed-in user's most recent purchase requisitions and their current statuses. |

### Function: `fetchRecentPurchaseRequisitions`

Retrieves the signed-in user's most recent purchase requisitions, including their current status and line details.

| **Parameter Name** | **Description** |
|---|---|
| — | No parameters required. |
