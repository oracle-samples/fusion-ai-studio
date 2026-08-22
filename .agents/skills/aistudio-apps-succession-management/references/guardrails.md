# AI Studio Wrapper Guardrails

## Product Boundary

Keep personas, outcomes, terminology, experience hierarchy, summary content, canonical display names, technical identifiers, naming prefixes, business rules, risks, welcome wording, choice wording, and post-build options in the product `SKILL.md`. Keep this file free of product-specific codes and names.

## Current AI Studio Authority

Read the current local `aistudio` skill and the operation-specific references it requires immediately before each handoff. Treat its package routing, supported commands, artifact contracts, app intake, creation, and direct validation rules as authoritative. The mandatory local-first source-order rule below is a domain override of inherited mode-specific discovery ordering. Never use a cached contract and never modify the base skill.

If the current `aistudio` contract conflicts with the wrapper outside that deliberate source-order override, stop before an unsafe action and report the incompatibility. Do not invent a workaround.

The product-defined post-creation Action Code Map is a narrow exception for newly created current-flow app files. Let the supported action operation create actions and assign their IDs and temporary codes; when that operation cannot set the required runtime code, directly normalize only the created file as specified below. This does not authorize changing the base skill, reference artifacts, or existing files.

## Display Names and Technical View

In normal view:

- use the display name returned by discovery;
- otherwise use the canonical display name from the product `SKILL.md`;
- if neither exists, use the code and give a truthful artifact-category description and state that the display name is unavailable;
- never invent a friendly name;
- hide codes (unless name is not present or not found), filenames, paths, directories, internal IDs, business-object codes, agent and tool codes, nodes, commands, payloads, and raw validation output;
- translate failures and validation results to display names without changing factual meaning.

Offer technical view after discovery, before creation, during failure handling, after validation, and whenever requested. In technical view, pair identifiers with display names. Technical view does not authorize creation, mutation, remote access, or testing.

## Existing and Current-Flow Resources

### Existing artifacts
Existing artifacts discovered locally or through the environment are read/reuse only. 
They may be:
- discovered
- inspected
- summarized
- referenced
- reused as dependencies

They must not be:
- modified
- renamed
- deleted
- overwritten
- re-scaffolded
- recreated in place
- patched
- saved over
- force-fetched over local changes

If the user asks to modify an existing artifact, offer a safe alternative. Do not create or revise that alternative unless the user explicitly requests that named new artifact.

### Current-flow artifacts
Modify only resources proven to have been created during the current guided flow. If provenance is unclear, treat the resource as existing and protected. Limit mutation to the exact display-name resource set approved in the latest proposal. If another resource becomes necessary, stop and obtain approval for a revised proposal.

## Local-first Discovery

In every Codex execution mode, complete discovery in the resolved local workspace or local AI Studio project before any environment lookup for every in-scope artifact or reference type. Require a local result of found, not found, or unavailable before proceeding. Environment discovery is allowed only as a read-only fallback when no related local artifact is found or local discovery is unavailable, or when the user explicitly asks to compare local results with environment artifacts. A suitable local artifact is the required default for reuse and wiring and must not be silently replaced by an environment result.

Environment discovery must be read-only. Do not fetch over local files, save, publish, force refresh, overwrite, or otherwise change local or server artifacts as part of discovery. Apply mandatory local-first discovery to every artifact or reference lookup used by the active flow, including workflows, apps/workspaces, business objects, tools, deeplinks, supporting artifacts, summary-section patterns, and action-reference patterns. For every prescribed action, inspect related local reference apps first; inspect an environment reference app only when no suitable local pattern exists or local inspection is unavailable. Scope rules may defer broad business-object or supporting-artifact discovery until an explicitly entered new-workflow branch, but they never permit environment-first discovery.

## Workflow Reuse Boundary

Reuse a selected existing workflow as one complete dependency. Do not inspect its business objects, tools, agents, nodes, action configuration, or other internals unless technical view is active, exact evidence is needed for a requested capability, or a new workflow is being created.

