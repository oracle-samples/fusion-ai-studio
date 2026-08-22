### BO Function

- Backend `type`: `BO_FUNCTION`
- **Metadata:** `businessObjectCode` (selected object), `functionName` (selected function/tool), `processJson` (boolean; defaults to `true`, only persists `false`)
- **Inputs:** One input per token parameter (names from the selected function definition)
- **Output:** `outputSpecification` (editable JSON schema string)

#### Structure

- A valid `BO_FUNCTION` node must include:
  - `metadata.businessObjectCode`
  - `metadata.functionName`
  - outer `outcomes.success`
- `family` and `product` are selection filters in the editor. They help the user choose a business object, but they are not part of the persisted `BO_FUNCTION` node metadata contract.
- `processJson` defaults to `true`. Persist it in metadata only when the value is `false`.
- `inputs` should correspond only to token parameters of the selected business object function.

#### Authoring rules

- Do not guess `businessObjectCode` or `functionName`. Use the actual selected business object and the actual selected function for that object.
- When the user explicitly names a Business Object or function, that identity takes precedence over similar search results. Match the selected result's name, `businessObjectCode`, and `functionName` to the request before creating the node. Do not substitute a related object or function merely because its description appears relevant; if the requested identity is unavailable or genuinely ambiguous, explain the mismatch and ask before substituting it.
- Prefer existing reusable Business Objects for workflow `BO_FUNCTION` nodes. Search/select an existing BO before creating any new Business Object source artifact. Create a new `.bo` only when the user explicitly asks for a new source Business Object, or after search does not produce a suitable reusable candidate and the user confirms creation.
- `search-business-objects` may already return the BO/function metadata needed to choose `functionName`. After selecting a search result, reuse that returned metadata first.
- If a BO was selected from `search-business-objects` earlier in the same authoring turn, every later BO tool call you truly need for that BO must include `businessObjectHint` when the tool accepts it. This includes `get-business-object-functions`, `get-bo-function-output-specification`, `do-create-node`, and `do-modify-node`.
- Calling any of those tools without `businessObjectHint` in that situation is a tool-usage mistake.
- Before emitting any downstream BO tool call, self-check whether a selected `search-business-objects` result for that BO already exists in the conversation. If it does, include it as `businessObjectHint`.
- If the user provides `businessObjectCode` but not an exact `functionName`, call `get-business-object-functions` to inspect the available functions for that BO code only when prior search metadata is missing or still ambiguous.
- When `get-business-object-functions` returns one clear match for the user’s intent, select that function directly instead of asking a follow-up question.
- Ask the user to choose a function only when multiple returned functions are genuinely ambiguous for the request.
- Do not repeat `search-business-objects` in the same authoring turn just to rehydrate BO metadata that was already returned earlier.
- After changing `businessObjectCode`, reselect `functionName` for the new business object instead of carrying over a stale function from the previous one.
- After changing `functionName`, do not retain stale inputs from the previous function. The node inputs should match the token parameters of the currently selected function only.
- Do not invent extra input names that are not part of the selected function's token parameter definition.
- Before creating the node, verify every authored input name exists in the selected function's token parameter definition. Before authoring downstream expressions, prompts, or mappings, verify each referenced output field exists in the effective output specification for that exact selected function.
- Preserve the parameter type expected by the selected function when authoring each input.
- When using `do-create-node` or `do-modify-node`, each `inputsPatch.<parameterName>` value must be the final parameter value itself, not a nested input-entry object with `id`, `name`, `type`, or `value`.
- When using `do-create-node` or `do-modify-node`, `metadataPatch` must contain only persisted workflow node metadata such as `businessObjectCode`, `functionName`, and `processJson: false` when explicitly needed. Do not put lookup filters such as `family` or `product` in `metadataPatch`. Do not pass the whole selected `search-business-objects` result as `metadataPatch`; pass that selected result only as `businessObjectHint`.
- Use `BO_FUNCTION` for Oracle business object function calls, not for generic third-party REST integrations.
- Use the normal outer `success` outcome for the forward execution path. Do not invent a mandatory `failure` outcome rule if the workflow does not already require one.

#### Output schema contract

