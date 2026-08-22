### If Condition

- Backend `type`: `CONDITION`
- **Inputs:** `condition` (boolean expression stored as a string input value)
- **Outcomes:** `true`, `false`
- Use `CONDITION` for boolean branching where one expression decides between exactly two paths.
- Prefer `CONDITION` over `SWITCH` when the routing decision is truly yes/no or true/false.
- A valid `CONDITION` node must include:
  - an input named `condition`
  - both `true` and `false` outcomes
  - a top-level `convergenceTargetId`

#### Structure

- `condition` should be authored as an input with `type: "string"` whose value is a boolean expression.
- `condition.value` must be non-empty.
- The stored `condition.value` should be the raw expression string, for example `1==2` or `{{$context.$nodes.CHECKER.$output.result.isEligible === true}}`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.condition` to the raw string value. Do not pass a nested input object such as `{ "type": "string", "value": "1==2" }`.
- `inputsPatch.condition` must contain only the final expression string, not an input-entry object with `id`, `name`, `type`, or `value`.
- Store the runtime condition only in the `condition` input. Do not persist editor helper structures such as `metadata.conditions`.
- `true` and `false` are both required outcome keys.
- `convergenceTargetId` is required and belongs at the node level, not inside `metadata`.
- The `true` outcome should point to the real branch entry node for the true path.
- The `false` outcome should point to the real branch entry node for the false path.
- For any real branch, `true` and `false` must point to distinct branch entry nodes. Do not route both outcomes to the same node, because that makes the condition a no-op.
- `CONDITION` does not use auto-created ADD placeholder nodes. Branch outcomes point directly to actual branch entry nodes.

#### Execution semantics

- `CONDITION` evaluates `condition` and routes execution to `outcomes.true` when the expression is truthy and to `outcomes.false` when it is not.
- Both executable branches should eventually converge at `convergenceTargetId`.
- The last executable node in each branch should route to `convergenceTargetId`, not bypass the intended join point.
- After execution passes through `convergenceTargetId`, downstream nodes may read outputs from whichever branch actually ran.

#### Authoring rules

- Write `condition` as an actual boolean check, not as an enum-style router. If the user wants branching across many named values, use `SWITCH` instead.
- Do not set `condition` to a bare data value just because that value may be truthy. Convert existence checks to explicit boolean expressions.
- For field-existence checks, prefer quote-free `!!` with safe navigation, for example `{{!!$context.$nodes.FETCH_RECORD.$output.items?.[0]?.RecordId}}`.
- For simple required-field guards, prefer the quote-free existence check over an empty-string comparison. Empty-string comparisons are more fragile when passed through shell commands or inline JSON.
- If a string comparison is genuinely required, write the condition through a file-backed JSON patch such as `--inputs-patch @.debug/<name>-inputs.json`; do not inline it through a shell argument.
- When reading the first item from a collection, use optional chaining or a length guard so missing or empty arrays route through the false path cleanly.
- Keep the `true` and `false` branch meanings semantically clear. The branch labels are fixed; the node names and downstream nodes should communicate what each side does.
- Do not point both branch outcomes to the same node just because both paths currently return the same expression. If the user requested true/false branches, create two explicit branch entries or a branch-specific terminal/fallback path.
- If the user asks to branch on exactly two named input values, compare against one value and let the false path represent the other named value when no third behavior is required.
- If more than two semantic values or an unsupported-value behavior is required, use `SWITCH` or nested validation rather than collapsing multiple named values into a single `CONDITION` expression with `||`.
- When inserting a `CONDITION` into an existing sequential flow, preserve the intended downstream continuation by setting `convergenceTargetId` to the shared node that should run after either branch completes.
- When editing an existing condition, preserve whichever branch the user did not ask to change.
- If one side should do nothing special and simply continue, it still needs a valid branch entry and convergence path in the workflow design.

#### Invalid patterns

- Invalid: omitting the required `condition` input
- Invalid: authoring `condition` with a non-string input type such as `boolean` or `json`
- Invalid: leaving `condition.value` empty
- Invalid: setting `inputsPatch.condition` to a nested object instead of a raw string expression
- Invalid: setting `inputsPatch.condition` to a full input object such as `{ "id": "x", "name": "condition", "type": "string", "value": "1==2" }`
- Invalid: setting `inputsPatch.condition` to a bare data path such as `{{$context.$nodes.FETCH_RECORD.$output.items[0].RecordId}}`
- Invalid: setting `inputsPatch.condition` to an expression with stripped empty-string literals or a dangling comparison, such as `{{(($context.$nodes.FETCH_RECORD.$output.items?.[0]?.Field||)+).trim()!==}}`, `{{... !==}}`, or `{{... ||)+}}`
- Invalid: storing editor helper conditions such as `metadata.conditions = [{ "left": "...", "operator": "notEmpty", "right": "" }]`
- Invalid: omitting `true` or omitting `false`
- Invalid: using outcome keys other than `true` and `false` on a `CONDITION` node
- Invalid: storing `convergenceTargetId` inside `metadata` instead of at the top level of the node
- Invalid: omitting `convergenceTargetId`
- Invalid: pointing `true` or `false` to a node id that does not exist
- Invalid: pointing `true` and `false` to the same node id
- Invalid: inventing ADD placeholder nodes such as `add_true_<id>` or `add_false_<id>`
- Invalid: wiring one branch so it bypasses the intended `convergenceTargetId`

#### Example

User request:
- "If the reimbursement amount is greater than 1000, route to manager approval; otherwise go straight to the standard processing path. After either path completes, continue to the final notification step."

Expected structure:
- `CHECK_REIMBURSEMENT_AMOUNT.type = CONDITION`
- `CHECK_REIMBURSEMENT_AMOUNT.inputs.condition.type = string`
- `CHECK_REIMBURSEMENT_AMOUNT.inputs.condition = {{$context.$nodes.PREPARE_REIMBURSEMENT.$output.amount > 1000}}`
- `CHECK_REIMBURSEMENT_AMOUNT.outcomes.true = MANAGER_APPROVAL`
- `CHECK_REIMBURSEMENT_AMOUNT.outcomes.false = STANDARD_PROCESSING`
- `CHECK_REIMBURSEMENT_AMOUNT.convergenceTargetId = FINAL_NOTIFICATION`
- `MANAGER_APPROVAL -> FINAL_NOTIFICATION`
- `STANDARD_PROCESSING -> FINAL_NOTIFICATION`

Existence-check example:

- `HAS_FIRST_RECORD.type = CONDITION`
- `HAS_FIRST_RECORD.inputs.condition = {{!!$context.$nodes.FETCH_RECORDS.$output.items?.[0]?.RecordId}}`
- Invalid for the same check: `HAS_FIRST_RECORD.inputs.condition = {{$context.$nodes.FETCH_RECORDS.$output.items[0].RecordId}}`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