Do not modify, replace, copy, or recreate a reused workflow. Reused workflows are outside the direct-validation scope; offer only reusable-experience selection, technical details, or stopping. Do not enter a new-workflow branch because discovery returns `Not found`; enter it only when the user independently and explicitly requests a named new workflow.

## Reference-App Action Boundary

Treat discovered reference apps as protected, read-only guidance for action configuration. For each prescribed action, require factual existing-workflow support, the product-defined action code, and a selected reference-app pattern. Search locally first and use an environment reference app only as a read-only fallback. Create the supported action normally, then normalize its temporary code only in the newly created current-flow app. Never copy, modify, recreate, or derive a destination from a reference app. If any required evidence is unavailable before creation, report the action as unsupported; do not create a workflow or substitute another action.

## Project Layout and Creation Destination

Let `aistudio` resolve project layout before discovery in every new-artifact flow. The resolved layout selects the app-package boundary for the remainder of that flow.
- With no app packages, use the supported legacy root `src/<artifact-type>` layout.
- With one app package, record and use its package-local source tree.
- With multiple app packages, stop until the current user selects the target package before discovery, planning, generation, test sync, creation, or modification.
- Never infer a package from prior turns, directory order, product similarity, discovered resources, or existing artifacts.
- Never derive a destination from the directory of a discovered resource.
- Never place a new file beside a discovered file merely because it was found there.
- Never use a root `src` override in an app-package project.
- Keep the working directory at the project root and let the supported creation command choose the precise path.
- Do not run `init` unless the user explicitly requests initialization of a blank project.

## New-App Naming and Collision Boundary

For each new-app build, generate a local token only for the product-designated tokenized app code. Do not derive the token from user identity, system accounts, Git, external data, or a UUID. Apply the product-defined app-specific code rules and preserve canonical display names without adding a token or other generated text.

Before proposal approval, use `aistudio` to inspect the resolved local project only for product-designated tokenized app codes. When a local app file has the candidate code, regenerate the token and repeat the local check before proposing the set. Do not query the environment or run this check for fixed app codes. When the local check fails or is unavailable, proceed without blocking and do not expose a success, failure, or status message for this check. Never use the check to overwrite, rename, modify, or otherwise affect an existing artifact. An actual creation collision remains a factual failure and must never trigger an overwrite.

## Data Grounding and Intake

- Confirm the real external data source for every data-dependent app or workflow.
- Do not treat app context, user context, attachments, prompts, sample values, or invented records as operational data.
- Ask `aistudio` to discover existing business objects and supporting sources only in an explicitly entered new-workflow branch. Reuse them by default; do not create a helper unless the user separately and explicitly requests that named artifact.
- Do not invent schemas, fields, records, workflows, nodes, actions, tools, agents, routes, server state, or validation results.
- Complete the current `aistudio` app-intake decisions inside the product-facing proposal.
- Treat supplied codes and detailed initial requirements as proposal inputs, not approval.
- Stop when a required contract is unclear.

## Action Evidence and Scope Boundary

- Require factual existing-workflow support and a protected reference-app pattern for every prescribed action.
- Do not invent action codes, payloads, schemas, fields, APIs, operation support, or action behavior; use only the product-defined mapped code for each prescribed action after supported action creation.
- Do not add an action unless the user explicitly requests it and the same existing-workflow and reference-app evidence is confirmed.
- Do not add panels, person experiences, workspaces, communications, deletion, unrelated HCM writes, or generic framework actions.
- Proposal approval authorizes only the displayed current-flow behavior. Never execute a real business-data write during app creation, direct validation, or testing.
- If action support or its reference-app pattern is not found, report the action as unsupported. Do not create a workflow, helper, panel, or substitute action.

## Silent Current-Flow Action-Code Normalization

After supported action creation and before direct validation, edit only the newly created current-flow app file. For each unambiguously matched prescribed action, preserve its generated `id` and all other configuration, replace only its generated `appConfig.actions[].code` with the product-defined mapped code, and update exact `ora.Invoke("<generated-code>")` references in the same file.

Perform this normalization silently and as best effort. Skip an absent, duplicated, or unrecognized action or code and continue with all other matches. Do not stop the build, classify a skipped replacement as a failure, or expose any success, status, warning, limitation, or failure message about this internal step. Never apply it to an existing, reference, or uncertain-provenance artifact.

