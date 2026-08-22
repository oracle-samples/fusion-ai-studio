### For Loop

- Backend `type`: `LOOP`
- `LOOP` is a container node used to run the same loop body for each item in a collection.
- Use a `LOOP` node when the same sequence of steps should run for each item in an array/collection.
- Do not use a `PARALLEL` node to model collection iteration.
- A valid `LOOP` node must include:
  - an input named `collection`
  - `metadata.loopType`
  - `metadata.dataPipeline.rootNode`
  - `metadata.dataPipeline.pipelineNodes`
  - an outer `outcomes.success`

#### Structure

- **Inputs:** `collection` (an expression that evaluates to an iterable/array)
- **Metadata:** `loopType` (`PARALLEL` or `SEQUENTIAL`), `dataPipeline` (nested pipeline)
- `LOOP` is a nested `metadata.dataPipeline` container.
- The nested pipeline must have its own `rootNode` and internal `START_*` / `END_*` nodes.
- The nested pipeline should use loop-scoped internal IDs such as `start_<LOOP_NODE_ID>` and `end_<LOOP_NODE_ID>`.
- Do not reuse top-level `start` / `end` IDs inside a loop container.
- `metadata.loopType` is required and must be exactly `SEQUENTIAL` or `PARALLEL`.
- `metadata.dataPipeline.rootNode` is required and must point to a real node id inside the nested loop pipeline.
- Nodes that execute for each item belong inside `metadata.dataPipeline.pipelineNodes`.
- `metadata.dataPipeline.pipelineNodes` must contain full nested node objects, not bare node id strings.
- Nodes that should execute after the loop finishes belong outside the loop container on the loop node's outer `success` path.
- The outer `LOOP.outcomes.success` is required and must point to the first node that runs after the loop completes.

#### Execution semantics

- `loopType: SEQUENTIAL` means process collection items one by one.
- `loopType: PARALLEL` means process collection items concurrently using the same loop body.
- `loopType: PARALLEL` executes items in concurrent batches of 10.
- The loop node itself may still have a normal outer `success` outcome to the next node after the loop completes.
- When the user asks for work "after the loop", place that continuation outside the loop container.
- For `PARALLEL` loops, do not rely on iteration order when authoring downstream logic.
- For `PARALLEL` loops that call external systems or mutate shared state, be cautious about rate limits, retries, ordering assumptions, and resource contention.
- If the collection is large, prefer to reduce or slice it before the loop instead of blindly iterating over everything.
- `LOOP` has no built-in `maxIterations` setting. If the user wants only the first `N` items, limit the collection upstream before binding it to `collection`.

#### Current item access

- Inside the loop body, reference the current item using:
  - `$context.$nodes.<LOOP_CODE>.$currentItem`
- Inside the loop body, reference the current item index using:
  - `$context.$nodes.<LOOP_CODE>.$currentItemIndex`
- Use the actual loop node code in these expressions.
- Code nodes inside the loop body do **not** receive bare locals like `currentItem`, `item`, `row`, or `currentRow`. If you want a local variable, assign it yourself from `$context.$nodes.<LOOP_CODE>.$currentItem`.

Example:
- If the loop node code is `FOR_EACH_EMPLOYEE`, valid loop-body access is:
  - `$context.$nodes.FOR_EACH_EMPLOYEE.$currentItem`
  - `$context.$nodes.FOR_EACH_EMPLOYEE.$currentItemIndex`

#### Referencing inner nodes

- Nodes inside the loop body can be referenced through the container path:
  - `{{$context.$nodes.MY_LOOP.INNER_NODE.$output}}`
- Nested loops can use nested container paths:
  - `{{$context.$nodes.OUTER_LOOP.INNER_LOOP.INNER_NODE.$output}}`

#### Authoring rules

