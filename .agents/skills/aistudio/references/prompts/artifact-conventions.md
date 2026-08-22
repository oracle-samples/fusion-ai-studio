# AI Studio Artifact Conventions

Use this reference when you need local file paths, extension mapping, or normalized-file reminders.

## CLI Invocation

- The packaged skill includes the CLI at `scripts/aistudio.js`.
- Keep the shell working directory at the AI Studio project root. Do not `cd` into the skill directory to run commands.
- Run commands by script path, for example `node .agents/skills/aistudio/scripts/aistudio.js <command> ...` from the project root.
- Prompt references may show `aistudio <command>` for readability; treat that as shorthand for the bundled script path.
- Do not search `PATH` for a global `aistudio` executable during skill use.
- Run `init` only when the user explicitly asks to initialize or scaffold a blank project.
- For new source-controlled app-package repos, use `init-app-package --app-package <name>` instead of legacy `init`. The module name is derived from the app package name by default. Pass `--modulename <moduleName>` only when the module folder must use a custom name.

## Local Files

AI Studio supports two local layouts.

Legacy workspaces use root `src`, `test`, and `test-reports` folders. Existing legacy files remain valid when commands target them explicitly.

Source-controlled app-package repos use this shape:

```text
app-pkg/<package>/
  sources/app-package.json
  sources/ai/self/<module-name>/
  tests/ai/self/<module-name>/
  test-reports/
```

Before creating artifacts or tests, count the AI Studio app packages under `app-pkg/`.

- If no app packages exist, use the legacy root `src`, `test`, and `test-reports` layout.
- If exactly one app package exists, use that package and do not create root `src`, `test`, or `test-reports` artifacts.
- If more than one app package exists, the current user request must explicitly name the target package. Prior turns, existing artifacts, the first package in directory order, domain similarity, and earlier package selections are not valid selection signals. Ask one question for the target app package and stop before BO search, app planning, workflow generation, test sync, or any create command. Only pass `--app-package <name>` after the current user request names the package or the user answers that package question.

Do not use `--dir src/...` as a workaround in app-package repos; root `src`/`test` output is only for repos with no app packages.

| Artifact | Location | Creation command |
| --- | --- | --- |
| Workflow | `src/workflows/*.wf` | `aistudio do-create-workflow` |
| App | `src/apps/*.app` | `aistudio do-create-app` |
| Agent | `src/agents/*.agent` | `aistudio do-create-agent` |
| Business Object | `src/businessObjects/*.bo` | `aistudio do-create-bo` |
| Deeplink | `src/deeplinks/*.dl` | `aistudio do-create-deeplink` |
| Topic | `src/topics/*.topic` | `aistudio do-create-topic` |
| Tool | `src/tools/*.tool` | `aistudio do-create-tool --tool-type <type>` |
| Connector Definition | `src/connectorDefinitions/*.connectorDefinition` | `aistudio do-generate-connector-definition` |
| Connector Instance | `src/connectorInstances/*.connectorInstance` | `aistudio do-create-connector-instance` |
| Approval Process | `src/approvals/*.approval` | `aistudio do-create-approval-process` |
| Policy Store | `src/policies/*.policy` | `aistudio do-create-policy` |
| Policy Template | `src/policyTemplates/*.policyTemplate` | `aistudio do-create-policy-template` |
| Document Schema | `src/documentSchemas/*.documentSchema` | `aistudio do-create-document-schema` |
| Function Template | `src/functions/*.function` | `aistudio do-create-function` |

In app-package repos, use these package-local source directories instead of root `src`:

