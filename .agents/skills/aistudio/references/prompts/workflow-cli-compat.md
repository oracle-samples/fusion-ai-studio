# CLI Compatibility

Most workflow command surfaces are mirrored in the `aistudio` CLI.

- Workflow mutation commands that have matching tools keep the same command names.
- Workflow lifecycle helpers such as `do-create-workflow`, `do-modify-workflow-metadata`, `list-workflow-families`, and `list-workflow-products` are CLI-only.
- Top-level workflow `workflowCode` values must match `^[A-Z0-9_]+$`: uppercase letters, numbers, and underscores only. Do not use hyphens, lowercase letters, spaces, or other punctuation. `do-create-workflow --workflow-code` fails when the provided code does not match this format.
- In tool mode, call the tool with JSON arguments.
- In CLI mode, workflow-scoped commands use `aistudio <command> --file <workflow-file> ...`; commands that do not read or write a workflow omit `--file`.
- CLI flags map directly to tool arguments using kebab-case names.
- For object and array arguments, pass JSON inline only for simple non-expression values. For condition, switch, code, return, or other expression-bearing workflow node inputs, write the JSON to a scratch file and pass `@path/to/file.json`; shell quoting can strip empty-string literals, `$context`, `{{...}}`, quotes, or comparison syntax and corrupt guard expressions.
- For workflow/debugger mutation commands, use `--dry-run` only when the user explicitly wants an exact diff preview before writing.
- Do not hand-edit the workflow JSON when a matching tool/CLI mutation command already supports the change.
- For `LLM` / `AGENT` App Experience settings (widgets/actions/communications), use the node's top-level `aiAppOutputSpecification` / CLI flag `--ai-app-output-specification`, not ordinary metadata fields.
- In the packaged AI Studio skill, the CLI is delivered as `scripts/aistudio.js`. Keep cwd at the project root and run the script by path, such as `node .agents/skills/aistudio/scripts/aistudio.js <command> ...`.
- Command examples that start with `aistudio` are shorthand for the bundled script path. Do not search `PATH` for a global `aistudio` executable during skill use.
- Run `init` only when the user explicitly asks to initialize or scaffold a blank project. Do not run `init` before ordinary workflow creation or editing.

## Standalone vs App-Backed Workflows

Before creating or modifying a workflow, decide whether the workflow is standalone or app-backed.

- Treat a workflow as app-backed only when the user explicitly says it is for an app, app agent, app panel, app communication, app template, target agent, `InitDisplay`, `InitActions`, `InitCommunications`, `FillParameters`, `SendCommunication`, AI Apps, Agentic App, or app-compatible workflow.
- Do not infer app-backed workflow requirements from generic words such as chat, assistant, advisor, agent, or LLM.
- For standalone workflows, do not set `aiAppsCompatibleFlag`, do not add `$context.$app` stage routing, and do not add app-stage paths.
- For app-backed workflows, also read the App Builder prompt references. The app configuration determines which app-stage paths are required.
- Only set or change `aiAppsCompatibleFlag` when app-backed intent is explicit.
- When app-backed intent is explicit, workflow work is incomplete until each required app stage is a distinct routable path as described by the App Builder backing workflow contract.
- When an app capability should call the workflow, add a distinct `InvokeCapability` branch for `$context.$app.$OraMessageHint`. Use `$context.$app.$OraAction` as the capability name/code and `$context.$app.$OraActionPayload` as the capability input payload. The source schema for that branch should match the app capability input specification.
- When dynamic Ask Oracle starter queries reference the workflow, add a distinct `InitSampleQueries` branch for `$context.$app.$OraMessageHint`. The branch must return strict JSON shaped as an object keyed by category id, where each category value is `{ "displayName": string, "samples": string[] }`; for example `{ "recommended": { "displayName": "Recommended", "samples": ["Show me today's highest-risk accounts"] } }`. Return only the JSON payload, with no markdown, widgets, ids inside `samples`, or explanatory prose.
- Skipping workflow tests does not skip app workflow contract validation; run `validate-workflow` after app-backed workflow changes and fix app-stage routing errors before finalizing.
- For new app-backed workflows, use a `SWITCH` node on `$context.$app.$OraMessageHint` as the app-stage router. When multiple app stages share the same upstream data fetch nodes and guard conditions, place all shared fetch nodes and guard/RETURN conditions BEFORE the switch — not inside each stage branch. Only use a switch-first structure when each stage genuinely requires different upstream data that cannot be shared. Route each required app stage to its own separate terminal `LLM` or `AGENT` node.
- Dedicated app-stage terminal does not mean dedicated full data-fetch chain. If `InitDisplay` and `Query` need the same recordable data, fetch and guard that data once before the app-stage router, then branch only to dedicated terminal `LLM`/`AGENT` nodes.
- Do not create a terminal `CODE` node that assembles or returns `oraInfoDisplay` XML or widget JSON for a successful app-stage response. If deterministic shaping is needed, put that `CODE` node before the app-stage router and let the dedicated app-stage `LLM` or `AGENT` emit the widget.
- Bad: `START → SWITCH on $context.$app.$OraMessageHint → InitDisplay fetch chain / Query duplicate fetch chain`. Good: `START → shared fetches → shared guards/fallback RETURNs → SWITCH on $context.$app.$OraMessageHint → InitDisplay terminal / Query terminal`.
- If app contract or test sync diagnostics indicate duplicated recordable data behind app-stage routing, inspect the topology. If the stages use the same data, repair by moving shared fetch/guard nodes before the app-stage router. Do not repair by cloning recordable nodes per app stage.
- If the user supplies one prompt with `APP_STAGE: {{$context.$app.$OraMessageHint}}` and multiple `If APP_STAGE indicates ...` branches, treat it as source material to split apart. Do not install it as one LLM/AGENT prompt.
- Do not fold `InitSampleQueries` or `InvokeCapability` into `Query` or `InvokeAction` when that app-hint-specific behavior is needed. Route each required app hint to its own path, with any shared fetch/guard nodes kept before the app-stage router when they are common to other stages.
- A single-node app-backed workflow is invalid when it must handle more than one app message hint. Do not create `START -> one LLM/AGENT -> END` for an app workflow that includes both startup display and query behavior.
- Minimum app-backed workflow topology for `InitDisplay` plus `Query` with shared upstream data: `START → shared data fetch nodes → guard conditions → SWITCH on $context.$app.$OraMessageHint → dedicated InitDisplay terminal → END` and a separate `Query` case to a dedicated Query terminal. Shared data fetch nodes and guard conditions must not be duplicated inside each stage branch.
- If empty user-message behavior should behave like `InitDisplay`, add graph routing for that case and send it to the InitDisplay terminal; do not bury that condition inside one terminal prompt.

