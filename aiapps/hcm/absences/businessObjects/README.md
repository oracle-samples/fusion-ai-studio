# Business Objects
<br>

## Absence Details

| **Name** | Absence Details |
|---------------|---------------|
| **Code** | ORA_HCM_ABSENCES_XX_ABSENCEDETAILS |
| **Description** | The Absence Details Business Object provides access to records of employee absences within the HCM Absences product. It supports retrieving detailed absence balances for individuals through advanced search capabilities and includes related child resources to manage associated absence information. |


### Function : get_existing_absences
Description : This business object function fetches the existing balances of a person

| **Parameter Name** | **Description**|
|---------------|---------------|
| userContext | Indicates whether the user is viewing the data as an employee or manager. Supported values - EMP, MGR |
| startDate | Start date filter for absences |
| personId | Person id filter for absences |