| Artifact | App-package location |
| --- | --- |
| Workflow | `app-pkg/<package>/sources/ai/self/<module-name>/workflows/<lowercase-workflowCode>/<file>.wf` |
| App | `app-pkg/<package>/sources/ai/self/<module-name>/applications/<lowercase-code>/<file>.apps` |
| Agent | `app-pkg/<package>/sources/ai/self/<module-name>/agents/<lowercase-agentCode>/<file>.agent` |
| Signal | `app-pkg/<package>/sources/ai/self/<module-name>/signals/<lowercase-code>/<file>.signal` |
| Business Object | `app-pkg/<package>/sources/ai/self/<module-name>/businessObjects/<lowercase-objectCode>/<file>.bo` |
| Deeplink | `app-pkg/<package>/sources/ai/self/<module-name>/deepLinks/<lowercase-deepLinkCode>/<file>.deeplink` |
| Topic | `app-pkg/<package>/sources/ai/self/<module-name>/topics/<lowercase-topicCode>/<file>.topic` |
| Tool | `app-pkg/<package>/sources/ai/self/<module-name>/tools/<lowercase-toolCode>/<file>.tool` |
| Approval Process | `app-pkg/<package>/sources/ai/self/<module-name>/approvals/*.approval` |
| Policy Store | `app-pkg/<package>/sources/ai/self/<module-name>/policies/<lowercase-code>/<file>.policy` |
| Policy Template | `app-pkg/<package>/sources/ai/self/<module-name>/policyTemplates/<lowercase-code>/<file>.policyTemplate` |
| Document Schema | `app-pkg/<package>/sources/ai/self/<module-name>/documentSchemas/<lowercase-code>/<file>.documentSchema` |
| Function Template | `app-pkg/<package>/sources/ai/self/<module-name>/functions/<lowercase-code>/<file>.function` |
| Connector Definition | `app-pkg/<package>/sources/ai/self/<module-name>/connectorDefinitions/*.connectorDefinition` |
| Connector Instance | `app-pkg/<package>/sources/ai/self/<module-name>/connectorInstances/<lowercase-code>/<file>.connectorInstance` |

New app-package files live under a lowercased artifact-code folder unless the artifact type is still pending a confirmed source-control code field. Approval Process and Connector Definition remain flat under their artifact-type directory until those fields are confirmed. Filenames do not need to match the internal artifact code.

## Test And Report Files

Legacy workflow tests live under `test/workflows/<workflow-slug>/<test-name>.json`.

Legacy application tests live under `test/apps/<app-code-folder>/<test-name>.json`.

App-package workflow tests live under `app-pkg/<package>/tests/ai/self/<module-name>/workflows/<workflow-slug>/<test-name>.json`. Workflow tests should rely on `workflow.workflowCode` only. Do not add copied `src/workflows/...` paths as `workflow.file`, and do not write `workflow.status` or `workflow.version` into new tests. Workflow status is selected at runtime from the local `.wf` or `--workflow-status DRAFT|PUBLISHED`.

App-package application tests live under `app-pkg/<package>/tests/ai/self/<module-name>/applications/<app-slug>/<test-name>.json`.

Workflow reports for app packages are generated under `app-pkg/<package>/test-reports/workflows/`. Application reports are generated under `app-pkg/<package>/test-reports/applications/`. Do not source-control report folders.

Application test folders follow workflow test folder style: lowercased artifact code folder names preserve underscores. Do not add a panel directory level. Panel segments are stored in the app test JSON and used for test names, filtering, and reports.

When running comparisons, token analysis, or optimization sweeps in an app-package repo, use the package-local report paths printed by the CLI. Do not rewrite them to root `test-reports/workflows` paths.

## Normalized File Shapes

- Workflow and app `specification` values are JSON objects, not JSON strings.
- Agent `specification` values are JSON objects. `agentToolMappings` and `agentTopicMappings` are arrays, not BOSS transport `{ "items": [...] }` wrappers.
- Business Object `objectProperties` is JSON. Legacy BO files with `specification.objectProperties` are readable and migrate to top-level `objectProperties` on save.
- Deeplink `deepLinkProperties` is JSON locally. The CLI stringifies it only in the server save payload.
- Topic files use BOSS field names directly, including `instructions.items`; do not wrap topics in `specification`.
- Tool `specification` is JSON, with parsed child collections such as `restTool`, `deepLinkTool`, `retrievalDocuments`, and `messageDeliveryOptions`.
- Approval-process files store the create payload shape at the top level, not inside `specification`.
- Policy, Policy Template, Document Schema, and Function files store normalized local JSON directly, not wrapper objects.

## Lifecycle Rules

- Use fetch commands only when the user explicitly asks to pull/refresh/load server state.
- Use save/delete server commands only when the user explicitly asks to persist or delete remotely.
- Never publish workflows from the CLI, even when the user asks. Do not change a workflow status to `PUBLISHED` and post it from the CLI, and do not use hidden commands, helper imports, custom scripts, direct backend REST calls, or Workflow Builder publish utilities as a workaround.
- For non-workflow artifacts, use lifecycle commands only when the user explicitly asks and the command is exposed by the CLI.
- Local create/update/validate commands generally do not require `env.properties`; server-backed discovery, generation, upload, save, non-workflow lifecycle changes, customize, or delete commands generally do. Do not run `init` just to create local artifact directories.
- Use command-specific help for exact options and whether a command supports `--dry-run`.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
