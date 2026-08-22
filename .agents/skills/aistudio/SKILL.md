---
name: aistudio
description: Use for creating or modifying AI Studio app and workflow project resources, including agentic apps, workflows, business objects/BO nodes, policies, tools, connectors, approvals, document schemas, and function templates. Route requests, load the relevant bundled prompt references, and use the bundled aistudio CLI for local work.
---

# AI Studio

**Copyright:** Copyright (c) 2026 Oracle and/or its affiliates
**License:** UPL (Universal Permissive License)

Use this skill to create or modify AI Studio app and workflow project resources, including agentic apps and related local project resources.

## Start Here

1. Classify the requested artifact before choosing prompts or commands.
2. Before creating any new artifact, resolve package layout from the current project. If multiple app packages exist and the current user request did not explicitly name one, ask for the target app package and stop before any discovery, planning, generation, test sync, or create command.
3. Read `references/prompts/index.md` to see available prompt references.
4. Load only the prompt files relevant to the task.
5. Keep the shell working directory at the AI Studio project root. Do not `cd` into the skill directory to run commands.
6. Run the bundled CLI by path, for example `node .agents/skills/aistudio/scripts/aistudio.js <command> ...` from the project root. If the skill is installed elsewhere, use that skill directory's `scripts/aistudio.js` path while keeping cwd at the project root.
7. Treat prompt examples that start with `aistudio` as shorthand for the bundled script path. Do not search `PATH`, install a global CLI, or run `which aistudio` / `command -v aistudio` unless the user explicitly asks for global CLI setup.
8. Run `init` only when the user explicitly asks to initialize or scaffold a blank project. Do not run `init` as a prerequisite for creating apps, workflows, or other artifacts in an existing workspace.

## Artifact Routing

Natural-language artifact phrases are primary. File extensions, file paths, and explicit command names are override signals.

| User intent | Artifact | Primary reference |
| --- | --- | --- |
| workflow, workflow node, step, edge, connect, wire, tool node, add a tool to a workflow | `.wf` workflow | `workflow-vibe.md`; node details in `workflow-node-prompts/` |
| app, agentic app, app panel, app communication, app template, app action | `.app` app | `app-ingestion.md`, `app-best-practices.md`, `app-vibe-master.md` plus app-specific prompts |
| business object | `.bo` Business Object | `business-object-builder.md` |
| business object tool, BO tool, deeplink tool, document tool, email tool, external REST tool, MCP tool, connector tool | `.tool` Tool | `tools-builder.md` |
| deeplink or deep link source artifact | `.dl` Deeplink | `artifact-conventions.md` plus CLI help |
| topic or instructions | `.topic` Topic | `artifact-conventions.md` plus CLI help |
| agent | `.agent` Agent | `artifact-conventions.md` plus CLI help |
| connector definition or generated connector from OpenAPI/MCP spec | `.connectorDefinition` Connector Definition | `connector-definition-cli-compat.md` |
| connector instance or configured connector | `.connectorInstance` Connector Instance | `connector-instance-cli-compat.md` |
| approval process | `.approval` Approval Process | `approval-process-builder.md` |
| policy or policy store | `.policy` Policy Store | `policy-store-builder.md` |
| policy template | `.policyTemplate` Policy Template | `policy-store-builder.md` and `policy-store-cli-compat.md` |
| document schema | `.documentSchema` Document Schema | `document-schema-builder.md` |
| function template or reusable function | `.function` Function Template | `function-builder.md` |

If wording could still mean more than one artifact, ask one targeted question: Tool artifact, source artifact, or workflow node?

## Workflow And App Boundary

Before building or modifying a workflow, decide whether it is standalone or app-backed.

- Standalone workflow intent: the user asks for a workflow, automation, node, or debug flow without mentioning an app.
- App-backed workflow intent: the user says the workflow is for an app, app agent, app panel, app communication, app template, target agent, `InitDisplay`, `InitActions`, `InitCommunications`, `FillParameters`, `SendCommunication`, AI Apps, Agentic App, or app-compatible workflow.
- For standalone workflows, read `workflow-vibe.md` and the relevant `workflow-node-prompts/*` files. Do not add app-stage routing or `aiAppsCompatibleFlag`.
- For app-backed workflows, read both workflow references and `app-vibe-master.md` / `app-vibe-templates.md` as needed. App configuration determines which app-stage paths are required.
- Only set or change `aiAppsCompatibleFlag` when app intent is explicit.
- When app intent is explicit, the workflow is incomplete until the required app-stage paths are real and routable. See the app prompt references for `InitDisplay`, `InitActions`, `InitCommunications`, `FillParameters`, and `SendCommunication` requirements.
- For app-backed workflows, route on `$context.$app.$OraMessageHint` in the graph, usually with a `SWITCH` node. Do not put multiple app-stage branches into one LLM/AGENT prompt.
- For app-backed workflows with shared recordable data, shared fetch/guard nodes must run before the app-stage router; only terminal LLM/AGENT nodes need to be stage-specific.
- A single-node app-backed workflow is invalid when it must handle more than one app message hint. For `InitDisplay` plus `Query`, create separate terminal nodes behind the `OraMessageHint` router.

