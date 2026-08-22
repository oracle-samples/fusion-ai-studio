### Wait

- Backend `type`: `WAIT`
- **Metadata:** `waitTimeValue` (number), `waitTimeUnits` (string; default `MINUTES`), `maxIterations` (number), `loopBackNodeId` (node ID)
- **Inputs:** `message` (message/prompt template)
- Use `WAIT` when the workflow should pause before continuing, or when a polling / retry pattern needs a delay before jumping back to an earlier node.
- A valid `WAIT` node must include:
  - an input named `message`
  - outer `outcomes.success`
- If the node is being used as a retry / polling wait, configure that behavior with `metadata.loopBackNodeId` and `metadata.maxIterations`.

#### Structure

- `message` is a required node input and should be authored as `type: "string"`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.message` to the raw message string only.
- Do not pass a nested input object such as `{ "type": "string", "value": "Please wait." }` or a full input object with `id` / `name` / `type` / `value`.
- `outcomes.success` is required and must point to the next node that should run after the wait completes or after retries are exhausted.
- `waitTimeValue`, `waitTimeUnits`, `maxIterations`, and `loopBackNodeId` are metadata fields, not inputs.
- If `waitTimeUnits` is present, it must be exactly `MINUTES` or `HOURS`.
- If `waitTimeValue` is set and `waitTimeUnits` is missing, default `waitTimeUnits` to `MINUTES`.

#### CRITICAL: WAIT timer fields belong to metadata

For `WAIT` nodes:

- `waitTimeValue` MUST be set in `metadataPatch.waitTimeValue`.
- `waitTimeUnits` MUST be set in `metadataPatch.waitTimeUnits`.
- `inputsPatch` should only contain true input fields such as `message` (not timer metadata).

Invalid:

- `inputsPatch.waitTimeValue = "5"`
- `inputsPatch.waitTimeUnits = "MINUTES"`

Valid:

- `metadataPatch.waitTimeValue = 5`
- `metadataPatch.waitTimeUnits = "MINUTES"`
- `inputsPatch.message = "Working on your request, please wait."`

After creating/modifying a `WAIT` node, verify the timer fields exist in metadata and were not created as node inputs.

#### Execution semantics

- Without `loopBackNodeId`, `WAIT` pauses for the configured duration and then continues through `outcomes.success`.
- With `loopBackNodeId` and remaining retry budget, `WAIT` pauses for the configured duration and then resumes execution from the node identified by `loopBackNodeId`.
- When the retry budget is exhausted, the workflow should continue through `outcomes.success`.
- Do not model retry behavior by drawing a backward edge from the `WAIT` node. The retry jump is controlled by `metadata.loopBackNodeId`.
- `WAIT` nodes are good for polling an external status, spacing out retries, or rate-limiting a section of the workflow.

#### Duration rules

- `waitTimeValue` should be numeric and non-negative.
- The total wait duration must not exceed 60 minutes.
- Valid examples:
  - `waitTimeValue = 15`, `waitTimeUnits = "MINUTES"`
  - `waitTimeValue = 1`, `waitTimeUnits = "HOURS"`
- Invalid examples:
  - `waitTimeValue = 2`, `waitTimeUnits = "HOURS"` because that exceeds the 60-minute limit
  - negative or non-numeric `waitTimeValue`

#### Retry / polling rules

- If `loopBackNodeId` is set, treat the `WAIT` node as a retry / polling node.
- In retry / polling patterns, `maxIterations` should also be present so the loop is bounded.
- Do not leave a loop-back `WAIT` node with an unbounded retry pattern unless the user explicitly wants that and the workflow truly supports it.
- `loopBackNodeId` must point to a real earlier node id in the workflow section being retried.
- Use `loopBackNodeId` only for the node that should be re-entered after the wait, not for the node that runs after waiting is fully done.
- If loop-back is cleared or not used, do not keep stale retry semantics on the node.

#### CRITICAL: WAIT loop-back uses `metadata.loopBackNodeId` (node ID), not edges

When the user asks for `WAIT` retries/loop-back (e.g. "loop back to Init Workflow"):

- Resolve the target node first via workflow structure tools (by display name/code), then resolve that node's **id** from workflow data.
- Set `metadataPatch.loopBackNodeId` to that resolved node id.
- Do **not** represent loop-back by adding a normal edge from the `WAIT` node back to the target node code.
- Keep normal control-flow insertion/rewiring on the main success path (insert-after/insert-between as requested).
- If the loop-back target is ambiguous, ask one targeted question with the closest matches.

ID-safety rules (strict):

- Never invent, synthesize, or guess `loopBackNodeId`.
- Never copy unrelated UUIDs/ids into `loopBackNodeId`.
- If you can resolve the node name/code but cannot confirm its node **id**, ask one targeted question for the exact node id (or for confirmation using candidates) before mutating.
- Do not call mutating tools for loop-back configuration until `loopBackNodeId` is confirmed.

Invalid:

- `do-modify-node-edges` change that adds `WAIT_* -> INIT_WORKFLOW` to model retry behavior.
- `metadataPatch.loopBackNodeId` set to a node code/name instead of node id.
- `metadataPatch.loopBackNodeId` set to a fabricated UUID/id not confirmed from workflow data.

Valid:

- `metadataPatch.loopBackNodeId = "<resolved node id for Init Workflow>"`
- Main-path edge rewiring remains forward (e.g. `NEW_TOOL_NODE -> WAIT_NODE -> NEXT_NODE`).

#### Authoring rules

- Keep `message` as a short user-facing or operator-facing explanation of why the workflow is waiting.
- If the user asks for a simple pause, do not add retry metadata unnecessarily.
- If the user asks for retry / polling behavior, configure both the delay and the retry contract in the same pass.
- If the wait node is added only to slow down or space out upstream calls, keep the success path forward and do not invent loop-back behavior.
- If the workflow includes at least one `WAIT` node, the workflow-level `waitFlag` should be enabled by the workflow mutation layer.

#### Invalid patterns

- Invalid: omitting the required `message` input
- Invalid: authoring `message` with a non-string input type
- Invalid: setting `inputsPatch.message` to a nested input object instead of the raw message string
- Invalid: omitting the required outer `success` outcome
- Invalid: putting `waitTimeValue`, `waitTimeUnits`, `maxIterations`, or `loopBackNodeId` into `inputs`
- Invalid: using a value for `waitTimeUnits` other than `MINUTES` or `HOURS`
- Invalid: creating a wait duration longer than 60 minutes
- Invalid: setting `loopBackNodeId` to a node code, display name, or fabricated id
- Invalid: modeling retry by wiring a normal edge from `WAIT` back to an earlier node
- Invalid: setting `loopBackNodeId` without a bounded retry plan when the intended behavior is a finite polling loop
- Invalid: keeping `maxIterations` as if retry is active when `loopBackNodeId` is absent or cleared

#### Example: simple delay

User request:
- "Pause for 10 minutes, then continue to the next notification step."

Expected shape:
- `WAIT_FOR_NOTIFICATION_WINDOW.type = WAIT`
- `WAIT_FOR_NOTIFICATION_WINDOW.inputs.message = "Waiting before sending the next notification."`
- `WAIT_FOR_NOTIFICATION_WINDOW.inputs.message.type = string`
- `WAIT_FOR_NOTIFICATION_WINDOW.metadata.waitTimeValue = 10`
- `WAIT_FOR_NOTIFICATION_WINDOW.metadata.waitTimeUnits = MINUTES`
- `WAIT_FOR_NOTIFICATION_WINDOW.outcomes.success = SEND_NOTIFICATION`
- no `loopBackNodeId`
- no retry metadata unless the user explicitly asked for retries

#### Example: polling / retry delay

User request:
- "After checking the remote job status, wait 5 minutes and retry that status check up to 4 times. If retries are exhausted, continue to the final fallback step."

Expected shape:
- `CHECK_REMOTE_STATUS -> WAIT_BEFORE_RETRY -> FINAL_FALLBACK`
- `WAIT_BEFORE_RETRY.type = WAIT`
- `WAIT_BEFORE_RETRY.inputs.message = "Waiting before the next status check."`
- `WAIT_BEFORE_RETRY.metadata.waitTimeValue = 5`
- `WAIT_BEFORE_RETRY.metadata.waitTimeUnits = MINUTES`
- `WAIT_BEFORE_RETRY.metadata.loopBackNodeId = <real node id of CHECK_REMOTE_STATUS>`
- `WAIT_BEFORE_RETRY.metadata.maxIterations = 4`
- `WAIT_BEFORE_RETRY.outcomes.success = FINAL_FALLBACK`
- the retry jump back to `CHECK_REMOTE_STATUS` is handled by `loopBackNodeId`, not by a backward edge authored on `outcomes`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