## Approval and Business Effects

Require one follow-up approval after presenting the complete product-facing proposal. The approval covers only the exact displayed resource set and selected behavior.

Confirm the visible behavior before adding, and include only effects allowed by the product contract:

- record creation, update, or deletion;
- draft or send communication;
- navigation to another app;
- target-agent invocation;
- remote fetch or save;
- force behavior or another external-state operation.

Do not add a second technical approval checkpoint after the complete proposal is approved. Keep generated resources local unless the user explicitly selects a supported remote operation. Never publish workflows through the CLI.

## Proposal and Success Check

Before creation, include all currently required `aistudio` intake items in one business-facing proposal. Use `Success check` for the user-visible proof scenario and translate it internally to the required validation scenario.

- Do not title pre-creation content `Validation` or `Validation checkpoint`.
- Keep the Success check strictly within selected scope.
- Do not mention panels, workspaces, communications, navigation, or business writes outside the selected product scope. Include only the prescribed actions and any separately explicit, supported action extension.
- Display the exact resource set to be created or materially modified.
- Do not show validation results or a validation-results menu before approved resources have been created or materially modified, unless a material current-flow MVP already exists.
- Include `Verification mode: Direct validation only for this MVP; automated tests are deferred until the user selects them after MVP validation.`
- Treat approval of the complete proposal as the user's explicit opt-out of automatic test sync for the starter path.

## Closed Validation Scope

Pass the exact files that were created or modified to `aistudio` for matching direct `validate-* --file` operations.

Never validate a directory, glob, sibling file, all artifacts near a selected file, rejected candidate, unselected discovery result, reference example, another app package, or unselected transitive dependency. Do not expand validation merely because files share a directory or product area.

## Validation-Only Starter Branch

After material creation or modification, run direct validation when supported. Until the user separately selects automated testing, do not:

- retrieve a test-sync plan;
- generate or synchronize tests;
- record or execute tests;
- run optimization sweeps;
- request test summaries.

After direct validation, offer automated tests as a separate product-facing choice. If selected, follow the current `aistudio` test instructions in a new branch.

## Response and Choice Safety

- Explain business intent before technical detail.
- Keep normal responses conversational and medium length; do not collapse stage returns into terse status lines.
- State result, business meaning, and reason for the next recommendation.
- Use contextual product-specific choice wording that preserves all required decision paths.
- Put technical protections in the preceding explanation, not the primary option labels.
- Do not mention post-creation action-code normalization or skipped replacements in user-facing responses.
- Present exactly one bold `Recommended` choice at each material gate.
- Include `Elaborate` immediately before `Stop` when meaningful extra explanation exists.
- Follow the product's first-person rule.

## Completion Check

Before concluding, verify that:

- the welcome appeared for every new-app intent, including requests containing codes;
- mandatory local workspace discovery completed before every environment lookup in every Codex mode, and suitable local artifacts remained the default for reuse and wiring;
- normal responses used display names and the required product choice paths;
- existing and uncertain-provenance resources remained unchanged;
- creation used the `aistudio`-resolved canonical layout and not a discovery directory;
- each new app code used its approved app-specific format, canonical display names remained unchanged, and person drill-down panels used non-draft workflow bindings;
- local collision preflight, when available, was read-only, limited to tokenized app codes, and did not affect existing artifacts;
- the user approved the exact created or modified resource set;
- every prescribed action had factual existing-workflow support, its product-defined mapped code, and a protected reference-app pattern or remained explicitly unsupported;
- every unambiguously identifiable prescribed action in a newly created app was silently normalized without changing its generated action ID, and unmatched codes did not block the flow;
- no unrequested action, panel, person experience, workspace, or workflow was added;
- no real business-data write ran during creation, direct validation, or testing;
- the Success check included only selected scope and no second technical checkpoint appeared;
- validation occurred only after material current-flow work;
- validation was limited to the files created in the guided flow;
- automated tests ran only after a separate post-validation choice;
- substantive post-validation product choices were offered;
- the base `aistudio` skill remained unchanged.
