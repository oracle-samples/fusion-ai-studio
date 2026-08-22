### RAG Document Tool

- Backend `type`: `RAG_DOCUMENT_TOOL`
- **Metadata:** `toolCode` (required)
- **Inputs:** `question`
- **Output:** Fixed `outputSpecification` (read-only in editor)

#### Structure

- A valid `RAG_DOCUMENT_TOOL` node must include:
  - `metadata.toolCode`
  - an input named `question`
  - outer `outcomes.success`
- `question` is required.
- `question` is a normal string-backed node input and should be stored as `type: "string"` with a string `value`.
- When using `do-create-node` or `do-modify-node`, set `metadataPatch.toolCode` to the selected document tool's real `toolCode`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.question` to the raw question string only.
- Do not pass nested input objects such as `{ "type": "string", "value": "..." }` for `question`.
- Do not pass full input objects such as `{ "id": "...", "name": "question", "type": "string", "value": "..." }`.
- `family` and `product` are selection filters in the editor. They help find the document tool, but they are not part of the persisted `RAG_DOCUMENT_TOOL` metadata contract.
- `RAG_DOCUMENT_TOOL` uses the normal outer `success` path. Do not invent a mandatory normal `failure` outcome.

#### Authoring rules

- Use `RAG_DOCUMENT_TOOL` when the workflow should ask a preconfigured document-retrieval tool to answer a question from a curated document collection.
- Do not use `RAG_DOCUMENT_TOOL` when the requirement is direct vector-index lookup by `indexName`; that is `VECTOR_DB_READER`.
- Do not invent `indexName`, `query`, `documentId`, `fields`, or vector-reader filter inputs on a `RAG_DOCUMENT_TOOL` node.
- `metadata.toolCode` must refer to a real selected document tool.
- If the selected document tool changes, the node should keep only the `question` input and clear any stale input set from the previous selection.
- The `question` should be the actual retrieval/query question for the document collection and may include normal workflow expressions.

#### Output schema contract

- `RAG_DOCUMENT_TOOL` uses a fixed read-only output schema.
- Persist the fixed `outputSpecification` on the node when creating or repairing the node artifact.
- The fixed output shape is an object with:
  - `value` (`string`)
  - `citations` (`array`)
- Each `citations` item is an object with:
  - `citedText` (`string`)
- Downstream references must follow that fixed schema.
- Valid downstream examples include:
  - `$context.$nodes.<RAG_CODE>.$output.value`
  - `$context.$nodes.<RAG_CODE>.$output.citations`
  - `$context.$nodes.<RAG_CODE>.$output.citations[0].citedText`
- Do not invent alternate output fields such as `answer`, `result`, `matches`, or `sources` unless the real product schema changes.

#### Invalid patterns

- Invalid: omitting `metadata.toolCode`
- Invalid: omitting the required `question` input
- Invalid: authoring `question` as a non-string input type
- Invalid: setting `inputsPatch.question` to a nested input object instead of the raw string value
- Invalid: using a full input-entry object for `question` inside `inputsPatch`
- Invalid: inventing `indexName` or `query` inputs on `RAG_DOCUMENT_TOOL`
- Invalid: treating `family` or `product` as persisted required node metadata
- Invalid: inventing a mandatory normal `failure` outcome on the `RAG_DOCUMENT_TOOL` node
- Invalid: omitting the fixed persisted `outputSpecification`
- Invalid: referencing `$output.result` or `$output.answer` instead of the fixed `value` / `citations` shape

#### Examples

Valid shape:

- `ANSWER_FROM_POLICY_DOCS.type = RAG_DOCUMENT_TOOL`
- `ANSWER_FROM_POLICY_DOCS.metadata.toolCode = HR_POLICY_DOCS`
- `ANSWER_FROM_POLICY_DOCS.inputs.question.type = string`
- `ANSWER_FROM_POLICY_DOCS.inputs.question = What is the parental leave policy for full-time employees in the US?`
- `ANSWER_FROM_POLICY_DOCS.outcomes.success = NEXT_NODE`
- `ANSWER_FROM_POLICY_DOCS.outputSpecification` is the fixed object schema with top-level `value` and `citations`

Valid expression-driven question:

- `ANSWER_FROM_FAQ_DOCS.type = RAG_DOCUMENT_TOOL`
- `ANSWER_FROM_FAQ_DOCS.metadata.toolCode = EMPLOYEE_FAQ_DOCS`
- `ANSWER_FROM_FAQ_DOCS.inputs.question.type = string`
- `ANSWER_FROM_FAQ_DOCS.inputs.question = {{$context.$system.$inputMessage}}`
- downstream may read `{{$context.$nodes.ANSWER_FROM_FAQ_DOCS.$output.value}}`
- downstream may read `{{$context.$nodes.ANSWER_FROM_FAQ_DOCS.$output.citations[0].citedText}}`

Invalid examples:

- Invalid: `inputsPatch.question = { "type": "string", "value": "What is the leave policy?" }`
- Invalid: `ANSWER_FROM_POLICY_DOCS.inputs.indexName = hr_policy_index`
- Invalid: `ANSWER_FROM_POLICY_DOCS.inputs.query = {{$context.$system.$inputMessage}}`
- Invalid: `ANSWER_FROM_POLICY_DOCS.outcomes.failure = HANDLE_RAG_FAILURE`
- Invalid: `{{$context.$nodes.ANSWER_FROM_POLICY_DOCS.$output.result.value}}`
- Invalid: `{{$context.$nodes.ANSWER_FROM_POLICY_DOCS.$output.answer}}`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