- `BO_FUNCTION` nodes have an editable `outputSpecification`.
- If prior search metadata already established the exact `businessObjectCode` and `functionName`, create or modify the `BO_FUNCTION` node directly with `businessObjectHint`; the node mutation tool owns output-spec enrichment when no explicit `outputSpecification` is supplied.
- If `businessObjectCode` is known but `functionName` is not yet exact, first call `get-business-object-functions`, choose the best matching function, and then create or modify the `BO_FUNCTION` node with that exact `functionName`.
- Use `get-bo-function-output-specification` only when the user explicitly asks to inspect the resolved schema or after a BO node mutation reports `boOutputSpecificationRetryRecommended=true` for a non-approval-boundary diagnostic retry.
- If downstream code, prompts, or expressions need BO field names, create or modify the `BO_FUNCTION` node first and let that node mutation persist the schema. Then inspect the saved node; do not pre-run `get-bo-function-output-specification` just to learn fields for downstream mapping.
- Treat `get-bo-function-output-specification` as an enrichment tool, not a blocker.
- When a sufficient `businessObjectHint` is provided, these tools should avoid a redundant BO fetch. They may still fetch remote BO metadata when the hint is missing or insufficient.
- Good after prior search: `do-create-node({ type: "BO_FUNCTION", name, metadataPatch: { businessObjectCode, functionName }, businessObjectHint: <exact selected search result> })`
- Invalid normal authoring path after prior search: `get-bo-function-output-specification({ businessObjectCode, functionName })`
- Invalid normal authoring path: pre-running `get-bo-function-output-specification` only to manufacture an `outputSpecification` argument for a later BO node mutation.
- Do not pass `outputSpecification` for a BO node merely because the schema can be resolved. Omit it so `do-create-node` or `do-modify-node` can resolve and persist the schema in the same mutation.
- After creating or modifying a `BO_FUNCTION` node, inspect `boOutputSpecificationResolved`, `boOutputSpecificationNeedsAttention`, `boOutputSpecificationRetryRecommended`, and `boOutputSpecificationApprovalRetryRecommended` first. Use `boOutputSpecificationEnrichment` only for deeper diagnostics.
- If `boOutputSpecificationResolved=true`, continue normally. Inspect the saved node only when downstream field-level references require confirmation or the diagnostic is suspicious.
- If the node mutation returns `ok:false` with `boOutputSpecificationApprovalRetryRecommended=true` or `approvalRetryRecommended=true`, do not treat that unresolved result as final and do not switch to a standalone resolver. Ask for approval from the host/user and rerun the same `do-create-node` or `do-modify-node` tool call once with the same arguments and the same `businessObjectHint`; the approved node mutation should resolve and persist the schema before saving.
- Otherwise, if `boOutputSpecificationRetryRecommended=true`, make exactly one explicit `get-bo-function-output-specification({ businessObjectCode, functionName, businessObjectHint: <exact selected search result> })` retry for diagnosis, then persist only if it resolves.
- After any explicit `get-bo-function-output-specification` call, inspect `resolved` and `approvalRetryRecommended` in that result.
- If `approvalRetryRecommended=true`, do not treat that unresolved resolver result as final. Ask for approval from the host/user and rerun that same resolver call once with the same `businessObjectHint`.
- If the explicit resolver retry returns `resolved=true`, immediately persist the returned schema with `do-modify-node({ nodeCode, outputSpecification: <returned schema> })` so the BO node no longer depends on implicit enrichment for that pass.
- If the explicit resolver retry still returns `resolved=false`, briefly note the reason if helpful and continue without forcing an `outputSpecification`.
- If `boOutputSpecificationNeedsAttention=true` but neither retry flag is `true`, do not keep retrying unless the user explicitly wants BO-schema debugging.
- Do not invent BO function output schemas.
- If output-spec enrichment returns `resolved=false`, briefly note the reason if helpful and continue the existing workflow-authoring flow without forcing an `outputSpecification`.
- Do not skip BO output-spec enrichment merely because a downstream `CODE` node or other node can consume the whole BO response object. Let `do-create-node`/`do-modify-node` attempt enrichment whenever the selected BO function is known and no explicit `outputSpecification` is supplied.
- Any downstream reference under `$context.$nodes.<BO_FUNCTION_CODE>.$output...` must resolve to a real field path in that schema.
- Do not invent downstream field paths just because you expect the selected business object function to return them.
- If the selected BO function is supposed to expose fields that downstream nodes need, ensure `outputSpecification` declares those exact fields before referencing them.
- If the function selection changes and the expected response shape changes, update `outputSpecification` in the same pass.

#### Invalid patterns

- Invalid: omitting `metadata.businessObjectCode`
- Invalid: omitting `metadata.functionName`
- Invalid: persisting editor filter values such as `family` or `product` as if they were required `BO_FUNCTION` node metadata
- Invalid: persisting `processJson: true` explicitly instead of relying on the default behavior
- Invalid: leaving stale parameter inputs from a previous function after the node's `functionName` changes
- Invalid: inventing input names that are not real token parameters of the selected function
- Invalid: referencing downstream `$output` fields that are not declared in the node's effective `outputSpecification`
- Invalid: selecting a similarly described Business Object or function instead of the exact one named by the user without explaining the mismatch and obtaining confirmation

#### Example

User request:
- "Call a logged-in user business object function, pass the selected token parameters, and then use specific response fields downstream."

Expected structure:
- `FETCH_LOGGED_IN_ASSIGNMENT.type = BO_FUNCTION`
- `FETCH_LOGGED_IN_ASSIGNMENT.metadata.businessObjectCode = <real selected BO code>`
- `FETCH_LOGGED_IN_ASSIGNMENT.metadata.functionName = <real selected function name for that BO>`
- `FETCH_LOGGED_IN_ASSIGNMENT.inputs` contains only the token parameters defined by that selected function
- `FETCH_LOGGED_IN_ASSIGNMENT.outcomes.success = NEXT_NODE`
- `FETCH_LOGGED_IN_ASSIGNMENT.outputSpecification` declares the response fields that downstream expressions will reference
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
