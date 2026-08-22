# AI Studio Handoff

## Purpose

This companion skill orchestrates the product-specific AI Studio Apps build experience. The existing `aistudio` skill performs all Oracle AI Studio artifact operations, including discovery, inspection, creation, modification, validation, CLI execution, local file writes, server fetch, save, and publish.

Do not invent AI Studio commands, file paths, schema fields, widget types, action payloads, business objects, tools, agents, workflow nodes, or summary-section implementation details. If implementation details are required, hand off to `aistudio`.

## Local-first rule

For every in-scope discovery or reference lookup, `aistudio` must complete discovery in the resolved local workspace or local AI Studio project first. This requirement applies in every Codex execution mode and to every artifact or reference type used by the active flow, including apps, workflows, business objects, tools, deeplinks, supporting artifacts, and reusable configuration or interaction patterns. It is a domain-specific source-order override of inherited mode-specific discovery behavior.

Before any environment lookup, return a local result of found, not found, or unavailable for the target. Search the environment only as a read-only fallback after no related local artifact is found or local discovery is unavailable, or when the user explicitly asks to compare with environment artifacts. When a suitable local artifact is found, use it as the default for reuse and wiring and do not let an environment result silently replace it.

Environment lookup is read-only. Do not fetch over local files, save, publish, force refresh, overwrite, or otherwise change local or server artifacts as part of discovery.

If `aistudio` requires explicit confirmation before environment or server lookup, return the confirmation requirement and factual scope to the wrapper; the wrapper must render it as a contextual numbered choice menu before that lookup.

## Authority and Availability

Use the current local `aistudio` skill as the sole technical authority for AI Studio discovery and artifact operations. Read its `SKILL.md` and the prompt references required for the selected operation at handoff time. Do not rely on a cached copy and never modify `aistudio`.

If `aistudio` or its project context is unavailable, return the unavailable requirement to the wrapper; the wrapper must render it as a contextual numbered choice menu that lets the user provide or install it.

The current base skill remains authoritative for commands, schemas, validation, package routing, and artifact operations. The local-first source-order rule in this reference overrides inherited mode-specific discovery ordering. For any other conflict, follow the base skill only where safe, stop before an unsafe or scope-expanding action, and report that the wrapper needs review.

## Project Preflight

Keep the working directory at the project root. Resolve project layout before discovery, planning, creation, or modification for a new-artifact flow.
- No app packages: use the supported legacy project-root layout.
- One app package: use its package-local layout.
- Multiple app packages: return the target-package requirement and available package names to the wrapper before discovery, planning, generation, test sync, creation, or modification; the wrapper must render the contextual numbered choice menu.

Do not infer a package or destination from prior turns, product similarity, discovery results, or directory order.

## Handoff Envelope

Provide only fields applicable to the current operation:

- operation: complete local discovery, inspection, creation, modification, direct validation, automated testing, remote discovery, remote fetch, remote save, or another supported lifecycle action;
- product scope and business outcome;
- primary user;
- selected app package, if required;
- artifact category and product display name;
- required new-resource code rule supplied by the product skill, when a code is required;
- internal technical identifier only when needed by `aistudio`;
- confirmed external data source;
- confirmed first-load, query, panel, navigation, and action behavior;
- communication type, audience, draft/send behavior, and confirmed support when selected;
- business-data effect and confirmation behavior when selected;
- exact approved current-flow resource set;
- protected existing resources;
- product canonical discovery targets;
- approved Success check translated to the `aistudio` validation scenario;
- exact validation manifest when validating;
- remote-operation status;
- automated-test status;
- user-approved Verification mode;
- whether technical view is active.

Use neutral intent. Do not guess commands, paths, schemas, app stages, nodes, payloads, or wiring.

## Discovery Handoff

For workflow discovery, ask `aistudio` to use the product's canonical artifact names and workflow codes. Request local workspace discovery first. If no related local workflow artifacts are found, ask `aistudio` to search the environment as a read-only fallback. Request names, discovered source, discovered status, and short descriptions. Do not discover or inspect business objects or other workflow helpers in this handoff. Do not ask `aistudio` to infer fit or gaps for existing artifacts.

For app or workspace discovery, ask `aistudio` to discover canonical app or workspace names in the local workspace first. If no related local app or workspace artifacts are found, ask `aistudio` to search the environment as a read-only fallback. Existing apps or workspaces may be used as references or dependencies only, not modified.

For app summary-section pattern discovery, ask `aistudio` to inspect related existing apps locally first. If no related local app summary reference is found, ask `aistudio` to inspect environment apps as a read-only fallback. Use discovered apps as references only. Do not modify existing apps.

Only in an explicitly entered new-workflow branch, ask `aistudio` to discover existing business objects first, using the same local-first discovery order. Reuse the selected existing business object or helper by default. Do not create a business object, tool, agent, or other helper unless the user separately and explicitly requests that named artifact.

Apply the same mandatory local-first order whenever the active flow later requires discovery of a tool, deeplink, supporting artifact, or any other artifact or reference type. Scope rules may defer a category until it is relevant, but they never permit environment-first discovery.

