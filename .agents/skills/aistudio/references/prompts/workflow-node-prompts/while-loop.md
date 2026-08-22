### While Loop

- Backend `type`: `WHILE`
- `WHILE` is a container node used to repeat the same loop body while a boolean condition remains true.
- A valid `WHILE` node must include:
  - an input named `condition`
  - `metadata.dataPipeline.rootNode`
  - `metadata.dataPipeline.pipelineNodes`
  - an outer `outcomes.success`

#### Structure

- **Inputs:** `condition` (a boolean expression)
- **Metadata:** `dataPipeline` (nested pipeline)
- `condition` should be authored as an input with `type: "string"` whose value is a boolean expression.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.condition` to the raw expression string only.
- Do not pass a nested input object such as `{ "type": "string", "value": "..." }` or a full input object for the while condition.
- `WHILE` is a nested `metadata.dataPipeline` container.
- The nested pipeline must have its own `rootNode` and internal `START_*` / `END_*` nodes.
- `metadata.dataPipeline.rootNode` is required and must point to a real node id inside the nested while pipeline.
- `metadata.dataPipeline.pipelineNodes` is required and must contain the full nested node objects, not only node id strings.
- The nested pipeline should use while-scoped internal IDs such as `start_<WHILE_NODE_ID>` and `end_<WHILE_NODE_ID>`.
- The `<WHILE_NODE_ID>` suffix must match the actual outer `WHILE.id` exactly.
- If the outer while node id is `4`, then the nested ids must be `start_4` and `end_4`, and `metadata.dataPipeline.rootNode` must be `start_4`.
- Do not reuse stale ids from an earlier draft of the workflow when constructing nested while node ids.
- Do not reuse top-level `start` / `end` IDs inside a while container.
- Nodes that execute on each iteration belong inside `metadata.dataPipeline.pipelineNodes`.
- Nodes that should execute after the while loop finishes belong outside the while container on the while node's outer `success` path.
- The outer `WHILE.outcomes.success` is required and must point to the first node that runs after the loop exits.

#### Execution semantics

- `condition` must evaluate to `true` or `false`.
- The while body runs only while `condition` is true.
- When the user asks for work "after the while loop", place that continuation outside the while container.
- The while node itself may still have a normal outer `success` outcome to the next node after the loop completes.
- Make sure something in the workflow can eventually make `condition` evaluate to `false`; otherwise the loop design is incomplete.

#### Condition rules

- `condition` should reference state that is valid at the time the while condition is evaluated.
- Prefer conditions that reference upstream state, workflow variables, or durable loop state that is clearly available before the next iteration check.
- Do not create a circular dependency where the `WHILE` condition depends on a node that only runs inside the `WHILE` body.
- Do not assume a body node's output is safely available for the next condition check unless that state model is already explicitly established in the workflow.

#### Preferred state pattern

- For `WHILE` loops whose condition depends on state that changes across iterations, use workflow variables as the primary durable state carrier.
- In those evolving-state `WHILE` patterns, declare the workflow variable at top-level `dataPipeline.variables` before the loop.
- Initialize that workflow variable before the `WHILE` node.
- Update that workflow variable explicitly inside the while body.
- Make `condition` reference that workflow variable, not a body-only node output.
- If `condition` or while-body logic reads/writes `$context.$variables.<name>`, that workflow variable must be explicitly declared in `dataPipeline.variables` before use.
- When the loop state must change each iteration, use a `SET_FIELDS` node to initialize the workflow variable before the loop and another `SET_FIELDS` node inside the while body to write the updated value for the next condition check.
- A required evolving-state `WHILE` pattern is:
  - declare the workflow variable first in top-level `dataPipeline.variables`
  - initialize state upstream
  - persist that initial value with `SET_FIELDS` before the `WHILE`
  - `WHILE.condition` reads from `$context.$variables...`
  - while-body nodes compute the next state
  - `SET_FIELDS` writes the updated state for the next condition check

Mandatory rule for evolving-state loops:
- If the `WHILE` condition depends on a value that is incremented, decremented, accumulated, retried, paged, or otherwise changed by each iteration, that value must live in a declared workflow variable.
- Do not model evolving while-loop state primarily through `$context.$nodes.<WHILE_CODE>.<INNER_NODE>.$output...`.
- Do not use fallback expressions such as `{{$context.$nodes.<WHILE_CODE>.<INNER_NODE>... ?? $context.$nodes.UPSTREAM_NODE...}}` as a substitute for declaring and updating a workflow variable.
- Do not omit top-level `dataPipeline.variables` just because the initial value can be computed by an upstream node.
- If that workflow variable is an `object` or `array`, include a valid `typeSpecification` schema in the workflow variable declaration so the variable is fully typed and UI-editable.
- For evolving object-state examples such as `counter = { count, maxCount }`, declare the workflow variable with the full shape the workflow editor expects: `id`, `name`, `type`, `scope`, and `typeSpecification`.
- Do not invent workflow-variable declaration fields such as `defaultValue`.

Valid pattern example:
- Workflow variable `counter` is declared in `dataPipeline.variables`
- Upstream initialization computes the initial counter value
- `SET_INITIAL_COUNTER` writes that value into workflow variable `counter`
- `WHILE.condition = {{$context.$variables.counter.count < $context.$variables.counter.maxCount}}`
- inside the while body, a `CODE` node computes the next counter value
- a `SET_FIELDS` node writes the updated `counter`

Concrete valid shape:
- `dataPipeline.variables` includes an object variable named `counter`
- that declaration includes:
  - `id`
  - `name = counter`
  - `type = object`
  - `scope = JOB` unless the user explicitly needs conversation scope
  - `typeSpecification` describing `count:number` and `maxCount:number`
- `INITIALIZE_COUNTER` returns `{ count: 0, maxCount: 3 }`
- `SET_INITIAL_COUNTER` writes that value to workflow variable `counter`
- `WHILE.condition = {{$context.$variables.counter.count < $context.$variables.counter.maxCount}}`
- inside the while body:
  - `CODE` computes the next counter value from `$context.$variables.counter`
  - `SET_FIELDS` writes the updated `counter`
- after the while loop, downstream nodes may read `$context.$variables.counter`

Concrete valid `counter` declaration example:

```json
{
  "id": "var_counter",
  "name": "counter",
  "type": "object",
  "scope": "JOB",
  "typeSpecification": "{\"type\":\"object\",\"properties\":{\"count\":{\"type\":\"number\"},\"maxCount\":{\"type\":\"number\"}},\"required\":[\"count\",\"maxCount\"]}"
}
```

Canonical evolving-state `WHILE` skeleton:

- top-level path:
  - `INITIALIZE_COUNTER` (`CODE`) computes `{ count: 0, maxCount: 3 }`
  - `SET_INITIAL_COUNTER` (`SET_FIELDS`) writes workflow variable `counter`
  - `WHILE_COUNT_LESS_THAN_MAX` (`WHILE`) uses `condition = {{$context.$variables.counter.count < $context.$variables.counter.maxCount}}`
  - `FINAL_WHILE_SUMMARY` runs after the loop
- if the outer while node id is `4`, then the nested container must use:
  - `rootNode = "start_4"`
  - nested `START.id = "start_4"`
  - nested `END.id = "end_4"`
  - the last inner node's success outcome points to `"end_4"`
- top-level `dataPipeline.variables` contains:

```json
[
  {
    "id": "var_counter",
    "name": "counter",
    "type": "object",
    "scope": "JOB",
    "typeSpecification": "{\"type\":\"object\",\"properties\":{\"count\":{\"type\":\"number\"},\"maxCount\":{\"type\":\"number\"}},\"required\":[\"count\",\"maxCount\"]}"
  }
]
```

- `SET_INITIAL_COUNTER.inputs` contains an assignment for `counter` whose value is `{{$context.$nodes.INITIALIZE_COUNTER.$output.result}}`
- inside `WHILE_COUNT_LESS_THAN_MAX.metadata.dataPipeline.pipelineNodes`:
  - `INCREMENT_COUNTER` (`CODE`) reads from `$context.$variables.counter`
  - `UPDATE_COUNTER_VARIABLE` (`SET_FIELDS`) writes the updated `counter`
  - optional per-iteration nodes such as `WRITE_ITERATION_MESSAGE`
- invalid substitutes for this skeleton include:
  - omitting top-level `dataPipeline.variables`
  - omitting either `SET_INITIAL_COUNTER` or `UPDATE_COUNTER_VARIABLE`
  - making `WHILE.condition` depend on `$context.$nodes.WHILE_COUNT_LESS_THAN_MAX.INCREMENT_COUNTER...`
  - using `??` fallback logic between while-body output and initialization output
  - using `start_2` / `end_2` when the actual outer while node id is `4`
- Unless the user explicitly asks for a different valid state mechanism supported by the product, use this canonical skeleton for changing-state `WHILE` loops.

Invalid pattern example:
- `WHILE.condition = {{$context.$nodes.WHILE_COUNTER.INCREMENT_COUNTER.$output.result.count < $context.$nodes.WHILE_COUNTER.INCREMENT_COUNTER.$output.result.maxCount}}`
- body node code reads its own previous output like `$context.$nodes.WHILE_COUNTER.INCREMENT_COUNTER.$output...`
- `WHILE.condition = {{($context.$nodes.WHILE_COUNTER.INCREMENT_COUNTER?.$output?.result?.count ?? $context.$nodes.INITIALIZE_COUNTER.$output.result.count) < ($context.$nodes.WHILE_COUNTER.INCREMENT_COUNTER?.$output?.result?.maxCount ?? $context.$nodes.INITIALIZE_COUNTER.$output.result.maxCount)}}`
- `WHILE.condition = {{$context.$variables.counter.count < $context.$variables.counter.maxCount}}` but `counter` is not declared in `dataPipeline.variables`
- `dataPipeline.variables = [{ "name": "counter", "type": "object", "defaultValue": null }]`
- Do not fall back to self-referential body-node outputs just because the workflow variable has not been declared yet; declare the variable first.

#### Referencing inner nodes

- Nodes inside the while body can be referenced through the container path:
  - `{{$context.$nodes.MY_WHILE.INNER_NODE.$output}}`
- Nested containers can use nested container paths:
  - `{{$context.$nodes.OUTER_WHILE.INNER_LOOP.INNER_NODE.$output}}`

#### Authoring rules

- Use `WHILE` only when the workflow should continue until a boolean condition becomes false.
- If the loop body updates the state used by the condition, make that state flow explicit and non-circular.
- When editing an existing while loop, preserve the nested `metadata.dataPipeline` structure and modify only the intended loop body or outer continuation.
- If the user asks for a final summary after the while loop, put that summary node outside the while body.

#### Invalid patterns

- Invalid: placing per-iteration while body nodes at the top level instead of inside `metadata.dataPipeline.pipelineNodes`
- Invalid: setting `condition` to a non-boolean value expression
- Invalid: omitting the required `condition` input
- Invalid: authoring `condition` with a non-string input type
- Invalid: setting `inputsPatch.condition` to a nested input object instead of the raw expression string
- Invalid: forgetting the nested `metadata.dataPipeline.rootNode`
- Invalid: setting `metadata.dataPipeline.rootNode` to a node id that does not exist in the nested while pipeline
- Invalid: omitting `metadata.dataPipeline.pipelineNodes`
- Invalid: storing string ids in `metadata.dataPipeline.pipelineNodes` instead of full nested node objects
- Invalid: omitting the required outer `success` outcome on the `WHILE` node
- Invalid: reusing plain `start` / `end` IDs inside the while nested pipeline instead of while-scoped internal IDs
- Invalid: using `start_<X>` / `end_<X>` ids whose suffix `<X>` does not exactly match the actual outer `WHILE.id`
- Invalid: putting a node that should run after the while loop inside the while body
- Invalid: making `condition` depend on a node that only runs inside the while body
- Invalid: designing a loop where no iteration state ever changes in a way that can make `condition` become false
- Invalid: making a body node depend on its own previous output unless that iterative state model is already explicitly established and valid in the workflow
- Invalid: using a body node's output as the primary while-loop state carrier when workflow variables or another explicit durable state mechanism should be used instead
- Invalid: for evolving-state while loops, omitting top-level `dataPipeline.variables` and `SET_FIELDS` state persistence even though the loop condition depends on changing iteration state
- Invalid: using `??` or similar fallback logic between while-body output and upstream initialization output instead of declaring a workflow variable and updating it explicitly
- Invalid: declaring an object workflow variable for while-loop state without `typeSpecification`
- Invalid: using invented workflow-variable declaration fields such as `defaultValue`
- Invalid: reading or writing `$context.$variables.<name>` in a while pattern when that workflow variable is not declared in `dataPipeline.variables`

#### Example

User request:
- "Initialize a counter, keep looping while count is less than maxCount, increment the counter in the loop body, then summarize the final result after the while loop."

Expected structure:
- top-level `INITIALIZE_COUNTER -> WHILE_COUNT_LESS_THAN_MAX -> FINAL_WHILE_SUMMARY`
- `WHILE_COUNT_LESS_THAN_MAX.type = WHILE`
- `WHILE_COUNT_LESS_THAN_MAX.inputs.condition` is a boolean expression
- the while body contains the per-iteration update and message nodes
- the nested while pipeline uses its own internal IDs such as `start_<while-id>` / `end_<while-id>`
- the final summary node is outside the while container
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