## Reference Loading

- Workflow authoring: read `workflow-vibe.md`; for node work, also read `workflow-node-prompts/index.md` and the relevant node prompt files. When a workflow is created or materially edited, also read `workflow-test-authoring.md` before concluding so the automatic test sync handoff is visible.
- Workflow debugging: read `workflow-debug.md`.
- Workflow test authoring: read `workflow-test-authoring.md`. For scripted multi-turn creation, editing, recording, execution, or diagnosis, also read `workflow-conversation-test-authoring.md`; it extends rather than replaces the single-turn contract. The semantic judge section owns the model-authored judge flow and the read-only `get-workflow-test-judge-context` contract retrieval command. Treat `needs-model-test-data` as a nonterminal continuation and complete its compaction/apply flow before continuing workflow or app sync.
- Distinguish preview from execution. Requests like "show", "inspect", "preview", "display", "what would be generated", or "get the sync plan" are read-only plan requests: run only the relevant `get-*-test-sync-plan` command and explain the plan. Requests like "run", "execute", "generate", "regenerate", "sync", "create/update the tests", or "complete the sync plan" are execution requests: complete the workflow or app test sync loop from the relevant prompt reference. Do not stop after printing a plan when executable missing or out-of-sync actions remain and no user decision is required.
- Final-response checkpoint for test-sync execution requests: a latest workflow plan with `finalSummaryAllowed: false` or `coverageExecution.nextActionIds`, or a latest app plan with required backing workflow actions, prohibits a final response. Execute the listed next action or required workflow command instead. A summary of pending counts is not a valid execution result. Follow the detailed completion and blocker rules in `workflow-test-authoring.md` and `app-test-authoring.md`.
- Workflow optimization: when the user asks about model costs, token usage, model comparison, cost reduction, BO payload size, prompt verbosity, or which model to use on a node, read `workflow-test-authoring.md` for the optimization command reference. Do not run optimization commands automatically during normal workflow creation or editing.
- App intake for new app work, material app edits, and app-backed workflow creation: read `app-ingestion.md` before asking questions or starting implementation. A confirmed BO or other data source does not complete intake by itself.
- App authoring: read `app-best-practices.md` and `app-vibe-master.md`; add `app-vibe-plan.md`, `app-vibe-actions.md`, `app-vibe-templates.md`, or `app-vibe-widgets.md` only when relevant.
- App test authoring: after creating or materially editing an app with at least one top-level agent container, read `app-test-authoring.md` and run the app test sync loop unless the user explicitly opted out or asked only for analysis/planning.
- Business Objects: read `business-object-builder.md`; for workflow BO nodes, read `workflow-node-prompts/bo-function.md`.
- Tools: read `tools-builder.md`.
- Connector Definitions: read `connector-definition-cli-compat.md`.
- Connector Instances: read `connector-instance-cli-compat.md`.
- Approval Processes: read `approval-process-builder.md`.
- Policy Store / Policy Templates: read `policy-store-builder.md` and `policy-store-cli-compat.md`.
- Document Schemas: read `document-schema-builder.md`.
- Functions: read `function-builder.md`.
- General file conventions: read `artifact-conventions.md` when you need local file paths, extension mapping, or normalized-file reminders.

## Resources

- App samples live under `resources/app-samples/`. Read `resources/app-samples/index.md` before using app samples; it lists each available sample file and what it demonstrates.

## Global CLI Rules

