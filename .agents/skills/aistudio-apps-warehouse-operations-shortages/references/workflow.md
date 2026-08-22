# Guided AI Studio App Workflow

Use this state machine for any product-specific AI Studio app wrapper. Read the product contract, display-name map, welcome contract, and choice requirements in the product `SKILL.md` before beginning.

## State 0: Route Intent

Apply these rules in order:

1. For intent to create, design, scaffold, or build a new app, always show the product welcome, even when the request includes workflow codes, business-object codes, filenames, artifact names, or detailed requirements.
2. For a broad or ambiguous request that may lead to new-app creation, show the welcome.
3. Skip the welcome only for a clearly narrow workflow-only, business-object-only, or existing-artifact inspection or validation request that does not create a new app.
4. For an existing-app change, confirm the narrow scope. If the change becomes a new app experience, show the welcome before discovery.
5. Treat supplied codes as discovery inputs, never as approval, proof of suitability, or permission to bypass a gate.

## Interaction Contract

At every user-facing gate:

- explain the decision in business language;
- say why it matters and what follows;
- never end a user-facing turn with a standalone direct question; render every required decision or missing input as a contextual numbered choice menu;
- give every choice a short, action-oriented label followed by one concise explanatory sentence directly below it; keep scope, rationale, outcomes, and exclusions out of the label, and include only the detail necessary to distinguish that choice in its sentence;
- for missing free-text input, use a Recommended `Provide ...` choice whose explanation states the required input, and treat a reply that provides that input as selecting that choice;
- present numbered choices;
- include exactly one bold option containing `Recommended`;
- include proceed, review/detail, revise/back, and stop choices when applicable;
- include `Elaborate` immediately before `Stop` when meaningful optional detail exists;
- use a product-defined choice invitation or required choice elements when present; otherwise end with `Choose one option to continue.`;
- wait for the user's selection.

Do not combine gates or silently advance because the request is detailed. Do not shorten, reorder, or replace a product-defined welcome response shape or product-defined menu with a generic alternative. Do not omit or replace required decision paths with generic alternatives. Use product display names in normal view. Keep `artifact`, `checkpoint`, `current-flow`, `side effect`, `handoff`, `validation wrapper`, `package layout`, `test-sync`, and similar technical language out of normal choice labels.

## State 1: Welcome and Functional Scope

Show the product Opening Welcome Contract exactly once for a new-app flow. Explain:

- the product decision or task in a paragraph;
- the recommended MVP and user journey;
- the complete-app possibilities;
- discovery and reuse;
- grounded data and first-load behavior;
- approval before creation;
- direct validation and optional later tests;
- any business effects that require separate selection.

Do not expose codes, filenames, paths, commands, schemas, or node details. Wait after the product welcome choices.

## State 1.5: Project Package Preflight

For a new-artifact flow, ask `aistudio` to determine only whether `app-pkg/` contains zero, one, or multiple app packages. Do this after functional scope selection and before artifact discovery, planning, generation, test sync, or creation.

- No app packages: record the supported legacy project-root layout and continue.
- Exactly one app package: record that package as the selected package and continue.
- Multiple app packages: present a contextual package-selection choice menu using the returned package names and wait.

Do not infer a package from prior turns, product similarity, discovery results, existing artifacts, or directory order.

## State 2: Complete Local Discovery

Workflow discovery is the first AI Studio operation after functional orientation, scope selection and package preflight. In every Codex execution mode, require `aistudio` to complete discovery in the resolved local workspace or local AI Studio project first for the product's canonical apps, workflows, and relevant local reference patterns. Do not discover or inspect business objects or other workflow helpers in this state. Require a local result of found, not found, or unavailable before any environment lookup. Search the environment only as a read-only fallback when no related local artifact is found, local discovery is unavailable, or the user explicitly asks for a local/environment comparison. When a suitable local artifact or pattern is found, keep it as the default for reuse and wiring and do not let an environment result silently replace it. Apply this mandatory local-first order to every other artifact type whenever a later state brings that type into scope.