For a selected reused workflow, stop at workflow-level evidence. Inspect internals only when technical view is active or exact evidence is necessary for a requested capability.

## New-Workflow Handoff

When the product wrapper enters a new-workflow branch after a `Not found` result and the user's explicit creation selection, or after the user independently and explicitly requests a named new workflow, ask `aistudio` to discover existing business objects and supporting sources. Return business descriptions and factual support information. Reuse the selected existing source by default; do not create any helper unless the user separately and explicitly requests that named artifact.

After the user approves the complete app proposal, create the approved workflow through the supported `aistudio` operation, validate that exact new file, and return it to the wrapper for workflow-to-panel mapping.

## App Proposal Translation

Before creating an app or app-backed workflow, satisfy the current `aistudio` pre-build contract using the approved product-facing proposal:

- business outcome and user;
- external data source;
- first-load and summary behavior;
- query behavior;
- panel and drill-down behavior;
- priority actions;
- communication scope;
- business effects;
- launch context;
- exact resource set;
- Success check translated to the validation scenario.
- user-approved Verification mode: direct validation only for this MVP; automated tests are deferred until separately selected after MVP validation.

Treat the user's follow-up approval of this complete proposal, including Verification mode, as the required confirmation turn and explicit opt-out of automatic test sync for the starter path. Do not expose or request a second technical checkpoint. If a required decision is absent, return the unresolved business input requirement, factual options, and constraints to the wrapper, not a user-facing question; the wrapper must render the contextual numbered choice menu.

### Summary or First-Load Handoff Example

Use neutral prose rather than guessed commands:

```text
Operation: inspect and configure the current app's summary or first-load experience
Scope: the approved current-flow app
Local reference discovery: inspect related apps locally first
Protection: use discovered apps as references only; do not modify them
Environment fallback: inspect environment apps read-only only when no related local reference is found
Fallback: apply only the product-approved contributors and exclusions to the current-flow app
Implementation: use only the summary mechanism supported by the current aistudio contract
```

Do not expose the technical envelope in normal conversation. Translate it to the product's summary behavior and next business decision.

## Creation and Placement

For each approved new resource, use the following rules.

For a standard new-app handoff, the only approved new resources are app files. Do not issue a workflow, business-object, tool, agent, or other helper creation operation unless that named artifact was separately and explicitly requested and appears in the approved resource set.

1. Use the current `aistudio` supported creation operation.
2. Let `aistudio` choose the canonical destination from the resolved project layout.
3. In a legacy project with no app packages, use the supported root `src/<artifact-type>` destination.
4. In an app-package project, use the confirmed package and its package-local source tree.
5. Never use the directory containing a discovered resource as the destination.
6. Never pass a root `src` override in an app-package project.
7. Never run `init` as a prerequisite in an existing project.
8. Before mutation, return and verify the proposed artifact code follows the product-supplied rule whenever a code is required; never derive it from an existing discovery identifier.
9. Apply mutations serially and only to the exact approved resource set.
10. Return the created artifact code and verify it follows the product-supplied rule whenever a code is required.
11. Stop and return for revised approval if another resource becomes necessary.

Treat discovered resources and resources with unclear provenance as protected dependencies. Do not rename, patch, overwrite, recreate, re-scaffold, delete, save over, force-fetch, or otherwise modify them.

## Closed Direct Validation Handoff

The wrapper supplies an explicit list of newly created or modified files.

Accept only this explicit file list for validation. Run the matching direct `validate-* --file` operation for each listed file when supported.

Do not validate directories, globs, siblings, all artifacts near a selected file, rejected or unselected candidates, reference examples, other app packages, or unselected transitive dependencies.

## Validation-Only Starter Policy

For every starter-path creation or material-modification handoff, include this exact field:

`User-approved Verification mode: Direct validation only for this MVP; do not sync, generate, record, or run automated tests until the user selects the separate post-MVP test option.`

Treat this field as the explicit user opt-out of automatic test sync. After material creation or modification, run direct validation only.

Do not retrieve test-sync plans, generate tests, synchronize tests, record tests, execute tests, run optimization, or request test summaries. After direct validation, return the factual result to the wrapper.

Automated testing becomes available only when the user selects the separate product choice to create and run tests. Then follow the current `aistudio` test instructions as a new branch.

## Return Control

Return after each operation with:

- operation outcome;
- affected product display names;
- factual discovery scope evidence when applicable;
- created location class, such as legacy project or selected app package;
- exact files directly validated and their results when validation ran;
- unresolved decisions, unsupported behavior, or failures;
- whether the user-approved Verification mode was applied, and whether automated tests were later selected.

Return factual outcomes only. Do not render user-facing approval, validation-recovery, or post-MVP choices.

In normal view, omit codes, filenames, paths, commands, internal IDs, and raw payloads. In technical view, pair every known identifier with its display name.

Do not label pre-creation output as validation and do not return a validation-results menu before material current-flow creation or modification. Return control to the wrapper so it can explain the business meaning, recommend the next choice, and wait.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
