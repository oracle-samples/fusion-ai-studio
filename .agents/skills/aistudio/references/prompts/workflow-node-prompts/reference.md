### Reference

- Backend `type`: `REFERENCE`
- **Purpose:** Invoke a reusable `REFERENCEABLEBLOCK` by selecting the block's node code.
- **Metadata:** `metadata.referenceableBlockId`
- **Inputs:** one input per selected reference-block variable
- **Output:** `outputSpecification` (editable JSON schema string)

#### Structure

- `metadata.referenceableBlockId` stores the selected reference block's **node code**, not the block's internal node id.
- The selected block must be a `REFERENCEABLEBLOCK`.
- A valid `REFERENCE` node must include:
  - outer `outcomes.success`
  - non-empty `metadata.referenceableBlockId`
  - exactly one input per variable declared on the selected reference block
- Reference-node input names come from `REFERENCEABLEBLOCK.metadata.dataPipeline.variables[*].name`.
- Reference-node input types come from the selected block variable declarations and must not be re-inferred from the patched value.
- `outputSpecification` belongs on the `REFERENCE` node itself and describes the payload returned by the selected block's terminal `RETURN`.
- Do not store the reference output schema under `metadata`, and do not store it on the `REFERENCEABLEBLOCK`.

#### Selection semantics

- Changing `metadata.referenceableBlockId` replaces the full reference-node input set to match the newly selected block variables.
- Clearing `metadata.referenceableBlockId` clears the full reference-node input set.
- Stale inputs from the previous block must not survive a block change.
- If the selected block changes and new values are needed immediately, provide them in the same `inputsPatch`.

#### Tool / CLI authoring rules

- When using `do-create-node` or `do-modify-node`, set `metadataPatch.referenceableBlockId` to the selected reference block code.
- `inputsPatch` values are raw final stored values only.
- Use top-level `outputSpecification` when downstream nodes need field-level access to the reference node output.
- Do not pass nested input wrappers such as `{ "type": "...", "value": "..." }`.
- Do not pass full input objects such as `{ "id": "...", "name": "...", "type": "...", "value": "..." }`.
- Do not keep or invent adhoc inputs that are not declared by the selected block variables.
- If downstream nodes reference `$context.$nodes.<REFERENCE_CODE>.$output.<field>`, the reference node's `outputSpecification` must declare that field.

#### Invalid patterns

- Invalid: storing the selected block's internal node id in `metadata.referenceableBlockId`
- Invalid: omitting `metadata.referenceableBlockId`
- Invalid: leaving old inputs from a previous block selection on the node
- Invalid: inferring reference-node input types from the patched value instead of the block variable declaration
- Invalid: setting `inputsPatch` entries to nested input objects instead of raw final values
- Invalid: inventing extra inputs that are not declared by the selected reference block
- Invalid: placing the output schema in `metadata.outputSpecification` or on the selected `REFERENCEABLEBLOCK`
- Invalid: referencing downstream `$output` fields that are not declared in the `REFERENCE` node's `outputSpecification`

#### Example

User request:
- "Call the `FETCH_PRODUCTS_BLOCK` reference block and pass `departmentId` plus `includeInactive`."

Expected structure:
- `FETCH_PRODUCTS.type = REFERENCE`
- `FETCH_PRODUCTS.metadata.referenceableBlockId = FETCH_PRODUCTS_BLOCK`
- `FETCH_PRODUCTS.inputs.departmentId.type` matches the block variable declaration
- `FETCH_PRODUCTS.inputs.includeInactive.type` matches the block variable declaration
- `FETCH_PRODUCTS.outputSpecification` declares returned fields that downstream nodes will reference
- `FETCH_PRODUCTS.outcomes.success = NEXT_NODE`

Valid create/update shape:
- `do-create-node({ type: "REFERENCE", name: "Fetch Products", metadataPatch: { referenceableBlockId: "FETCH_PRODUCTS_BLOCK" }, inputsPatch: { departmentId: "{{$context.$nodes.GET_DEPARTMENT.$output.result.id}}", includeInactive: "false" }, outputSpecification: "{\"type\":\"object\",\"properties\":{\"products\":{\"type\":\"array\"}}}" })`

Invalid examples:

- Invalid: `metadataPatch.referenceableBlockId = "block_17"`
- Invalid: `inputsPatch.departmentId = { "type": "string", "value": "..." }`
- Invalid: leaving `legacyInput` on the node after switching from `FETCH_CUSTOMERS_BLOCK` to `FETCH_PRODUCTS_BLOCK`
- Invalid: `metadataPatch.outputSpecification = "{...}"`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
