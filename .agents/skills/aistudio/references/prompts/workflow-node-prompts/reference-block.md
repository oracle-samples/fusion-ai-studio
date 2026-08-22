### Reference Block

- Backend `type`: `REFERENCEABLEBLOCK`
- **Purpose:** Define a reusable top-level workflow container that can be invoked by `REFERENCE` nodes.
- **Editable configuration:** `metadata.dataPipeline.variables`
- **Nested pipeline:** `metadata.dataPipeline.rootNode` plus `metadata.dataPipeline.pipelineNodes`

#### Structure

- `REFERENCEABLEBLOCK` is a top-level reusable container.
- The reusable block's inputs live in `metadata.dataPipeline.variables`.
- When using `do-create-node` or `do-modify-node`, update block variables through `metadataPatch.dataPipeline.variables`.
- Variable entries should stay minimal and focus on the real stored fields such as `id`, `name`, `type`, `typeSpecification`, and `value`.
- Updating `metadataPatch.dataPipeline.variables` must preserve the existing nested container pipeline (`rootNode` and `pipelineNodes`).

#### Nested execution semantics

- Inner nodes inside the block read block inputs through `$context.$input.<name>`.
- Do not use top-level node-output paths when the desired value is the block input itself.
- Every executable terminal path inside the nested reference-block pipeline must end at a `RETURN` before reaching the nested `END`.
- The nested `END` node is structural only; it is not a substitute for `RETURN`.

#### Tool / CLI authoring rules

- Create or modify reference blocks with the existing generic node commands rather than inventing dedicated reference-block commands.
- Keep reusable-block variable changes in `metadataPatch.dataPipeline.variables`.
- Do not replace the nested `rootNode` / `pipelineNodes` structure when the user is only editing block variables.
- If a variable needs an object/array schema, keep it in `typeSpecification`.

#### Invalid patterns

- Invalid: treating `REFERENCEABLEBLOCK` like a normal executable node with adhoc outer inputs
- Invalid: storing reusable inputs anywhere other than `metadata.dataPipeline.variables`
- Invalid: replacing the nested `rootNode` / `pipelineNodes` while making a variable-only edit
- Invalid: reading block inputs from invented aliases instead of `$context.$input.<name>`
- Invalid: letting an executable terminal branch reach the nested `END` without a `RETURN`

#### Example

User request:
- "Create a reusable reference block that takes `customerId`, lets inner nodes read `$context.$input.customerId`, and always returns a payload."

Expected structure:
- `FETCH_CUSTOMER_BLOCK.type = REFERENCEABLEBLOCK`
- `FETCH_CUSTOMER_BLOCK.metadata.dataPipeline.variables` contains `customerId`
- nested block nodes read `{{$context.$input.customerId}}` when they need the block input
- every executable terminal branch ends at a `RETURN`

Valid update shape:
- `do-modify-node({ nodeCode: "FETCH_CUSTOMER_BLOCK", metadataPatch: { dataPipeline: { variables: [{ id: "custId", name: "customerId", type: "string" }] } } })`

Invalid examples:

- Invalid: `metadataPatch.inputs = { customerId: "..." }`
- Invalid: inner code reads `$context.$nodes.SOME_NODE.$output.customerId` when the intended source is the block input
- Invalid: a nested `CODE` node routes directly to the nested `END` without a `RETURN`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
