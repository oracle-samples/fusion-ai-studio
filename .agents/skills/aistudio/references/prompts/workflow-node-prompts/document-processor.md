### Document Processor

- Backend `type`: `DOCUMENT_PROCESSOR`
- **Metadata:** `businessObjectCode`, `functionName`, `type`, `extractWithLlm`, `template`
- **Inputs:** dynamic token parameters from the selected function only
- **Output:** mode-dependent

#### Structure

- A valid `DOCUMENT_PROCESSOR` node must include:
  - `metadata.businessObjectCode`
  - `metadata.functionName`
  - outer `outcomes.success`
- `family` and `product` are editor search filters only. They help find the business object, but they are not part of the persisted node contract.
- The editor forces `metadata.type = BO_FUNCTION` for this node. Do not invent old backend types such as `adfBc` or `boss`.
- Inputs are derived from the selected function's token parameters only (`isToken === true`).
- When using `do-create-node` or `do-modify-node`, each `inputsPatch.<parameterName>` value must be the final parameter value itself, not a nested input-entry object.
- Preserve the selected token parameter type when authoring each input.
- If the selected function changes, stale parameter inputs from the previous function must not remain on the node.
- `DOCUMENT_PROCESSOR` uses the normal outer `success` path. Do not invent a mandatory normal `failure` outcome.

#### Extraction modes

- `DOCUMENT_PROCESSOR` has two distinct extraction modes:
  - default extraction mode with `metadata.extractWithLlm` absent or `false`
  - LLM extraction mode with `metadata.extractWithLlm = true`

#### Default extraction mode

- In default extraction mode, `metadata.extractWithLlm` should be absent or `false`.
- In default extraction mode, `metadata.template` should be absent or `null`.
- In default extraction mode, the node uses a fixed read-only `outputSpecification`.
- Persist that fixed `outputSpecification` on the node when creating or repairing the node artifact.
- The fixed default extraction output shape is:
  - top-level object
  - field `text` (`string`)
- In default extraction mode, downstream references should use the fixed shape, for example:
  - `$context.$nodes.<DOC_PROCESSOR_CODE>.$output.text`

#### LLM extraction mode

- In LLM extraction mode, set `metadata.extractWithLlm = true`.
- In LLM extraction mode, `metadata.template` is required.
- In LLM extraction mode, the effective output schema comes from the selected template specification.
- In LLM extraction mode, do not keep the fixed default `{"text": ...}` output schema on the node; clear the node's own `outputSpecification` and rely on the selected template's schema.
- In LLM extraction mode, downstream references must match the selected template schema, not the default fixed `text` shape unless the template really defines `text`.
- LLM extraction mode also exposes model configuration fields. Treat those like LLM-style metadata, not node inputs.
- If LLM extraction is turned off, clear `metadata.template`, clear LLM model configuration, and restore the fixed default `text` output schema.

#### Authoring rules

- Use `DOCUMENT_PROCESSOR` when the workflow should call a BO-backed document processing function and extract document text or template-shaped structured output.
- Do not model this node using the stale `documentIdentifierList` contract from older docs; the current editor uses dynamic token inputs from the selected function instead.
- Do not guess `businessObjectCode` or `functionName`.
- After changing `businessObjectCode`, reselect `functionName` for the new business object instead of carrying over a stale function.
- After changing `functionName`, replace the prior token inputs with only the token parameters exposed by the newly selected function.
- If `extractWithLlm` is enabled, a real template must be selected before the node is complete.

#### Output schema contract

- `DOCUMENT_PROCESSOR` is mode-dependent:
  - default extraction mode uses a fixed read-only `outputSpecification` with top-level `text`
  - LLM extraction mode uses the selected template's schema and not the default fixed `text` schema
- Downstream `$output` references must match the active extraction mode.
- Invalid in default extraction mode: inventing output fields other than the fixed top-level `text`.
- Invalid in LLM extraction mode: hardcoding `$output.text` unless the selected template actually defines `text`.

#### Invalid patterns

- Invalid: omitting `metadata.businessObjectCode`
- Invalid: omitting `metadata.functionName`
- Invalid: persisting editor filter values such as `family` or `product` as if they were required `DOCUMENT_PROCESSOR` metadata
- Invalid: setting `metadata.type` to stale values like `adfBc` or `boss`
- Invalid: inventing a `documentIdentifierList` input on this node
- Invalid: leaving stale parameter inputs from a previous function after `functionName` changes
- Invalid: in LLM extraction mode, omitting `metadata.template`
- Invalid: in LLM extraction mode, keeping the old fixed `text` output schema as if it were still active
- Invalid: inventing a mandatory normal `failure` outcome on the `DOCUMENT_PROCESSOR` node
- Invalid: referencing downstream `$output` fields that are not valid for the node's active extraction mode

#### Examples

Valid default extraction shape:

- `EXTRACT_RESUME_TEXT.type = DOCUMENT_PROCESSOR`
- `EXTRACT_RESUME_TEXT.metadata.type = BO_FUNCTION`
- `EXTRACT_RESUME_TEXT.metadata.businessObjectCode = ORA_HCM_RESUME_DOCS`
- `EXTRACT_RESUME_TEXT.metadata.functionName = extractResumeText`
- `EXTRACT_RESUME_TEXT.inputs.documentId = {{$context.$nodes.GET_RESUME_DOC.$output.result.documentId}}`
- `EXTRACT_RESUME_TEXT.metadata.extractWithLlm = false`
- `EXTRACT_RESUME_TEXT.outputSpecification` is the fixed schema with top-level `text`
- downstream may read `{{$context.$nodes.EXTRACT_RESUME_TEXT.$output.text}}`

Valid LLM extraction shape:

- `EXTRACT_INVOICE_FIELDS.type = DOCUMENT_PROCESSOR`
- `EXTRACT_INVOICE_FIELDS.metadata.type = BO_FUNCTION`
- `EXTRACT_INVOICE_FIELDS.metadata.businessObjectCode = ORA_FIN_AP_INVOICE_DOCS`
- `EXTRACT_INVOICE_FIELDS.metadata.functionName = extractInvoiceDocument`
- `EXTRACT_INVOICE_FIELDS.inputs.attachmentId = {{$context.$nodes.GET_INVOICE_ATTACHMENT.$output.result.attachmentId}}`
- `EXTRACT_INVOICE_FIELDS.metadata.extractWithLlm = true`
- `EXTRACT_INVOICE_FIELDS.metadata.template = INVOICE_FIELD_EXTRACTION_TEMPLATE`
- `EXTRACT_INVOICE_FIELDS.outputSpecification` is cleared on the node and the effective schema comes from the selected template
- downstream references must follow the selected template schema

Invalid examples:

- Invalid: `EXTRACT_RESUME_TEXT.inputs.documentIdentifierList = {{$context.$nodes.GET_DOCS.$output.documents}}`
- Invalid: `EXTRACT_RESUME_TEXT.metadata.type = adfBc`
- Invalid: `EXTRACT_INVOICE_FIELDS.metadata.extractWithLlm = true` with no `template`
- Invalid: `EXTRACT_INVOICE_FIELDS.outcomes.failure = HANDLE_DOC_FAILURE`
- Invalid: `{{$context.$nodes.EXTRACT_INVOICE_FIELDS.$output.text}}` when the selected template does not define `text`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
