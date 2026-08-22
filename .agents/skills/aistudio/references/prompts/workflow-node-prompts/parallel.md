### Parallel

- Backend `type`: `PARALLEL`
- `PARALLEL` is a fan-out / fan-in control-flow node.
- Use a `PARALLEL` node only when there are **2 or more** real branches.
- `PARALLEL` is not a nested `metadata.dataPipeline` container like `LOOP` or `WHILE`; its branches are defined by numbered `outcomes`, and its join point is defined by top-level `convergenceTargetId`.
- A valid `PARALLEL` node must include:
  - at least 2 numbered outcome keys
  - a top-level `convergenceTargetId`

#### Structure

- **Outcomes:** numbered strings (`"0"`, `"1"`, `"2"`, …), one per branch entry node.
- Do **not** use `success` as an outcome on a `PARALLEL` node.
- Outcome keys must be numeric strings starting at `"0"` and increasing sequentially with no gaps.
- Each numbered outcome must point to the **first node of a distinct branch**.
- Each numbered outcome points only to the **branch entry node**; the rest of that branch is represented by normal downstream node outcomes.
- CRITICAL: every usable `PARALLEL` node must include a top-level `convergenceTargetId`.
- Set `convergenceTargetId` to the node that should execute after all parallel branches complete.
- `convergenceTargetId` belongs at the node level, not inside `metadata`.
- Do **not** assume the convergence node can be inferred from branch edges; you must write `convergenceTargetId` explicitly on the `PARALLEL` node object.
- Each branch entry node id must resolve to a real node in the workflow.
- `convergenceTargetId` must resolve to a real node id in the workflow.

#### Authoring rules

- Treat `outcomes` as the branch-entry map:
  - `"0"` -> first branch start node
  - `"1"` -> second branch start node
  - `"2"` -> third branch start node
- Treat `convergenceTargetId` as the shared join point after the parallel block.
- When parallelizing existing sequential work, convert the selected tasks into **sibling branches** under the `PARALLEL` node.
- Remove obsolete sequential dependencies between the nodes being parallelized if those dependencies would prevent true parallel execution.
- Preserve the intended downstream continuation by converging into the correct existing next node when appropriate.
- If the user asks to parallelize `N` tasks, the `PARALLEL` node should normally have `N` numbered outcomes.
- Every executable branch path inside the parallel block should eventually reach the same `convergenceTargetId`, or `end` when that is the intended convergence target.
- The last executable node in each branch should route to `convergenceTargetId`, not to a separate branch-local `END` node.
- When inserting a `PARALLEL` node into an existing flow, preserve the original upstream predecessor and the intended downstream continuation. The typical shape is `predecessor -> PARALLEL -> convergenceTarget`.
- After the workflow exits a `PARALLEL` node through its `convergenceTargetId`, downstream nodes may reference outputs from any of the completed branches.
- `HUMAN`, `WAIT`, and `WORKFLOW` nodes are allowed inside `PARALLEL` branches when the requested design needs them.
- Do not place `REFERENCEABLEBLOCK` nodes inside `PARALLEL` branches.

#### Invalid patterns

- Invalid: `outcomes: { "success": "NODE_ID" }`
- Invalid: using non-numeric outcome keys such as `"left"`, `"right"`, or `"branch1"`
- Invalid: using numbered outcome keys that do not start at `"0"` or that skip numbers such as `{ "0": "...", "2": "..." }`
- Invalid: missing `convergenceTargetId`
- Invalid: storing `convergenceTargetId` inside `metadata` instead of at the top level of the node
- Invalid: numbered branch outcomes are present and all branches lead to the same downstream node, but the `PARALLEL` node still omits top-level `convergenceTargetId`
- Invalid: a `PARALLEL` node with only one real branch
- Invalid: leaving the branch tasks chained sequentially after saying they should run in parallel
- Invalid: creating fake parallelism by listing multiple branch outcomes while one listed branch is still only reachable through another branch's sequential path
- Invalid: pointing a numbered branch outcome to a node id that does not exist
- Invalid: leaving one branch dangling so it never reaches the shared `convergenceTargetId`
- Invalid: ending a branch at `END` when the intended design requires all branches to rejoin at `convergenceTargetId`
- Invalid: placing a `REFERENCEABLEBLOCK` node anywhere inside a parallel branch
- Invalid: converging to the wrong downstream node and bypassing the intended continuation

#### Example transformation

- Before:
  - `A -> B -> C -> D`
- After parallelizing `A`, `B`, and `C`, then continuing to `D`:
  - `PARALLEL.outcomes = { "0": "A", "1": "B", "2": "C" }`
  - `PARALLEL.convergenceTargetId = "D"`
  - each branch must lead to `D`

Valid `PARALLEL` node shape:

```json
{
  "id": "6",
  "code": "PARALLEL_USER_QUOTE_JOKE",
  "type": "PARALLEL",
  "metadata": {
    "name": "Parallel User Quote Joke"
  },
  "outcomes": {
    "0": "5",
    "1": "1",
    "2": "2"
  },
  "convergenceTargetId": "3",
  "inputs": []
}
```

Invalid `PARALLEL` node shape:

```json
{
  "id": "6",
  "code": "PARALLEL_USER_QUOTE_JOKE",
  "type": "PARALLEL",
  "metadata": {
    "name": "Parallel User Quote Joke"
  },
  "outcomes": {
    "0": "5",
    "1": "1",
    "2": "2"
  },
  "inputs": []
}
```

- The invalid example is still wrong even if nodes `5`, `1`, and `2` all point to node `3`.
- Branch edges converging on the same downstream node are **not** a substitute for explicitly setting `convergenceTargetId`.

#### Example

User request:
- "Run user lookup, quote generation, and joke generation in parallel, then continue to the existing code node, then the final LLM node."

Expected structure:
- `START -> PARALLEL`
- `PARALLEL.outcomes = { "0": GET_CURRENT_USER_DETAILS, "1": QUOTE_OF_THE_DAY, "2": JOKE_OF_THE_DAY }`
- `PARALLEL.convergenceTargetId = FORMAT_QUOTE_AND_JOKE`
- `FORMAT_QUOTE_AND_JOKE -> RENDER_HTML_OUTPUT`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