- `collection` must be present as a node input named `collection`.
- The `collection` input should be authored as `type: "array"`.
- `collection` should evaluate to an iterable/array, not a single object, boolean, or scalar value.
- If the user asks to iterate over items produced by an upstream node, bind `collection` to the upstream array field.
- If an upstream node returns an object that contains an array field, bind the loop to that array field, not to the whole object.
- If the loop body needs fields such as `displayName`, `employeeId`, or similar, read them from the loop-scoped current item.
- `HUMAN` nodes must not be placed inside a `LOOP` body.
- When editing an existing loop, preserve the nested `metadata.dataPipeline` structure and modify only the intended loop body or outer continuation.
- If the user asks for a final summary after the loop, put that summary node outside the loop body.
- If the user wants to limit how many items are processed, insert an upstream shaping step such as a `CODE` node that returns a smaller array, then bind that array to `collection`.

#### Scale guidance

- Small collections can use either `SEQUENTIAL` or `PARALLEL` depending on semantics.
- Medium collections often benefit from `PARALLEL` if the loop body is independent per item.
- Larger collections need more care:
  - if order matters, prefer `SEQUENTIAL`
  - if the loop body calls APIs or writes shared state, prefer `SEQUENTIAL` or explicitly limit the collection first
  - if the collection is very large, do not assume a single loop is the right design; consider batching or pre-aggregation upstream

#### Invalid patterns

- Invalid: placing per-item loop body nodes at the top level instead of inside `metadata.dataPipeline.pipelineNodes`
- Invalid: using a `PARALLEL` node instead of a `LOOP` node for collection iteration
- Invalid: omitting the required outer `success` outcome on the `LOOP` node
- Invalid: omitting `metadata.loopType` or using a value other than `SEQUENTIAL` / `PARALLEL`
- Invalid: setting `collection` to a single object instead of an iterable/array
- Invalid: creating the `collection` input with a non-array input type
- Invalid: forgetting the nested `metadata.dataPipeline.rootNode`
- Invalid: setting `metadata.dataPipeline.rootNode` to a node id that does not exist in the nested loop pipeline
- Invalid: reusing plain `start` / `end` IDs inside the loop's nested pipeline instead of loop-scoped internal IDs
- Invalid: putting a node that should run after the loop inside the loop body
- Invalid: placing a `HUMAN` node anywhere inside `metadata.dataPipeline.pipelineNodes`
- Invalid: storing string ids such as `["nodeA","nodeB"]` in `metadata.dataPipeline.pipelineNodes` instead of full node objects
- Invalid: pretending `LOOP` supports a native `maxIterations` field; limit the collection upstream instead
- Invalid: using `PARALLEL` loop mode when the loop body depends on stable per-item execution order
- Invalid: inventing undocumented loop-item aliases such as:
  - `$context.$item`
  - `$context.$currentItem`
  - `$context.$loop`
  - `$context.$loop?.$item`
- Invalid: reading loop item fields from invented globals instead of `$context.$nodes.<LOOP_CODE>.$currentItem`

#### Example

User request:
- "Iterate over employees from `GET_EMPLOYEES`, generate one appreciation per employee, then after the loop print the full loop output and summarize it."

Expected structure:
- top-level `GET_EMPLOYEES -> FOR_EACH_EMPLOYEE -> FINAL_SUMMARY`
- `FOR_EACH_EMPLOYEE.type = LOOP`
- `FOR_EACH_EMPLOYEE.inputs.collection = {{$context.$nodes.GET_EMPLOYEES.$output.result.employees}}`
- `FOR_EACH_EMPLOYEE.inputs.collection.type = array`
- `FOR_EACH_EMPLOYEE.metadata.loopType = SEQUENTIAL`
- `FOR_EACH_EMPLOYEE.outcomes.success = FINAL_SUMMARY`
- the nested loop pipeline uses its own internal IDs such as `start_<loop-id>` / `end_<loop-id>`
- `FOR_EACH_EMPLOYEE.metadata.dataPipeline.rootNode` points to a real nested node id
- `FOR_EACH_EMPLOYEE.metadata.dataPipeline.pipelineNodes` contains full nested node objects
- the loop body contains the per-employee extraction and appreciation nodes
- the final summary node is outside the loop container
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
