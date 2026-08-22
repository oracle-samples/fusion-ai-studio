### Code

- Backend `type`: `CODE`
- **Metadata:** `sourceCode` (JavaScript source), `returnType` (one of: `array | boolean | number | object | string`)
- **Output:** Fixed `outputSpecification` schema (read-only in editor)
- **Referencing output:** A Code node's returned value is available to downstream expressions under `$context.$nodes.<NODE_CODE>.$output.result`, not bare `$output`. Do **not** infer downstream field paths from plain JavaScript `return result;` syntax.
- The fixed Code-node `outputSpecification` uses a top-level wrapper with `result`, `timeout`, and `error`.
- When creating or repairing a `CODE` node in workflow JSON, persist that fixed `outputSpecification` on the node itself. Do not omit it just because the schema is fixed/read-only in the UI.
- If an existing `CODE` node is missing `outputSpecification`, treat the node as incomplete and restore the fixed schema in the same implementation pass.
- A complete `CODE` node artifact must include all three together when applicable: `metadata.sourceCode`, `metadata.returnType`, and the persisted fixed `outputSpecification`.
- Do not author or mutate a Code node `outputSpecification` to place business fields directly at top level under `$output`.
- Do not put a Code node `outputSpecification` inside `metadata` or `metadata.specification`; the fixed wrapper belongs on the node's top-level `outputSpecification`.
- Do not leave a `CODE` node with only `metadata.sourceCode` and `metadata.returnType` but no persisted `outputSpecification`.
- If the code returns `{ draftAnnouncement: "..." }`, the valid downstream field path is `$output.result.draftAnnouncement`, not `$output.draftAnnouncement`.
- Invalid: generating a Code node `outputSpecification` whose top-level properties are the returned business fields instead of the fixed `result` wrapper.
- Invalid: creating a `CODE` node and omitting its fixed `outputSpecification` from the emitted workflow spec.
- Invalid for successful app-stage presentation: creating a terminal `CODE` node that assembles or returns `oraInfoDisplay` XML or widget JSON. Use `CODE` only for upstream normalization, then route to a dedicated app-stage `LLM` or `AGENT` node to emit widgets.

#### CRITICAL: Code Node Authoring Rules

#### Special note: ambiguous Code node requests

If the user asks to “modify”, “fix”, “check”, or “update” a **Code** node but does not specify *what part*, assume they mean the node's `metadata.sourceCode`.

When the user asks to modify a Code node:

**Step 0:** Inspect existing configuration (including `metadata.sourceCode` and `metadata.returnType`) via `get-nodes-metadata-by-code`. Modify the existing code — **do not** rewrite from scratch unless the user explicitly asks.

**Rule 1 — No wrappers.** Treat `metadata.sourceCode` as the *body of a function*. Write plain JavaScript statements. Do not add `function main() { ... }`, `const main = () => { ... }`, exports, or imports.

**Rule 2 — Return type must match `returnType`.** If the user wants a different return shape, ask before changing `returnType`.

**Rule 3 — Return the final value in a way that matches `returnType`.** Multiple return statements are allowed when they make the code clearer.

**Rule 4 — Limited environment.** Treat it as conservative vanilla JavaScript. No imports, no non-standard globals, and no modern runtime APIs that are not supported in this environment. In particular, do not use `Intl` or APIs that depend on it; prefer basic JavaScript string/number/object/array operations instead.

**Rule 6 — Use documented `$context` paths only.** Do not invent convenience aliases or unsupported runtime objects. If data must come from workflow context, reference it through documented paths such as `$context.$nodes...`, `$context.$variables...`, `$context.$system...`, and loop-scoped paths like `$context.$nodes.<LOOP_CODE>.$currentItem`.

**Rule 6a — Do not use top-level `$context.$input` for normal Code nodes.** `$context.$input.<field>` is only for nodes inside reference-block input scope. A normal top-level `CODE` node must not read its own configured inputs or prior-node data through `$context.$input.extractedState`, `$context.$input.payload`, or similar paths.

**Rule 7 — No invented globals or self-aliases.** There are no injected bare workflow variables such as `currentRow`, `row`, `item`, `employee`, `input`, `output`, `opportunitiesPayload`, or `<nodeName>Payload`. Previous node outputs are never available as globals. Do not write `const currentRow = currentRow;` or otherwise assume a value exists unless it was declared earlier in the same JavaScript body or is being read from an explicit documented `$context` path.

**Rule 8 — Bind previous node outputs explicitly.** If code needs a prior node result, create a local variable from `$context.$nodes.<NODE_CODE>.$output` or `$context.$nodes.<NODE_CODE>.$output.result`. Never start from a bare payload/result variable and never route prior-node data through `$context.$input`.

**Rule 8a — Do not replace required runtime values with placeholders.** If Code logic needs values such as `customerId`, `orderId`, `requestedItem`, or similar business fields, the upstream producer must output those fields and declare them in its `outputSpecification`; the Code node must read those real fields instead of hardcoding placeholders like `"provided in conversation"`.

**Rule 9 — No self-referential injected aliases.** Do not write fallback aliases such as `const extractionOutput = extractionOutput || {};` or `const response = response ?? {};`. Those names are not injected by the runtime; bind them from an explicit `$context` path.

// ❌ BAD — invented ambient variable/self-alias
const currentRow = currentRow;
const employeeId = employeeId;
const raw = opportunitiesPayload ?? {};
const extracted = $context.$input.extractedState || {};

// ✅ GOOD — bind locals from explicit workflow context
const currentRow = $context.$nodes.FOR_EACH_ROW.$currentItem;
const employeeId = $context.$variables.employeeId;
const raw = $context.$nodes.FETCH_OPPORTUNITIES?.$output ?? {};
const extracted = $context.$nodes.EXTRACT_USER_REQUEST.$output || {};
```

##### Complete examples

✅ **Good** (plain statements with a matching return type):

```js
const digits = String($context.$nodes.SOME_NODE.$output ?? '').replace(/\D/g, '');
if (!digits) return '';
return digits.slice(0, 10);
```

✅ **Referencing a returned object from a downstream prompt/expression:**

```text
If this Code node returns { someProperty: 123 },
reference it as {{$context.$nodes.SOME_CODE.$output.result.someProperty}}
Do not write {{$context.$nodes.SOME_CODE.$output.someProperty}}
If PRIORITIZE_OPPORTUNITIES returns { top5: [...] }, reference {{$context.$nodes.PRIORITIZE_OPPORTUNITIES.$output.result.top5}}
```

❌ **Bad** (wrapper function):

```js
const main = () => {
  return 123;
};
return main();
```
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
