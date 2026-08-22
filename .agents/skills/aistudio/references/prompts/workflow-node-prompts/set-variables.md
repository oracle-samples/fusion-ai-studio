### Set Variables

- Backend `type`: `SET_FIELDS`
- `SET_FIELDS` updates already-declared workflow variables.
- A valid `SET_FIELDS` node must include:
  - at least one assignment entry in `inputs`
  - outer `outcomes.success`
- Keep `SET_FIELDS` assignment entries lean. The assignment payload should describe what variable to write and what value to write.
- Do not mix workflow variable declaration metadata into `SET_FIELDS` assignment entries.
- Workflow variable declarations live in top-level `specification.dataPipeline.variables`.
- A workflow variable declaration should include:
  - `id`
  - `name`
  - `type`
  - `scope`
  - `typeSpecification` when the variable type is `object` or `array`
- For object and array workflow variables, `typeSpecification` is required, not optional.
- Do not declare an object or array workflow variable without a usable JSON-schema `typeSpecification`.
- Do not invent unsupported workflow-variable fields such as `defaultValue`.
- If an initial value is needed, compute it in an upstream node and persist it with `SET_FIELDS`; do not try to encode runtime initialization through an invented declaration field.
- `SET_FIELDS.inputs` should target variables that already exist in `specification.dataPipeline.variables`.
- For authoring purposes, model `SET_FIELDS` inputs as variable assignments with minimal entries such as `{ name, value }`.
- If an `id` is present on a `SET_FIELDS` assignment entry, it is fine, but do not add declaration-only fields such as `type`, `scope`, or `typeSpecification` to the assignment entry.
- `scope`: typically `JOB` (user question) or `CONVERSATION`, but that belongs to the workflow variable declaration, not the per-node assignment entry.
- `SET_FIELDS` uses the normal outer `success` outcome after writing the variable values.
- `SET_FIELDS` can only target workflow variables that already exist in `specification.dataPipeline.variables`.
- Do not invent variable names in `SET_FIELDS` unless those variables are also explicitly declared in the workflow definition.
- If a workflow variable is needed and does not already exist, declare it first in `dataPipeline.variables` before reading or writing it.
- Use `SET_FIELDS` when the workflow needs to maintain explicit state across steps or iterations.
- `SET_FIELDS` is a common way to update durable workflow state for `WHILE` loops.
- Variable `value` entries can be expressions, allowing a node to compute the next state and then persist it to workflow variables.
- If a downstream node reads `$context.$variables.<name>`, the workflow must execute a `SET_FIELDS` node that writes that variable before the read happens.
- Declaring a variable at top-level does not automatically give it a runtime value. If the workflow needs that variable to hold a value, initialize it with an upstream `SET_FIELDS` node before the first read.
- When a variable is an `object` or `array`, define an appropriate `typeSpecification` in the workflow variable definition.
- When a `WHILE` loop needs evolving state across iterations, prefer:
  - declare the workflow variable first
  - initialize workflow variables before the loop
  - compute next-state values inside the loop body
  - use `SET_FIELDS` inside the loop body to write updated variable values for the next condition check
- When a `WHILE` loop's condition depends on changing iteration state, this is not optional:
  - declare the workflow variable in top-level `dataPipeline.variables`
  - use `SET_FIELDS` before the loop to persist the initial state
  - use `SET_FIELDS` inside the loop body to persist the updated state
  - do not replace workflow-variable state with self-references to while-body node outputs

Valid pattern:
- workflow variable `counter` is declared in `dataPipeline.variables`
- `SET_FIELDS` writes `counter`
- `WHILE.condition` reads `$context.$variables.counter`
- the `SET_FIELDS` node executes before the first downstream read of `$context.$variables.counter`

Example workflow variable declaration:

```json
{
  "id": "var_counter",
  "name": "counter",
  "type": "object",
  "scope": "JOB",
  "typeSpecification": "{\"type\":\"object\",\"properties\":{\"count\":{\"type\":\"number\"},\"maxCount\":{\"type\":\"number\"}},\"required\":[\"count\",\"maxCount\"]}"
}
```

Invalid workflow variable declaration:

```json
{
  "name": "counter",
  "type": "object",
  "defaultValue": null
}
```

Why invalid:
- object workflow variables must include a usable `typeSpecification`
- workflow variable declarations should carry stable declaration fields such as `id` and `scope`
- `defaultValue` is not part of the supported workflow variable declaration contract

Valid `SET_FIELDS` assignment shape:

```json
{
  "type": "SET_FIELDS",
  "inputs": [
    {
      "id": "2_counter",
      "name": "counter",
      "value": "{{$context.$nodes.INITIALIZE_COUNTER.$output.result}}"
    }
  ]
}
```

Invalid `SET_FIELDS` assignment shape:

```json
{
  "type": "SET_FIELDS",
  "inputs": [
    {
      "name": "counter",
      "value": "{{$context.$nodes.INITIALIZE_COUNTER.$output.result}}",
      "type": "object",
      "scope": "JOB"
    }
  ]
}
```

Why invalid:
- `type` and `scope` belong to the workflow variable declaration in `dataPipeline.variables`
- they should not be duplicated inside the per-node `SET_FIELDS` assignment payload

Invalid pattern:
- `SET_FIELDS` writes `counter`
- `WHILE.condition` reads `$context.$variables.counter`
- but `dataPipeline.variables` does not define `counter`
- `dataPipeline.variables` declares `counter`, but no upstream `SET_FIELDS` node initializes it before a downstream node reads `$context.$variables.counter`
- `SET_FIELDS.inputs = []`
- `SET_FIELDS` omits `outcomes.success`
- `SET_FIELDS.inputs` includes declaration-only fields such as `type`, `scope`, or `typeSpecification`
- `dataPipeline.variables` declares an object or array variable without `typeSpecification`
- `dataPipeline.variables` uses invented declaration fields such as `defaultValue`

- If a `WHILE` loop needs a variable such as `counter` and that variable does not exist yet, declare it in `dataPipeline.variables` as part of the workflow design rather than falling back to self-referential body-node outputs.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