- Prefer bundled CLI commands over direct JSON edits when a command supports the requested operation.
- Invoke the bundled CLI by path from the project root, such as `node .agents/skills/aistudio/scripts/aistudio.js <command> ...`. Bare `aistudio <command>` examples in references are shorthand only.
- Never use `npm run` or `npm test` to execute workflow tests, optimization sweeps, or any aistudio command. The `app-pkg/package.json` and root `package.json` npm scripts are for CI/CD pipelines only. Always invoke the CLI binary directly.
- Never pass `--judge-provider remote` to `run-workflow-test`, `run-workflow-tests`, or any optimization sweep command unless the user explicitly requests remote judging. This applies regardless of workspace type; the presence of `app-pkg/package.json` with remote-judge npm scripts does not change this default.
- Treat data source and evaluation mode as independent. A user request for file mode means pass `--data-source file` only. For an ordinary test run, omit `--evaluation-mode` so each test uses its configured mode, and omit `--judge-provider` so local judging remains the default. Pass `--evaluation-mode deterministic` only when the user explicitly requests deterministic-only execution or when test-authoring guidance requires transient validation of one affected test. Never use deterministic execution as a final confirmation after local judge attachment.
- When an authenticated AI Studio command, including a normal draft save, fails while sandboxed and the host keystore or credential store may be unavailable, do not conclude that authentication or the operation failed. Retry the same command outside the sandbox so it can access the host credential store, requesting escalation if required. Enter the `AUTH_REQUIRED` recovery flow only if the unsandboxed retry also returns `AUTH_REQUIRED`.
- For basic/dev-mode pre-production or PD environments, normal artifact commands never prompt for the FA password. If any CLI command returns JSON with `code: "AUTH_REQUIRED"`, do not treat that JSON as the final result and do not simply report the manual command. Pause the original command and recover authentication first:
  - In a real foreground terminal, run the returned `interactiveCommand` so the user can type into the hidden prompt, then retry the original command.
  - In background terminal UIs that cannot expose hidden password prompts, say: "This UI cannot expose the hidden password prompt." Then present both recovery choices: the user can run the returned `interactiveCommand` in their own terminal, or the user can explicitly authorize passing a password they provide to the returned `agentCommand` using `--password-stdin`.
  - Do not choose the manual terminal path on the user's behalf when `agentCommand` is available. Ask which recovery path they want. Use `--password-stdin` only after explicit user confirmation, and never write raw or base64 password values into `env.properties`, command arguments, files, or logs. After `configure-basic-auth` succeeds, retry the original command once.
- Do not add or restore `aistudio.basic-auth.passphrase` in `env.properties`. `configure-basic-auth` stores the Basic Auth encryption passphrase in the local secret store and writes only the encrypted Basic Auth value. For headless/CI or keychain-less environments, use `AISTUDIO_FA_PASSWORD` for basic/dev-mode auth instead of persisting Basic Auth.
- Do not run `init` unless the user explicitly asks to initialize or scaffold the project.
- Before creating any new artifact, check whether `app-pkg/` contains AI Studio app packages. If none exist, use the legacy `src` layout. If exactly one exists, create under that app package. If more than one exists, the current user request must explicitly name the package. Prior turns, existing artifacts, and earlier package selections are not enough; stop and ask for the target app package before discovery, planning, generation, test sync, or create commands.
- Never pass `--dir src/...` to create artifacts in a repo that has app packages. Use `--app-package <name>` only after the current user request names the package or the user answers the package question, and let the CLI choose the package-local directory.
- Keep generated artifacts local unless the user explicitly asks to save, push, publish, fetch, pull, load, or refresh remote state.
- Never publish workflows from the CLI. Do not change a workflow status to `PUBLISHED` and post it from the CLI, and do not use hidden commands, helper APIs, custom scripts, or direct backend calls as a workaround.
- Use server fetch commands only when the user explicitly asks for server state. If a fetch says the local file differs from the server version, stop and ask before using `--force`.
- Use `--dry-run` only when the user wants an exact diff preview before writing.
- Apply mutating commands serially per artifact file. After each mutation, treat the updated file as the source of truth before issuing the next mutating command.
- Do not run mutating CLI commands in parallel against the same `.app`, `.wf`, `.approval`, `.bo`, `.dl`, `.topic`, `.agent`, `.tool`, `.connectorDefinition`, `.connectorInstance`, `.policy`, `.policyTemplate`, `.documentSchema`, or `.function` file.
- Treat IDs and sample values in CLI help, prompts, tests, and checked-in examples as syntax examples only, not reusable live data.
- Do not inspect unrelated AI Studio framework/app source code, bundled implementation files, or minified assets to infer hidden contracts unless the user explicitly asks for source-level investigation.
- If the CLI, prompt references, and current project files do not make a contract clear, stop and ask instead of reverse-engineering internals.

## Local Layout

