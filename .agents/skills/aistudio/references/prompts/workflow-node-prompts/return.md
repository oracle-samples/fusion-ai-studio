### Return

- Backend `type`: `RETURN`
- **Inputs:** `returnValue` (payload/template to return)
- Use a `RETURN` node only when you need to explicitly shape or emit a specific structured return payload.
- Do not add a `RETURN` node just to let the workflow finish.
- A workflow can validly end after nodes such as `LLM`, `AGENT`, `CODE`, `TOOL`, or similar executable nodes by routing their `success` outcome to `END`.

#### Structure

- A valid `RETURN` node must include:
  - an input named `returnValue`
  - empty `outcomes`
- `returnValue` is a normal string-backed node input.
- In the workflow spec, `returnValue` should be stored as `type: "string"` with a string `value`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.returnValue` to the raw return expression or raw string value.
- Never use `inputsPatch.value` or an input named `value` for a `RETURN` node; the only payload input name is `returnValue`.
- Do not pass nested input objects such as `{ "type": "string", "value": "..." }` for `returnValue`.
- Do not pass full input objects such as `{ "id": "...", "name": "returnValue", "type": "string", "value": "..." }`.

#### Execution semantics

- `RETURN` is terminal. Once it executes, the workflow returns that value to the caller instead of continuing to downstream nodes.
- `RETURN` does not use normal `success` or `failure` routing.
- `RETURN.outcomes` should remain an empty object `{}`.
- `RETURN` should not use `metadata.errorNodeId`; treat it as a terminal node, similar to `END`.

#### Authoring rules

- Use `RETURN` only when the workflow must explicitly emit a caller-facing payload.
- If the user asks for an exact caller-facing message or simple terminal payload and no computation is needed, prefer a `RETURN` node over a `CODE` node.
- For static terminal branch messages, use `RETURN` directly. Do not create a `CODE` node whose entire source is only `return "some message";`.
- If the workflow should simply finish after a normal executable node, prefer routing that node to `END` instead of introducing a needless `RETURN`.
- Keep `returnValue` focused on the actual payload the caller needs.
- `returnValue` may contain normal workflow expressions when the returned value should come from upstream data.

#### Invalid patterns

- Invalid: omitting the required `returnValue` input
- Invalid: using `inputsPatch.value` instead of `inputsPatch.returnValue`
- Invalid: authoring `returnValue` as a non-string input type
- Invalid: setting `inputsPatch.returnValue` to a nested input object instead of the raw string value
- Invalid: using a full input-entry object for `returnValue` inside `inputsPatch`
- Invalid: adding `success` or `failure` outcomes to a `RETURN` node
- Invalid: using non-empty `outcomes` on a `RETURN` node
- Invalid: adding `metadata.errorNodeId` to a `RETURN` node
- Invalid: wiring downstream control flow as if `RETURN` continues execution after returning

#### Example

User request:
- "Return the final normalized employee payload to the caller."

Expected structure:
- `RETURN_EMPLOYEE_PAYLOAD.type = RETURN`
- `RETURN_EMPLOYEE_PAYLOAD.inputs.returnValue.type = string`
- `RETURN_EMPLOYEE_PAYLOAD.inputs.returnValue = {{$context.$nodes.NORMALIZE_EMPLOYEE.$output.result}}`
- `RETURN_EMPLOYEE_PAYLOAD.outcomes = {}`

Invalid examples:

- Invalid: `inputsPatch.value = "Done"`
- Invalid: `RETURN_EMPLOYEE_PAYLOAD.outcomes.success = END`
- Invalid: `RETURN_EMPLOYEE_PAYLOAD.outcomes = { "success": "NEXT_NODE" }`
- Invalid: `RETURN_EMPLOYEE_PAYLOAD.metadata.errorNodeId = HANDLE_RETURN_ERROR`
- Invalid: `inputsPatch.returnValue = { "type": "string", "value": "{{$context.$nodes.NORMALIZE_EMPLOYEE.$output.result}}" }`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
