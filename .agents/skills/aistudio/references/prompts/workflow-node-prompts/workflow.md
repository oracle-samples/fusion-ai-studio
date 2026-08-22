### Workflow

- Backend `type`: `WORKFLOW`
- **Purpose:** Invoke another workflow.
- **Metadata:** `workflowCode`, `dynamicWorkflowFlag`, `answerInUserLanguage`, plus normal shared metadata such as `errorNodeId`
- **Output:** Fixed `outputSpecification` shape (includes `output`, `error`, `status`, `workflowCode`, `workflowVersion`, etc.).

#### Structure

- `WORKFLOW` supports two authoring modes:
  - static mode: select a published workflow by storing its code in `metadata.workflowCode`
  - dynamic mode: set `metadata.dynamicWorkflowFlag = true` and store the workflow-selection expression in `metadata.workflowCode`
- A valid `WORKFLOW` node must include:
  - outer `outcomes.success`
  - an input named `message`
  - either:
    - static mode with `metadata.workflowCode` set to a selected child workflow code, or
    - dynamic mode with `metadata.dynamicWorkflowFlag = true` and a non-empty workflow expression in `metadata.workflowCode`
- `message` is a normal node input and should be authored as `type: "string"` with a string `value`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.message` to the raw string value.
- Do not pass nested input objects such as `{ "type": "string", "value": "..." }` for `message`.
- Do not pass full input objects such as `{ "id": "...", "name": "message", "type": "string", "value": "..." }`.
- `answerInUserLanguage` is an optional metadata flag.

#### Static workflow mode

- In static mode, `metadata.dynamicWorkflowFlag` should be absent or `false`.
- `metadata.workflowCode` should contain the selected child workflow code.
- Additional node inputs should match the selected child workflow's exposed trigger parameters, with `message` always included as a standard input.
- If the selected child workflow changes, stale inputs from the previous selection must not remain on the node.
- The current workflow must not be selected as the child workflow.

#### Dynamic workflow mode

- In dynamic mode, `metadata.dynamicWorkflowFlag` must be `true`.
- In dynamic mode, `metadata.workflowCode` stores the workflow-selection expression, not a literal selected workflow code.
- `message` remains required in dynamic mode.
- Dynamic mode may include additional adhoc inputs beyond `message`.
- Dynamic adhoc input names must be non-empty and unique.
- Dynamic adhoc inputs should be persisted as real node inputs with final values, not as nested wrapper objects.
- When possible, keep dynamic adhoc input entries minimal and focused on the real persisted value instead of inventing extra declaration structure.

#### Authoring rules

- Use `WORKFLOW` only when the user really wants to invoke another workflow as a sub-workflow.
- Do not invent a normal `failure` outcome for `WORKFLOW` nodes just because sub-workflow execution can fail; use the shared error-handling model instead.
- If the child workflow expects inputs, provide them as normal node inputs on the `WORKFLOW` node.
- Keep `message` meaningful. It should describe the request or instruction being passed to the child workflow, not stay blank.
- In static mode, preserve only the parameters that belong to the currently selected child workflow.
- In dynamic mode, preserve `message` and the currently defined adhoc inputs only; do not leave orphaned old inputs behind.
- Do not configure the node to call the currently open workflow itself.

#### Output schema contract

- `WORKFLOW` nodes use a fixed/read-only output shape.
- Downstream references must follow that fixed schema.
- Do not invent alternate top-level fields on a `WORKFLOW` node's `$output`.
- Do not author a custom output schema for `WORKFLOW`; treat the editor-provided schema as fixed.

#### Invalid patterns

- Invalid: omitting the required `message` input
- Invalid: authoring `message` as a non-string input type
- Invalid: setting `inputsPatch.message` to a nested input object instead of the raw string value
- Invalid: using a full input-entry object for `message` inside `inputsPatch`
- Invalid: omitting `metadata.workflowCode` in static mode
- Invalid: setting `metadata.dynamicWorkflowFlag = true` but leaving the dynamic workflow expression empty
- Invalid: selecting the current workflow itself as the child workflow
- Invalid: leaving stale child-workflow parameters from an earlier workflow selection
- Invalid: creating duplicate or blank adhoc parameter names in dynamic mode
- Invalid: inventing a normal `failure` outcome on the `WORKFLOW` node
- Invalid: inventing alternate top-level `$output` fields that are not part of the fixed schema

#### Example

User request:
- "Call a child workflow that validates an employee payload, pass a message and the payload, then continue to the next step."

Expected static shape:
- `CALL_VALIDATION_WORKFLOW.type = WORKFLOW`
- `CALL_VALIDATION_WORKFLOW.metadata.workflowCode = employee.validation.workflow`
- `CALL_VALIDATION_WORKFLOW.inputs.message.type = string`
- `CALL_VALIDATION_WORKFLOW.inputs.message = Validate this employee payload`
- `CALL_VALIDATION_WORKFLOW.inputs.employeePayload = {{$context.$nodes.PREPARE_PAYLOAD.$output.result}}`
- `CALL_VALIDATION_WORKFLOW.outcomes.success = NEXT_NODE`

Expected dynamic shape:
- `CALL_SELECTED_WORKFLOW.type = WORKFLOW`
- `CALL_SELECTED_WORKFLOW.metadata.dynamicWorkflowFlag = true`
- `CALL_SELECTED_WORKFLOW.metadata.workflowCode = {{$context.$nodes.CHOOSE_WORKFLOW.$output.result.workflowCode}}`
- `CALL_SELECTED_WORKFLOW.inputs.message = Run the selected workflow for this request`
- `CALL_SELECTED_WORKFLOW.inputs.requestPayload = {{$context.$nodes.PREPARE_REQUEST.$output.result}}`
- adhoc dynamic input names remain unique and non-empty
- `CALL_SELECTED_WORKFLOW.outcomes.success = NEXT_NODE`

Invalid examples:

- Invalid: `CALL_VALIDATION_WORKFLOW.metadata.workflowCode = <current workflow code>`
- Invalid: `CALL_VALIDATION_WORKFLOW.metadata.dynamicWorkflowFlag = true` but `metadata.workflowCode` is empty
- Invalid: `CALL_VALIDATION_WORKFLOW.inputs.employeePayload` remains on the node after switching to a different child workflow that does not expose that parameter
- Invalid: `inputsPatch.message = { "type": "string", "value": "Run validation" }`
- Invalid: `CALL_SELECTED_WORKFLOW.outcomes.failure = HANDLE_CHILD_WORKFLOW_FAILURE`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
