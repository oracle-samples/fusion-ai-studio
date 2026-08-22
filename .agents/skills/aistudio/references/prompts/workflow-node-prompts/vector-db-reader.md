### Vector DB Reader

- Backend `type`: `VECTOR_DB_READER`
- **Inputs (not exhaustive):** `indexName`, `query`, `documentId`, `parentObjectId`, `grandParentObjectId`, `fields`, `filterCriteria`, `maximumResults`
- **Output:** Fixed `outputSpecification` (read-only in editor)

#### Structure

- A valid `VECTOR_DB_READER` node must include:
  - an input named `indexName`
  - at least one of:
    - `query`
    - `documentId`
    - `parentObjectId`
    - `grandParentObjectId`
  - outer `outcomes.success`
- Supported persisted input types in this workflow builder are:
  - `indexName`: `string`
  - `query`: `string`
  - `documentId`: `string`
  - `parentObjectId`: `string`
  - `grandParentObjectId`: `string`
  - `fields`: `array`
  - `filterCriteria`: `object`
  - `maximumResults`: `integer`
- `indexName` is required.
- `query` is optional by itself, but the node is invalid if all of `query`, `documentId`, `parentObjectId`, and `grandParentObjectId` are empty.
- `VECTOR_DB_READER` uses the normal outer `success` path. Do not invent a mandatory normal `failure` outcome.

#### Authoring rules

- Use `VECTOR_DB_READER` when the workflow should query an existing vector index directly.
- Use `indexName` to name the target vector index.
- Use `query` for semantic search text.
- Use `documentId`, `parentObjectId`, or `grandParentObjectId` when the retrieval should be scoped to a known document/object lineage.
- `fields` should remain an array-valued input.
- `filterCriteria` should remain an object-valued input.
- `maximumResults` should remain an integer-valued input.
- When using `do-create-node` or `do-modify-node`, each `inputsPatch.<field>` value must be the final stored value only, not a nested input-entry object.
- Preserve the real field type for each input. Do not flatten `fields` or `filterCriteria` into fake string payloads just because they are passed through `inputsPatch`.
- Do not invent unsupported reader inputs such as `maximumChunks` or `minimumSimilarityPercentage`.

#### Output schema contract

- `VECTOR_DB_READER` uses a fixed/read-only `outputSpecification`.
- The fixed output shape is an array.
- Each array item is an object with only these documented fields:
  - `index` (`integer`)
  - `text` (`string`)
- Downstream references must be limited to fields that exist in that fixed schema.
- Do not invent response field paths that are not present in the node's effective `outputSpecification`.
- Because the top-level output is an array, downstream logic should treat `$output` as a list of matches, not as a single object.
- Do not reference invented fields such as similarity score, metadata, title, or chunk id unless the real fixed schema has been changed by the product.

#### Invalid patterns

- Invalid: omitting the required `indexName` input
- Invalid: leaving `query`, `documentId`, `parentObjectId`, and `grandParentObjectId` all empty
- Invalid: authoring `indexName`, `query`, `documentId`, `parentObjectId`, or `grandParentObjectId` as non-string inputs
- Invalid: authoring `fields` as a non-array input type
- Invalid: authoring `filterCriteria` as a non-object input type
- Invalid: authoring `maximumResults` as a non-integer input type
- Invalid: setting any `inputsPatch.<field>` value to a nested input object instead of the final persisted value
- Invalid: inventing unsupported inputs such as `maximumChunks` or `minimumSimilarityPercentage`
- Invalid: inventing a mandatory normal `failure` outcome on the `VECTOR_DB_READER` node
- Invalid: referencing `$context.$nodes.<VECTOR_NODE>.$output.text` as if the top-level output were a single object
- Invalid: referencing item fields that are not in the fixed output schema

#### Examples

Valid semantic-search shape:

- `SEARCH_POLICY_INDEX.type = VECTOR_DB_READER`
- `SEARCH_POLICY_INDEX.inputs.indexName.type = string`
- `SEARCH_POLICY_INDEX.inputs.indexName = employee_policy_index`
- `SEARCH_POLICY_INDEX.inputs.query.type = string`
- `SEARCH_POLICY_INDEX.inputs.query = {{$context.$system.$inputMessage}}`
- `SEARCH_POLICY_INDEX.inputs.maximumResults.type = integer`
- `SEARCH_POLICY_INDEX.inputs.maximumResults = 5`
- `SEARCH_POLICY_INDEX.outcomes.success = SUMMARIZE_MATCHES`
- downstream logic treats `SEARCH_POLICY_INDEX.$output` as an array of `{ index, text }` items

Valid document-scoped shape:

- `LOOKUP_EMPLOYEE_NOTES.type = VECTOR_DB_READER`
- `LOOKUP_EMPLOYEE_NOTES.inputs.indexName.type = string`
- `LOOKUP_EMPLOYEE_NOTES.inputs.indexName = employee_notes_index`
- `LOOKUP_EMPLOYEE_NOTES.inputs.documentId.type = string`
- `LOOKUP_EMPLOYEE_NOTES.inputs.documentId = {{$context.$nodes.GET_EMPLOYEE_NOTE_DOC.$output.result.documentId}}`
- `LOOKUP_EMPLOYEE_NOTES.inputs.fields.type = array`
- `LOOKUP_EMPLOYEE_NOTES.inputs.fields = ["text"]`
- `LOOKUP_EMPLOYEE_NOTES.inputs.filterCriteria.type = object`
- `LOOKUP_EMPLOYEE_NOTES.inputs.filterCriteria = {"employeeId":"{{$context.$workflow.employeeId}}"}`
- `LOOKUP_EMPLOYEE_NOTES.outcomes.success = NEXT_NODE`

Invalid examples:

- Invalid: `inputsPatch.indexName = { "type": "string", "value": "employee_policy_index" }`
- Invalid: `SEARCH_POLICY_INDEX.inputs.maximumChunks = 10`
- Invalid: `SEARCH_POLICY_INDEX.outcomes.failure = HANDLE_VECTOR_ERROR`
- Invalid: `{{$context.$nodes.SEARCH_POLICY_INDEX.$output.text}}`
- Invalid: `{{$context.$nodes.SEARCH_POLICY_INDEX.$output[0].score}}`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
