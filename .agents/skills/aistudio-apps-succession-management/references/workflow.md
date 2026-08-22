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
- the fixed MVP scope and action inventory;
- discovery and reuse;
- grounded data and first-load behavior;
- approval before creation;
- direct validation and optional later tests;
- the product-required MVP actions and their existing-workflow and reference-app evidence;
- any later optional business effects that require separate selection.

Do not expose codes, filenames, paths, commands, schemas, or node details. Wait after the product welcome choices.

## State 1.5: Project Package Preflight

For a new-artifact flow, ask `aistudio` to determine only whether `app-pkg/` contains zero, one, or multiple app packages. Do this after functional scope selection and before artifact discovery, planning, generation, test sync, or creation.

- No app packages: record the supported legacy project-root layout and continue.
- Exactly one app package: record that package as the selected package and continue.
- Multiple app packages: present a contextual package-selection choice menu using the returned package names and wait.

Do not infer a package from prior turns, product similarity, discovery results, existing artifacts, or directory order.

## State 1.6: Build Naming Token

For every new-app build, generate one local five-letter token matching `[A-Z]{5}` for the manager-facing app code only. Do not derive it from user identity, Git, system accounts, or external data. Apply the product contract's app-specific code rules: the manager-facing app code is tokenized, the person drill-down app code uses only its required `SP_` prefix and base code, and both display names remain canonical and unmodified.

## State 2: Complete Local Discovery

Workflow discovery is the first AI Studio operation after functional orientation, scope selection and package preflight. In every Codex execution mode, require `aistudio` to complete discovery in the resolved local workspace or local AI Studio project first for the product's canonical apps, workflows, action-support sources, and action-reference patterns. For each prescribed action, use the product's Action Code Map to inspect the matching action in related local reference apps and return its exact runtime code plus supported configuration and interaction pattern. Do not broadly discover or inspect business objects or other workflow helpers in this state; inspect only the minimum evidence needed to establish existing-workflow support and reference-app guidance. Require a local result of found, not found, or unavailable before any environment lookup. Search the environment only as a read-only fallback when no related local artifact or suitable local action reference exists, local discovery is unavailable, or the user explicitly asks for a local/environment comparison. When a suitable local artifact or pattern is found, keep it as the default for reuse and wiring and do not let an environment result silently replace it. Apply this mandatory local-first order to every other artifact type whenever a later state brings that type into scope.

Report only factual normal-view information:

- product display name;
- business description from the product contract or returned metadata;
- discovered source;
- allowed discovery status;

Use the product's exact mapping-column contract. Do not add fit, gap, suitability, readiness, score, confidence, coverage, or inferred-capability columns.

After local and, when needed, environment discovery, route each selected experience and prescribed action through State 3. Do not offer artifact creation because an experience, action, workflow, or reference pattern is `Not found`.

## State 3: Reuse Decision

For each selected panel, experience, or required MVP action capability, route the discovery result as follows:

- When one workflow or other support source is found, select it for reuse by default and present a contextual `Recommended` choice to continue with the discovered source. Wait for the user's selection. Do not offer workflow creation for that experience or capability.
- When multiple candidates are found, present a contextual numbered selection menu using the discovered display names and factual source descriptions. Do not offer workflow creation for that experience or capability.
- When the result is `Not found`, explain that the experience or action is unsupported and offer scope revision or stopping. Do not offer workflow creation.

Different panels and actions may use different support sources. Configure a prescribed action only when it has both existing-workflow support and a protected reference-app pattern. When every selected experience has a reused workflow and every prescribed action has that evidence, proceed to State 5.

When the user selects a workflow for reuse:

- treat it as one protected dependency;
- explain its returned business purpose;
- do not inspect its internals by default;
- proceed toward app, summary, panel, and action planning.

Inspect reused workflow internals only for technical view or when exact evidence is necessary to resolve a prescribed action. Treat each prescribed action as a capability; do not assume it is a standalone workflow.

## State 4: New Workflow Branch

Enter this branch only when the user independently and explicitly requests a named new workflow. Do not enter because an experience, action, workflow, or reference pattern is not found, is unsuitable, or is rejected.

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

Plan the app only after workflow decisions are clear for the fixed MVP scope. Do not add panels, person experiences, or workspaces beyond that scope.

When any planning input lacks a confirmed value, use the information-collection choice menu required by the Interaction Contract rather than a standalone question.

### App planning

Confirm the app's business outcome, user, external data source, first-load experience, query behavior, launch context, and selected scope.

### Summary planning

Define the existing summary or first-load area, the protected local patterns `aistudio` may inspect, the product-approved fallback, and the experiences excluded from that fallback. Do not invent configuration fields.

### Panel planning

Map every panel and drill-down experience to one selected reused or explicitly requested new workflow. Confirm first-load, expansion, row selection, navigation, query behavior, and visible evidence where applicable.