Examples:

- Tool call: `do-modify-node` with `{"nodeCode":"A1","inputsPatch":{"prompt":"..."}}`
- CLI call: `aistudio do-modify-node --file src/workflows/foo.wf --node-code A1 --inputs-patch '{"prompt":"..."}'`
- CLI preview: `aistudio do-modify-node --file src/workflows/foo.wf --node-code A1 --inputs-patch '{"prompt":"..."}' --dry-run`
- Tool call (App Experience): `do-modify-node` with `{"nodeCode":"INIT_DISPLAY","aiAppOutputSpecification":{"dataDisplay":{"layouts":["ORA_LAYOUT_CARD"],"customNotes":"Use cardWidget only."}}}`
- CLI call (App Experience): `aistudio do-modify-node --file src/workflows/foo.wf --node-code INIT_DISPLAY --ai-app-output-specification '{"dataDisplay":{"layouts":["ORA_LAYOUT_CARD"],"customNotes":"Use cardWidget only."}}'`
- CLI preview (App Experience): `aistudio do-modify-node --file src/workflows/foo.wf --node-code INIT_DISPLAY --ai-app-output-specification '{"dataDisplay":{"layouts":["ORA_LAYOUT_CARD"],"customNotes":"Use cardWidget only."}}' --dry-run`

Expression-bearing node inputs must use file-backed patches:

- CLI call: `aistudio do-modify-node --file src/workflows/foo.wf --node-code HAS_RECORD --inputs-patch @.debug/has-record-inputs.json`
- Do not pass `CONDITION.inputs.condition` inline through shell arguments when the expression contains quotes, `$context`, `{{...}}`, comparison operators, or empty-string literals.
- For simple existence guards, prefer quote-free checks such as `{{!!$context.$nodes.FETCH_RECORD.$output.items?.[0]?.RecordId}}`.
- After applying condition or switch guard changes, validate or read the workflow back before recording tests.

- Tool call: `get-nodes-metadata-by-code` with `{"nodeCodes":["A1","B2"]}`
- CLI call: `aistudio get-nodes-metadata-by-code --file src/workflows/foo.wf --node-codes '["A1","B2"]'`

- Tool call: `do-prettify-workflow` with `{}`
- CLI call: `aistudio do-prettify-workflow --file src/workflows/foo.wf`
- CLI preview: `aistudio do-prettify-workflow --file src/workflows/foo.wf --dry-run`

- CLI-only create: `aistudio do-create-workflow --name "Hello Workflow" --family HCM --product TOUCHPOINTS`
- CLI-only metadata update: `aistudio do-modify-workflow-metadata --file src/workflows/foo.wf --description "Keep this summary current."`
- CLI-only diff preview on request: `aistudio do-modify-workflow-metadata --file src/workflows/foo.wf --description "Keep this summary current." --dry-run`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
