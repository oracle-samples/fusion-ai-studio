# Business Object CLI Compatibility

Use this reference for Business Object `.bo` artifact work. For workflow `BO_FUNCTION` nodes, use `workflow-node-prompts/bo-function.md` instead.

## Artifact Boundary

- A "Business Object Tool" or "BO Tool" is a Tool artifact, not a Business Object file. Use `aistudio do-create-tool --tool-type business-object`.
- A workflow "business object node" is workflow node work. Use workflow references and `workflow-node-prompts/bo-function.md`.
- When a workflow request explicitly names an existing Business Object or function, preserve that identity and follow `workflow-node-prompts/bo-function.md`; do not create or substitute a different Business Object artifact because another search result has a similar description.
- A Business Object source artifact lives under `src/businessObjects/*.bo`.

## Creation Flow

- Use this flow only when the user explicitly wants a new Business Object source artifact, or after a workflow/app data-source search found no suitable reusable BO and the user confirmed creation. For workflow `BO_FUNCTION` nodes, search/select existing BOs first.
- Prefer `aistudio do-create-bo` to create local Business Object files.
- If the user wants to choose a resource type first, run `aistudio list-bo-resource-types`, show the indexed choices, and ask them to pick by number. Use the selected `value` as `--object-source`.
- For ADF BC or Spectra resource-type-first choices, ask for the BO resource path next, create the BO, then use `aistudio do-create-bo-function-from-operation` once an `operationId` is known.
- Use `aistudio do-create-bo-function-from-operation` only for spec-backed ADF BC and BOSS/Spectra Business Objects when you have an `operationId`.
- Use `aistudio do-add-bo-function` for Other Data Source Application (`NonFusionOracleSource`) and Other resource type (`HCM_SEARCH`) Business Objects after the local BO has complete metadata.

## Other Data Source Applications

- For Other Data Source Application BOs, run `aistudio list-bo-data-source-applications` first.
- Show indexed choices and let the user pick an existing datasource by number.
- Use the selected choice's `suggestedBoMetadata` for command arguments and render `displaySuggestedBoMetadata` when present.
- In user-facing proposals, show `Resource Type: Other Data Source Application`, family/product display labels, and `Oracle Data Source Application` by display name.
- Do not show fixed internals such as `Object Source: NonFusionOracleSource` or `Resource Path: /` in the proposal.
- Do not move to `do-add-bo-function` until `aistudio do-create-bo --object-source NonFusionOracleSource --resource-path /` has created a local `.bo` with complete metadata.
- Never offer to create the datasource from CLI because credentials are required.

## Updates And Examples

- Prefer `aistudio do-update-bo` for BO-level metadata updates.
- Use `aistudio do-fetch-bo --code <objectCode>` only when the user explicitly asks to fetch/pull/refresh a BO from the server.
- Use `aistudio do-save-bo --file <bo-file>` only when the user explicitly asks to save/push the BO to the remote draft.
- If `aistudio do-save-bo` fails, report the backend error plainly and stop. Do not auto-search for other BOs, speculate about conflicts, or retarget the save unless the user explicitly asks for deeper investigation.
- Prefer `aistudio get-bo-function-example-guidance` before asking for sample inputs or attempting a sample fetch.
- Prefer `aistudio prepare-bo-function-example-inputs` to validate and normalize user-provided sample inputs before `do-fetch-bo-function-example-sample`.
- For GET example/sample fetches that need path or query values, ask the user for those values unless they already provided them.
- Do not borrow sample parameter values from CLI help, tests, prompts, or checked-in examples.
- Only try to discover valid sample values from live data if the user explicitly asks.
- If `aistudio validate-bo` only reports BO example-input or example-payload issues, ask for missing values instead of inventing a payload.
- Only use `illustrative=true` on BO example payload commands when the user explicitly asks for a manual illustrative example.

## Function Commands

Use BO mutation commands instead of hand-editing when supported:

- `list-bo-resource-types`
- `list-bo-data-source-applications`
- `validate-bo`
- `do-update-bo`
- `do-create-bo-function-from-operation`
- `do-add-bo-function`
- `get-business-object-functions`
- `get-bo-function-output-specification`
- `get-bo-function-example-guidance`
- `prepare-bo-function-example-inputs`
- `do-modify-bo-function`
- `do-rename-bo-function`
- `do-delete-bo-function`
- parameter/header/example CRUD commands
- BO generation/sample commands

After material BO changes, run `aistudio validate-bo --file <bo-file>`.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
