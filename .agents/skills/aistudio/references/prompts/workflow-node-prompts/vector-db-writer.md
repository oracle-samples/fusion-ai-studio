### Vector DB Writer

- Backend `type`: `VECTOR_DB_WRITER`
- **Inputs:** `operation`, `indexName`, `content`, `contentType`
- **Optional inputs:** `payload` (bulk uploads), `documentId`, `parentObjectId`, `grandParentObjectId`, `metaData` (array of `{ id, name, type, value }`)
- **Metadata:** `bulkMode` (boolean) — when `true`, authoring shifts to `payload` and schema definitions

#### Structure

- A valid `VECTOR_DB_WRITER` node must include:
  - an input named `operation`
  - an input named `indexName`
  - either:
    - non-bulk mode with inputs `content` and `contentType`, or
    - bulk mode with `metadata.bulkMode = true` and an input named `payload`
  - outer `outcomes.success`
- `bulkMode` is a node metadata field, not an input.
- `metaData` is a node input, not node metadata.
- `metaData` is the document-properties/schema input for this node. Do not confuse `metaData` with the node's top-level `metadata` object.
- `operation` is required.
- `indexName` is required.
- In non-bulk mode, `content` and `contentType` are required.
- In bulk mode, `payload` is required and `content` / `contentType` are not required by validation.

#### Authoring rules

- Use `VECTOR_DB_WRITER` when the workflow should write or update content in a vector index.
- `operation` should use a real editor-supported operation value from the operation LOV. Do not invent operation names from stale docs.
- `indexName` should identify the target vector index.
- In non-bulk mode:
  - use `content` for the text/content being written
  - use `contentType` for the content's type/format
  - `documentId`, `parentObjectId`, and `grandParentObjectId` may be supplied when the write should be tied to known object lineage
- In bulk mode:
  - set `metadata.bulkMode = true`
  - use `payload` as the main bulk input
  - the properties section becomes schema-style metadata definitions, so property entries may omit per-property `value`
- The editor may auto-seed `payload` from `content` when bulk mode is enabled. That convenience behavior does not change the persisted contract: bulk mode still uses `payload`.
- `metaData` should be authored as an array of property objects shaped like `{ id, name, type, value }`.
- `metaData` property names must be unique and non-empty.
- Supported property `type` values in the editor are `string`, `number`, and `date`.
- When using `do-create-node` or `do-modify-node`, each `inputsPatch.<field>` value must be the final stored value only, not a nested input-entry object.
- Preserve the real stored type of each field. Do not flatten `metaData` into a JSON string.
- `VECTOR_DB_WRITER` uses the normal outer `success` path. Do not invent a mandatory normal `failure` outcome.

#### Output schema contract

- Do not assume a fixed read-only output schema for `VECTOR_DB_WRITER`; the writer editor does not publish one like `VECTOR_DB_READER`.
- Unless the existing workflow or product behavior already establishes a concrete writer output schema, avoid inventing downstream field-level references from `VECTOR_DB_WRITER.$output`.
- If a downstream step needs writer results, prefer relying on workflow control flow or other documented producer nodes rather than guessing writer response fields.

#### Invalid patterns

- Invalid: omitting the required `operation` input
- Invalid: omitting the required `indexName` input
- Invalid: in non-bulk mode, omitting `content`
- Invalid: in non-bulk mode, omitting `contentType`
- Invalid: in bulk mode, omitting `payload`
- Invalid: putting `bulkMode` into `inputsPatch` instead of metadata
- Invalid: putting document properties into node metadata instead of the `metaData` input
- Invalid: flattening `metaData` into a string instead of an array of `{ id, name, type, value }` objects
- Invalid: using duplicate or blank property names inside `metaData`
- Invalid: inventing unsupported property types outside `string`, `number`, and `date`
- Invalid: inventing a mandatory normal `failure` outcome on the `VECTOR_DB_WRITER` node
- Invalid: hardcoding stale operation rules such as "only INSERT, UPDATE, DELETE are valid" when the real editor LOV may provide different values

#### Examples

Valid non-bulk shape:

- `INDEX_EMPLOYEE_NOTE.type = VECTOR_DB_WRITER`
- `INDEX_EMPLOYEE_NOTE.inputs.operation.type = string`
- `INDEX_EMPLOYEE_NOTE.inputs.operation = UPSERT`
- `INDEX_EMPLOYEE_NOTE.inputs.indexName.type = string`
- `INDEX_EMPLOYEE_NOTE.inputs.indexName = employee_notes_index`
- `INDEX_EMPLOYEE_NOTE.inputs.content.type = string`
- `INDEX_EMPLOYEE_NOTE.inputs.content = {{$context.$nodes.PREPARE_NOTE_TEXT.$output.result.noteText}}`
- `INDEX_EMPLOYEE_NOTE.inputs.contentType.type = string`
- `INDEX_EMPLOYEE_NOTE.inputs.contentType = text/plain`
- `INDEX_EMPLOYEE_NOTE.inputs.documentId.type = string`
- `INDEX_EMPLOYEE_NOTE.inputs.documentId = {{$context.$workflow.noteDocumentId}}`
- `INDEX_EMPLOYEE_NOTE.inputs.metaData = [{ "id": "1", "name": "employeeId", "type": "string", "value": "{{$context.$workflow.employeeId}}" }]`
- `INDEX_EMPLOYEE_NOTE.outcomes.success = NEXT_NODE`

Valid bulk shape:

- `BULK_INDEX_FAQS.type = VECTOR_DB_WRITER`
- `BULK_INDEX_FAQS.metadata.bulkMode = true`
- `BULK_INDEX_FAQS.inputs.operation.type = string`
- `BULK_INDEX_FAQS.inputs.operation = OVERWRITE`
- `BULK_INDEX_FAQS.inputs.indexName.type = string`
- `BULK_INDEX_FAQS.inputs.indexName = faq_index`
- `BULK_INDEX_FAQS.inputs.payload = {{$context.$nodes.PREPARE_FAQ_PAYLOAD.$output.result.records}}`
- `BULK_INDEX_FAQS.inputs.metaData = [{ "id": "schema1", "name": "category", "type": "string", "value": "" }, { "id": "schema2", "name": "publishedOn", "type": "date", "value": "" }]`
- `BULK_INDEX_FAQS.outcomes.success = REFRESH_SEARCH`

Invalid examples:

- Invalid: `inputsPatch.bulkMode = true`
- Invalid: `INDEX_EMPLOYEE_NOTE.metadata.metaData = [{ "name": "employeeId", "type": "string", "value": "123" }]`
- Invalid: `INDEX_EMPLOYEE_NOTE.inputs.metaData = "[{\"name\":\"employeeId\"}]"`
- Invalid: `BULK_INDEX_FAQS.metadata.bulkMode = true` with no `payload`
- Invalid: `INDEX_EMPLOYEE_NOTE.outcomes.failure = HANDLE_VECTOR_WRITE_ERROR`
- Invalid: forcing the stale rule `operation = INSERT | UPDATE | DELETE` as if those are the only supported values
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