| Artifact | Default location |
| --- | --- |
| Workflow | `src/workflows/*.wf` |
| App | `src/apps/*.app` |
| Agent | `src/agents/*.agent` |
| Business Object | `src/businessObjects/*.bo` |
| Deeplink | `src/deeplinks/*.dl` |
| Topic | `src/topics/*.topic` |
| Tool | `src/tools/*.tool` |
| Connector Definition | `src/connectorDefinitions/*.connectorDefinition` |
| Connector Instance | `src/connectorInstances/*.connectorInstance` |
| Approval Process | `src/approvals/*.approval` |
| Policy Store | `src/policies/*.policy` |
| Policy Template | `src/policyTemplates/*.policyTemplate` |
| Document Schema | `src/documentSchemas/*.documentSchema` |
| Function Template | `src/functions/*.function` |

`init` is for explicit blank-project setup only; artifact creation commands write their own target files and should not be preceded by `init` in an existing project.

## Verification

- After material workflow edits, run `node .agents/skills/aistudio/scripts/aistudio.js do-prettify-workflow --file <workflow-file>` after structural batches, then run `node .agents/skills/aistudio/scripts/aistudio.js validate-workflow --file <workflow-file>`.
- For condition, switch, code, return, or other expression-bearing workflow node edits, use file-backed JSON patch inputs such as `--inputs-patch @.debug/<name>-inputs.json`; do not inline JSON containing empty-string literals, quotes, `$context`, `{{...}}`, comparison operators, or expression syntax through the shell. For condition guards, prefer quote-free existence checks such as `{{!!...}}` when equivalent. After modifying a guard expression, read back or validate the workflow before recording tests so shell quoting did not strip literals. If live recording reaches an unexpected fallback, inspect guard expressions before reporting an environment blocker.
- After a successful workflow create or material workflow edit, do not stop at prettify/validation. Unless the user explicitly opted out or asked only for analysis/planning, continue with the automatic workflow test sync loop from `workflow-test-authoring.md`, starting with `node .agents/skills/aistudio/scripts/aistudio.js get-workflow-test-sync-plan --file <workflow-file>`. This applies to new workflow files, node additions, node edits, edge rewiring, prompt/code changes, behavior-changing metadata changes, and direct workflow-file repairs when the CLI did not support the operation.
- After a successful app create or material app edit, run the app flow from `app-test-authoring.md` for apps with top-level agent containers. That prompt owns scope selection and the detailed sequence. An app-wide request completes every required backing workflow and app action, runs `do-sync-app-tests --file <app-file>`, and finishes with `get-app-test-final-summary --file <app-file>`. A request naming one panel, one app test, or one backing workflow together with its panel completes only that workflow and matching panel action, runs only `run-app-test --test-file <target-app-test>`, and does not call the app-wide sync or final-summary commands. `do-sync-app-tests` does not generate, record, or run workflow tests. If the app is only an empty shell with no top-level agent containers, report that app tests will be created after a panel is added; do not fabricate tests for an untestable shell.
- When standalone workflow tests finish, run `node .agents/skills/aistudio/scripts/aistudio.js get-workflow-test-final-summary --file <workflow-file>` and use that command output as the evidence source for the final response section named exactly `Validation and Insights` after your workflow creation, change, or sync-outcome summary. Preserve the test counts, workflow suite report, `Metrics:`, and `Optimization:`. Do not hand assemble them from suite JSON or rerun tests merely to refresh reports.
- When app-wide tests finish, run `node .agents/skills/aistudio/scripts/aistudio.js get-app-test-final-summary --file <app-file>` and use that command output as the evidence source for the final response section named exactly `Validation and Insights` after your app creation, change, or sync-outcome summary. Preserve the app test counts, app-scoped consolidated report, app-scoped app suite report, and each backing workflow's suite report, `Metrics:`, and `Optimization:`. For targeted workflow-and-panel execution, present only the selected workflow final summary and targeted app-test result and report; do not call the app-wide final-summary command or enumerate unrelated tests. Never substitute a workspace-wide report unless the user explicitly requested workspace-wide or package-wide results. Do not rerun workflow tests, app tests, or full sync merely to regenerate a final summary. Use `--format json` only when the user requests structured diagnostics or detailed failure data.
- After material app, BO, deeplink, topic, agent, tool, connector, approval-process, policy, policy-template, document-schema, or function edits, run the matching `validate-*` command when available.
- Report backend failures plainly. Do not retarget saves, invent schemas, or fabricate missing example payloads just to pass validation.

## Scope

This is the base AI Studio skill. It should stay concise and point to bundled prompt references for artifact-specific details.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
