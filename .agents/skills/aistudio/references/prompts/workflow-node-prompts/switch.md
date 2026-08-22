### Switch

- Backend `type`: `SWITCH`
- **Inputs:** `caseExpression` (expression matched against case values)
- **Outcomes:** One outcome per case value (case strings are the outcome keys)
- Use `SWITCH` when one expression determines which of several named paths should run.
- Prefer `SWITCH` over deeply nested `IF` / `CONDITION` nodes when branching on the same field/value across multiple cases.
- Good fit: request type, message hint, status, mode, or other enum-like routing.
- Less appropriate: unrelated boolean checks where each branch uses a different condition; in that case use `IF` / `CONDITION`.
- Keep case values explicit and stable so branch labels clearly describe the routing contract.
- A valid `SWITCH` node must include:
  - an input named `caseExpression`
  - at least one case outcome
  - a top-level `convergenceTargetId`

#### Structure

- `caseExpression` should be authored as an input with `type: "string"`.
- `caseExpression.value` must contain a non-empty expression that resolves to the value being matched.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.caseExpression` to the raw expression string only.
- Do not pass a nested input object such as `{ "type": "string", "value": "..." }` or a full input object for `caseExpression`.
- `convergenceTargetId` is required and belongs at the node level, not inside `metadata`.
- Each outcome key is a case value. The outcome target should point to the real branch entry node for that case.
- `SWITCH` does not have a built-in special `default` branch outcome. If the workflow needs a catch-all route, model it explicitly as one of the authored case values or use a different control-flow design.
- `SWITCH` does not use auto-created ADD placeholder nodes. Case outcomes point directly to actual branch entry nodes.
- At least one case outcome is required.

#### Execution semantics

- `SWITCH` evaluates `caseExpression` and routes execution to the branch whose outcome key matches the evaluated value.
- All executable switch branches should eventually converge at `convergenceTargetId`.
- The last executable node in each switch branch should route to `convergenceTargetId`, not to an unrelated downstream node that bypasses the intended join.
- After execution passes through `convergenceTargetId`, downstream nodes may read outputs from whichever switch branch actually ran.

#### Authoring rules

- Case values should be non-empty and unique.
- Outcome keys may use any meaningful case label the workflow needs; there are no special reserved case labels enforced by `SWITCH`.
- When editing a switch, preserve existing branch labels unless the user explicitly asks to rename the routing contract.
- When adding a new case, wire it as a sibling branch under the same `SWITCH` node and preserve the existing convergence target unless the workflow design is intentionally changing.
- When removing a case, make sure at least one case branch still remains.
- If the user wants a fallback path, do not invent a magic `default` outcome unless the existing workflow already uses that literal case value intentionally as a normal branch label.

#### Invalid patterns

- Invalid: omitting the required `caseExpression` input
- Invalid: authoring `caseExpression` with a non-string input type
- Invalid: leaving `caseExpression.value` empty
- Invalid: setting `inputsPatch.caseExpression` to a nested object instead of the raw expression string
- Invalid: creating a `SWITCH` with no case outcomes
- Invalid: using empty case labels
- Invalid: using duplicate case labels
- Invalid: storing `convergenceTargetId` inside `metadata` instead of at the top level of the node
- Invalid: omitting `convergenceTargetId`
- Invalid: pointing a case outcome to a node id that does not exist
- Invalid: inventing ADD placeholder nodes such as `add_<case>_<id>` for switch branches
- Invalid: inventing a special built-in `default` outcome contract for `SWITCH`
- Invalid: wiring one switch branch so it bypasses the intended `convergenceTargetId`

#### Example

User request:
- "Route by request type. If the type is travel, go to the travel handler. If the type is promotion, go to the promotion handler. Then rejoin and continue to the final summary step."

Expected structure:
- `ROUTE_BY_REQUEST_TYPE.type = SWITCH`
- `ROUTE_BY_REQUEST_TYPE.inputs.caseExpression.type = string`
- `ROUTE_BY_REQUEST_TYPE.inputs.caseExpression = {{$context.$nodes.CLASSIFY_REQUEST.$output.requestType}}`
- `ROUTE_BY_REQUEST_TYPE.outcomes = { "travel": TRAVEL_HANDLER, "promotion": PROMOTION_HANDLER }`
- `ROUTE_BY_REQUEST_TYPE.convergenceTargetId = FINAL_SUMMARY`
- `TRAVEL_HANDLER -> FINAL_SUMMARY`
- `PROMOTION_HANDLER -> FINAL_SUMMARY`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