For every person drill-down panel, bind the selected workflow in published, non-draft mode. Configure `using draft` as false, or leave it unset only when the supported configuration defaults to the published workflow revision.

### Action planning

Plan and preserve exactly these MVP actions: Navigate to App, Row Action, Succession Candidates, Add Successor, View Successor Details, and View Successor Info.

For each action, record the confirmed existing workflow, exact Action Code Map value, and protected reference-app pattern. Use local reference apps first; use environment reference apps read-only only when no suitable local action pattern exists. Let the supported creation operation assign the action ID and temporary runtime code, then silently normalize that code in the newly created app file. Do not infer payloads, schemas, fields, APIs, or implementation support. Do not add an action unless the user explicitly requests it and the same evidence exists. Do not include deletion, unrelated writes, communications, generic framework actions, additional panels, or workspaces.

## State 5.5: Local Code Collision Preflight

After the exact new app resource set and base codes are resolved, form only the manager-facing app's tokenized code and ask `aistudio` to inspect the resolved local project for an existing app file with that code. If the local candidate exists, silently generate a new token and repeat the local check before State 6. Do not run environment collision discovery or collision discovery for the fixed person drill-down app code. If the local check fails or is unavailable, continue with the generated token. Do not render a user-facing success, failure, or status message for this preflight, and never overwrite an existing artifact.

## State 6: One App Proposal and Approval

Present one complete business-facing proposal that satisfies the current `aistudio` app-intake contract. Include only information relevant to the selected scope:

- business outcome and users;
- confirmed external data source;
- first-load experience and summary behavior;
- included panels and drill-downs;
- query behavior and the complete product-defined MVP action inventory;
- existing-workflow support, exact mapped action code, and protected reference-app pattern for every prescribed action;
- only explicitly requested and factually supported additional action behavior, when applicable;
- launch context;
- generated main-app build token and exact app-specific code and canonical display-name set of new app files to create or materially modify, plus any separately and explicitly requested non-app artifacts;
- selected existing dependencies to reuse;
- known limitations;
- a short `Success check` limited to the selected scope;
- `Verification mode: Direct validation only for this MVP; automated tests are deferred until the user selects them after MVP validation.`

Do not title the Success check `Validation` or `Validation checkpoint`. Translate it internally to the validation scenario required by `aistudio`.

Offer contextual product-specific approval wording and wait. Approval authorizes building only the exact displayed resource set, action behavior, and stated Verification mode; it does not authorize executing a real business-data write during creation, direct validation, or testing. It is an explicit opt-out of automatic test sync for the starter path. Do not expose a second technical checkpoint. If another resource becomes necessary, stop, revise the proposal, and obtain new approval.

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
9. Verify each returned app code follows its approved app-specific format, each display name remains canonical, and every person drill-down panel uses a published, non-draft workflow binding. Allow the supported action operation to persist generated action IDs and temporary codes.
10. Before direct validation, silently inspect each newly created current-flow app file that contains prescribed actions. Match each action by canonical display name, preserve its generated ID and configuration, replace its generated `appConfig.actions[].code` with the product's Action Code Map value, and update matching `ora.Invoke("<generated-code>")` references in that same file.
11. Apply the action-code rewrite as best effort. Skip absent, duplicated, or unrecognized matches, continue with every other action, and do not stop, fail, or emit a user-facing message about the rewrite or any skipped replacement.
12. Stop if an unapproved resource becomes necessary.

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

Do not add a separate validation failure, warning, or user-facing result for a post-creation action-code replacement that could not be applied. Continue with the supported direct validation of the resulting file.

## State 10: Validation Result and Continuation

After direct validation, report:

1. what was validated by display name;
2. the factual result;
3. what it means for the selected app experience;
4. why the recommended next choice follows.

If a newly created or modified resource fails validation, recommend fixing only that new current-flow resource. If every created or modified resource passes, state that the fixed MVP foundation is ready and offer refinement, automated-test, technical-view, and stopping choices. Do not offer panels, workspaces, communications, or unrequested actions as enhancements.

Offer automated tests as a separate choice: `Create and run automated tests for the new app.` If selected, enter a new branch governed by the current `aistudio` test instructions. The user may choose to finish without tests.

Continue guided choices until the user selects stop or explicitly asks to conclude.

## Technical View

Offer technical details after discovery, before creation, during failure handling, after validation, and whenever requested. Technical view may show a display name paired with its code, filename, path, command, implementation evidence, or raw validation information.

Never show an identifier without its display name when a mapping exists. Returning from technical view does not authorize mutation, remote access, testing, or movement to another gate.

## Final Build Brief

Provide the product's complete build brief only when the user selects stop or explicitly asks to conclude. Include the exact selected scope, resolved project, first-load and data source, complete prescribed action inventory, existing-workflow and reference-app evidence, created and reused resources by display name, validation manifest and outcome, automated-test status, remaining decisions, and next `aistudio` instruction.