Report only factual normal-view information:

- product display name;
- business description from the product contract or returned metadata;
- discovered source;
- allowed discovery status;

Use the product's exact mapping-column contract. Do not add fit, gap, suitability, readiness, score, confidence, coverage, or inferred-capability columns.

After local and, when needed, environment discovery, route each selected experience through State 3. Do not offer artifact creation unless State 3 records `Not found` for that experience.

## State 3: Reuse Decision

For each selected panel or experience, route the discovery result as follows:

- When one workflow is found, select it for reuse by default and present a contextual `Recommended` choice to continue with the discovered workflow. Wait for the user's selection. Do not offer workflow creation for that experience.
- When multiple candidates are found, present a contextual numbered selection menu using the discovered workflow display names. Do not offer workflow creation for that experience.
- When the result is `Not found`, explain that the workflow is unavailable and offer scope revision, stopping, or explicit creation of that missing workflow. Do not enter State 4 until the user selects creation.

Different panels may use different workflows. When every selected experience has a reused workflow and the user selects the recommended reuse path, proceed to State 5.

When the user selects a workflow for reuse:

- treat it as one protected dependency;
- explain its returned business purpose;
- do not inspect its internals by default;
- proceed toward app, summary, panel, and action planning.

Inspect reused workflow internals only for technical view or when exact evidence is necessary to resolve a requested capability.

## State 4: New Workflow Branch

Enter this branch only when State 3 records `Not found` for an experience and the user explicitly selects creation of that missing workflow, or when the user independently and explicitly requests a named new workflow. Do not enter because a workflow is judged unsuitable, reuse is rejected, or an experience is said to need a new workflow.

1. Ask `aistudio` to discover existing business objects and supporting capabilities for this explicitly requested workflow using the same mandatory local-first order.
2. Present returned options in business language and reuse the selected existing source by default. Do not create a business object, tool, agent, or other helper unless the user separately and explicitly requests that named artifact.
3. Confirm the workflow's business boundary, input, outcome, first-load or query role, and any business effects.
4. Add the new workflow display name to the exact app-proposal resource set.
5. Do not create it yet.
6. After proposal approval, ask `aistudio` to create it in the resolved layout.
7. Run the matching direct validation on the new file.
8. Return to the workflow-to-panel mapping and record the decision.

Do not invent business objects, tools, agents, schemas, nodes, actions, or boundaries. If the required source cannot be discovered and the user does not provide a confirmed source, stop the data-dependent branch.

## State 5: App, Summary, Panel, and Action Planning

Plan the app only after workflow decisions are clear for the selected scope.

When any planning input lacks a confirmed value, use the information-collection choice menu required by the Interaction Contract rather than a standalone question.

### App planning

Confirm the app's business outcome, user, external data source, first-load experience, query behavior, launch context, and selected scope.

### Summary planning

Define the existing summary or first-load area, the protected local patterns `aistudio` may inspect, the product-approved fallback, and the experiences excluded from that fallback. Do not invent configuration fields.

### Panel planning

Map every panel and drill-down experience to one selected reused or explicitly requested new workflow. Confirm first-load, expansion, row selection, navigation, query behavior, and visible evidence where applicable.

### Action planning

Separate:

- panel interactions;
- navigation;
- workflow-backed queries;
- recommendations or suggestions;
- candidate or evidence review;
- communication types and draft/send behavior;
- business-data writes or updates;
- target-agent or external-service invocation.

Require explicit selection of communication and business effects. Do not infer action payloads or implementation support.

## State 6: One App Proposal and Approval

Present one complete business-facing proposal that satisfies the current `aistudio` app-intake contract. Include only information relevant to the selected scope:

- business outcome and users;
- confirmed external data source;
- first-load experience and summary behavior;
- included panels and drill-downs;
- query behavior and user actions;
- communication and business effects when selected or when their omission must be confirmed;
- launch context;
- exact display-name set of new app files to create or materially modify, plus any separately and explicitly requested non-app artifacts;
- selected existing dependencies to reuse;
- known limitations;
- a short `Success check` limited to the selected scope;
- `Verification mode: Direct validation only for this MVP; automated tests are deferred until the user selects them after MVP validation.`

Do not title the Success check `Validation` or `Validation checkpoint`. Translate it internally to the validation scenario required by `aistudio`.

Offer contextual product-specific approval wording and wait. Approval authorizes only the exact displayed resource set and the stated Verification mode; it is an explicit opt-out of automatic test sync for the starter path. Do not expose a second technical checkpoint. If another resource becomes necessary, stop, revise the proposal, and obtain new approval.

## State 7: Confirm Resolved Creation Layout

Before creation, confirm the project-layout record produced by State 1.5. Do not run package discovery again.

- No app packages: use the supported legacy root `src/<artifact-type>` layout.
- Exactly one app package: use its recorded package-local source tree.
- Multiple app packages: use the package selected by the user in State 1.5.

If the project layout has changed or the selected package no longer resolves, stop and present the contextual package-selection choice menu again. Do not derive a destination from a discovered local artifact root.

## State 8: Create in the Resolved Layout

After approval, hand the exact approved resource set to `aistudio`.

For a standard new-app flow, that set contains only new app files. Do not hand off workflow, business-object, tool, agent, or other helper creation unless the user explicitly requested that named artifact and it appears in the approved resource set.

1. Let `aistudio` choose canonical destinations from the resolved layout.
2. In an app-package project, create in the selected package-local source tree.
3. In a project with no app packages, use the supported legacy root `src/<artifact-type>` destination.
4. Never derive a destination from a discovered resource's directory.
5. Never place a new file beside a discovered file merely because it was found there.
6. Never use a root `src` override in an app-package project.
7. Never run `init` unless the user explicitly requests initialization of a blank project.
8. Create or modify only approved current-flow resources, serially per file.
9. Stop if an unapproved resource becomes necessary.

Do not show a validation checkpoint or validation-results menu before at least one approved resource has been created or materially modified, or before a material current-flow MVP is already present.

## State 9: Closed Direct Validation

Hand the exact created or modified files list to `aistudio`. Run the matching direct `validate-* --file` operation once for each member when supported.

Never validate:

- a directory or glob;
- all files in a discovered directory;
- sibling resources;
- rejected or unselected candidates;
- reference examples;
- another app package;
- unselected transitive dependencies.

Use the Verification mode approved in State 6 as the explicit opt-out of automatic test sync. Do not retrieve test-sync plans, generate or synchronize tests, record tests, run tests, run optimization, or request test summaries.

## State 10: Validation Result and Continuation

After direct validation, report:

1. what was validated by display name;
2. the factual result;
3. what it means for the selected app experience;
4. why the recommended next choice follows.

If a newly created or modified resource fails validation, recommend fixing only that new current-flow resource. If every created or modified resource passes, state that the new foundation is ready and offer concrete product enhancements.

Offer automated tests as a separate choice: `Create and run automated tests for the new app.` If selected, enter a new branch governed by the current `aistudio` test instructions. The user may choose to finish without tests.

Continue guided choices until the user selects stop or explicitly asks to conclude.

## Technical View

Offer technical details after discovery, before creation, during failure handling, after validation, and whenever requested. Technical view may show a display name paired with its code, filename, path, command, implementation evidence, or raw validation information.

Never show an identifier without its display name when a mapping exists. Returning from technical view does not authorize mutation, remote access, testing, or movement to another gate.

## Final Build Brief

Provide the product's complete build brief only when the user selects stop or explicitly asks to conclude. Include the exact selected scope, resolved project, first-load and data source, created and reused resources by display name, validation manifest and outcome, business-effect boundary, automated-test status, remaining decisions, and next `aistudio` instruction.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
