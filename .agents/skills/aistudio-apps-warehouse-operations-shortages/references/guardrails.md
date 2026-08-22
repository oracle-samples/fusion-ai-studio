# AI Studio Wrapper Guardrails

## Product Boundary

Keep personas, outcomes, terminology, experience hierarchy, summary content, canonical display names, technical identifiers, naming prefixes, business rules, risks, welcome wording, choice wording, and post-build options in the product `SKILL.md`. Keep this file free of product-specific codes and names.

## Current AI Studio Authority

Read the current local `aistudio` skill and the operation-specific references it requires immediately before each handoff. Treat its package routing, supported commands, artifact contracts, app intake, creation, and direct validation rules as authoritative. The mandatory local-first source-order rule below is a domain override of inherited mode-specific discovery ordering. Never use a cached contract and never modify the base skill.

If the current `aistudio` contract conflicts with the wrapper outside that deliberate source-order override, stop before an unsafe action and report the incompatibility. Do not invent a workaround.

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

Environment discovery must be read-only. Do not fetch over local files, save, publish, force refresh, overwrite, or otherwise change local or server artifacts as part of discovery. Apply mandatory local-first discovery to every artifact or reference lookup used by the active flow, including workflows, apps/workspaces, business objects, tools, deeplinks, supporting artifacts, summary-section patterns, and reusable configuration or interaction patterns. Scope rules may defer business-object or supporting-artifact discovery until an explicitly entered new-workflow branch, but they never permit environment-first discovery.

## Workflow Reuse Boundary

Reuse a selected existing workflow as one complete dependency. Do not inspect its business objects, tools, agents, nodes, action configuration, or other internals unless technical view is active, exact evidence is needed for a requested capability, or a new workflow is being created.

Do not modify, replace, copy, or recreate a reused workflow. Reused workflows are outside the direct-validation scope; offer only reusable-experience selection, technical details, or stopping. When a workflow is found, do not offer workflow creation for that experience. Enter a new-workflow branch only after discovery returns `Not found` and the user explicitly selects creation of that missing workflow, or when the user independently and explicitly requests a named new workflow.

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

## Data Grounding and Intake

- Confirm the real external data source for every data-dependent app or workflow.
- Do not treat app context, user context, attachments, prompts, sample values, or invented records as operational data.
- Ask `aistudio` to discover existing business objects and supporting sources only in an explicitly entered new-workflow branch. Reuse them by default; do not create a helper unless the user separately and explicitly requests that named artifact.
- Do not invent schemas, fields, records, workflows, nodes, actions, tools, agents, routes, server state, or validation results.
- Complete the current `aistudio` app-intake decisions inside the product-facing proposal.
- Treat supplied codes and detailed initial requirements as proposal inputs, not approval.
- Stop when a required contract is unclear.

## Approval and Business Effects

Require one follow-up approval after presenting the complete product-facing proposal. The approval covers only the exact displayed resource set and selected behavior.

Confirm the visible behavior before adding:

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
- Do not mention unselected optional panels, suggestions, communications, navigation, or business writes.
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
- the user approved the exact created or modified resource set;
- the Success check included only selected scope and no second technical checkpoint appeared;
- validation occurred only after material current-flow work;
- validation was limited to the files created in the guided flow;
- automated tests ran only after a separate post-validation choice;
- substantive post-validation product choices were offered;
- the base `aistudio` skill remained unchanged.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
