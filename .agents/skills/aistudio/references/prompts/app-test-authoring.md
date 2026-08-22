# App Test Authoring

Use this reference after creating or materially editing an Agentic App. App tests validate the app panel contract, not only the backing workflow.

## When To Run App Test Sync

After a successful app create or material app edit, do not stop after writing the app file, validating the app, or syncing workflow tests. Unless the user explicitly opted out or asked only for planning, run app test sync when the app has at least one top-level agent container.

Run:

```text
node .agents/skills/aistudio/scripts/aistudio.js get-app-test-sync-plan --file <app-file>
```

Mode and scope selection matter. If the user asks to show, inspect, preview, display, or get the app test sync plan, run only `get-app-test-sync-plan --file <app-file>` and stop after explaining that read-only plan. Do not run backing workflow sync, `do-sync-app-tests`, app test generation, app test runs, or judge attachment for a preview request.

For an execution request, determine scope from the current user request before acting:

- **App-wide execution:** use this only when the user asks for the app itself, the complete app test sync plan, all panels, or all app tests. Complete every required backing workflow loop, materialize every listed app create or update action, run `do-sync-app-tests`, and finish with `get-app-test-final-summary --file <app-file>`.
- **Targeted workflow-and-panel execution:** use this when the user names one panel, one app test, or one backing workflow together with its panel. Complete only that backing workflow's sync loop and the matching app-panel action. Run only the matching app test with `run-app-test --test-file <target-app-test>`, attach only its judge result when needed, and present only the targeted workflow and panel outcome. Do not call `do-sync-app-tests` or `get-app-test-final-summary` for this scope.
- **Workflow-only execution:** when the user names only a workflow and does not request its app panel, follow `workflow-test-authoring.md` and do not run app commands.

The word `complete` does not widen an explicitly named workflow-and-panel request. For example, `complete the sync for Alpha Team Performance Review Planner and its panel` is targeted; `complete the sync for Alpha Team Performance Command Center` is app-wide.

Scope examples:

- `Run the complete app sync for Alpha Team Performance Command Center` is app-wide.
- `Regenerate Alpha Team Performance Review Planner and its panel test` is targeted.
- `Run the Performance Review Planner panel test` is targeted.
- `Run all panel tests` is app-wide.

In app-wide execution mode, an app plan that lists `Required backing workflow sync loops`, reports non-zero backing workflow missing or out-of-sync actions, or prints a `Required command` is an instruction to make the next tool call. In targeted execution mode, select only the matching backing-workflow and panel actions from that plan; unrelated actions remain outside the request and do not block targeted completion. Do not answer with a progress summary or pending counts for work inside the selected scope. Continue its action-driven loop until no selected executable action remains or a concrete blocker prevents progress.

If the sync plan returns only `NO_CONTAINERS`, stop and report that the app shell has no testable panels yet. Do not fabricate app tests for an empty app shell. App tests start once the app has a top-level agent container wired to a workflow.

## What App Tests Prove

Phase 1 app tests target `InitDisplay` for each top-level app panel.

They prove:

- the selected app panel resolves to the intended workflow agent
- the workflow has an `InitDisplay` app-stage route
- the debug request uses the app-stage input shape
- required path assertions execute for that app-stage route
- recordable workflow nodes can replay from stored data in file mode
- returned `oraInfoDisplay` widgets match the panel's stored widget contract
- malformed widget JSON is treated as a deterministic failure

They do not replace workflow tests. Workflow tests still cover workflow-level branches, Query/Summary app-stage paths, and boundary scenarios.

## Test Files

App tests are JSON files.

Legacy layout:

```text
test/apps/<app-code-folder>/<test-name>.json
```

App-package layout:

```text
app-pkg/<package>/tests/ai/self/<module-name>/applications/<app-code-folder>/<test-name>.json
```

The app code folder follows workflow test folder style: use the lowercased artifact code folder name and preserve underscores. Example:

```text
FABS_ANNUAL_TEAM_PERFORMANCE_DASHBOARD -> fabs_annual_team_performance_dashboard
```

There is no panel directory level. The panel segment is stored in JSON metadata and used in the test name, reports, and filters.

App test JSON must not depend on app or workflow source file paths, app versions, workflow versions, or runtime status. The stable identities are `app.appCode`, `panel.containerId` or `panel.panelId`, and `workflow.workflowCode`. File paths, current versions, runtime status, and app agent keys belong in command output and reports, not in the source-controlled test definition.

Generated app tests use the same model-agnostic metadata vocabulary as workflow tests:

```json
{
  "scenario": {
    "custom": false,
    "source": "sync-plan",
    "id": "APP_CODE:panel-container:InitDisplay",
    "kind": "app-panel",
    "intent": "Verify the panel InitDisplay response and widget contract.",
    "appStage": "InitDisplay"
  },
  "app": { "appCode": "APP_CODE" },
  "panel": {
    "containerId": "panel-container",
    "title": "Panel title",
    "pathSegment": "panel_title",
    "displayPromptHash": "..."
  },
  "workflow": { "workflowCode": "WORKFLOW_CODE" },
  "authoring": {
    "source": "model-authored",
    "createdAt": "...",
    "userPrompt": "What this test verifies"
  },
  "widgetAssertions": {
    "source": "panel-widget-list",
    "allowedLayoutIds": [],
    "allowedPatternIds": [],
    "requiredPatternIds": [],
    "forbiddenPatternIds": []
  }
}
```

Do not write obsolete top-level `scenarioKind` or `appStage`, `agent`, `authoring.createdBy`, panel-level widget lists, or `expectedWorkflowLayoutIds`. A custom test uses `scenario.custom: true`, `scenario.source: "user"`, and an optional `scenario.intent`; its test name is user-owned identity. Keep `scenario.appStage` equal to the app-stage value encoded by `input.parameters.appHint` or legacy `input.parameters.OraMessageHint`.

## Panel And Test Naming

Generated init display tests use:

```text
init_display_<panel_segment>
```

Panel segment precedence:

1. normalized panel title
2. normalized panel id
3. normalized container id

Normalize by trimming, lowercasing, replacing non-alphanumeric runs with `_`, collapsing repeated `_`, and trimming leading/trailing `_`.

If sibling panels collide, suffix every member of the collision group with `__<last-8-container-id-chars>`.

## Sync Loop

Before step 1, finish app and workflow authoring. Complete every pending node, edge, panel, agent-reference, prompt, input, and metadata change; validate every created or materially changed workflow and the app; then save or normalize each changed DRAFT once. Do not request an app or workflow test sync plan while authoring or repair commands are still in progress. Test plans must describe the final validated artifact definitions, not an intermediate graph.

1. Run `get-app-test-sync-plan --file <app-file>` to discover the app panels and referenced backing workflow files.
2. For app-wide execution, process every workflow listed under `Required backing workflow sync loops` or `Required app-related workflow coverage` sequentially in the app plan's order. For targeted workflow-and-panel execution, process only the explicitly named backing workflow and ignore unrelated workflow actions for this request. Never request plans, generate tests, record data, run tests, or judge results for two backing workflows concurrently. Within a workflow, issue at most one mutating generate, update, record, apply, or save command at a time; never start a second command for the same test or workflow artifact while the first is running. Complete each selected workflow through the single-action Sync Execution Contract in `workflow-test-authoring.md`: execute the single focused action, complete its required data work, validate that affected test deterministically, then immediately refresh with `get-workflow-test-sync-plan --recommended-batch-only true --format focused-json` and execute the next returned action without asking. Continue until the latest plan reports `finalSummaryAllowed: true` with no create or update action remaining; then run one final canonical configured-mode workflow suite without `--run-label` and attach its local judge results once without `--run-label`. Use the suite report rebuilt by attachment directly and do not run a separate full deterministic suite or confirmation suite. In app-wide scope, move to the next workflow only after that completion or after recording a concrete unrecoverable primary blocker for the current workflow. This means all selected executable actions are accounted for, not that every generated test passed. A completed failing test is reported and does not trigger repeated full-suite runs. Selected workflows listed under `Current backing workflow sync loops` or `Current app-related workflow coverage` are already current; do not rerun their suites to prove completion.

Passing or failing one test, completing one workflow phase, having pending selected workflow or app tests, substantial elapsed time, an estimate that little execution time or context remains, or useful partial progress do not complete the selected execution scope. For app-wide execution, return control only after the app final summary is available. For targeted workflow-and-panel execution, return control only after the selected workflow suite and selected app test are complete and their targeted reports are current. A concrete command, authentication, missing-file, or required-input failure may prevent the next selected action; the user may also explicitly ask to stop. Keep any host-required progress update concise and continue with the next tool call rather than turning it into a partial handoff.

When the app plan prints a required workflow command inside the selected scope, execute it instead of handing it to the user. If a selected backing workflow was newly created or materially changed, save and normalize it once before its test loop. Do not save it again for test generation, judging, report refresh, or a completed suite unless the workflow itself changed afterward. Record concrete unrecoverable workflow failures under that workflow with the failed scenario, observed fallback or command failure, dependent pending tests, and corrective action. Continue the next independent backing workflow only in app-wide scope.

Workflow app-stage input and test-data decisions belong to `workflow-test-authoring.md`. Preserve trigger envelopes, provide meaningful stage-specific semantic input, and do not treat an empty Query message as semantic Query coverage unless the test explicitly targets empty-message smoke behavior. Do not create workflow tests from app panel names, titles, widgets, or app test names; those contracts belong under `test/apps`. In app-wide scope, cover every required workflow and supported app-stage action rather than stopping after the first workflow, InitDisplay coverage, or workflows that already have app tests. In targeted scope, cover every required scenario for the selected workflow and only the matching panel action.

When a backing workflow app-stage route traverses a supported LOOP, keep the normal app-stage scenario and follow its `scenario.coverage.loopReplay` facet from `workflow-test-authoring.md`. Boundary replay belongs to the existing app-stage workflow test. A resolved PARALLEL route can contribute multiple LOOP boundaries to that one contract; do not create one app-stage test per branch. Generate only the dedicated single-iteration LOOP-internals scenario selected by the workflow sync plan; do not multiply LOOP tests across panels or app stages.

For the app panel test on that same InitDisplay route, preserve the normal `app-panel` scenario and its `appStage`; LOOP coverage remains a `scenario.coverage` facet. Use `boundary-output` only. During app recording, capture the complete output of every listed LOOP boundary, including boundaries from separate resolved PARALLEL branches, and exclude recordable descendants inside those LOOPs from app `testData.nodes`. Preserve complete under-budget raw LOOP evidence exactly. If a LOOP boundary or correlated source response exceeds its budget, use the emitted workflow-backed consistency group to compact every mutable artifact together without changing unrelated raw evidence. During file replay, require the deterministic `loopReplayBinding` check before judging widgets or semantic usefulness. Do not create an additional app-level single-iteration test; LOOP internals are covered by the workflow test selected by the workflow sync plan.
3. Before live app runtime execution for a newly created or materially changed app, save the app DRAFT with `do-save-app --file <app.app>`. Do not save every backing workflow as a routine app-sync preflight. Workflow saves belong to the workflow sync loop before workflow test generation/recording/runs when the workflow was newly created or materially changed, and to the workflow debug runner's safe `FAI-40300` recovery path. Do not overwrite a newer remote DRAFT without the normal version safety checks.
4. Materialize app `create` or `update` actions inside the selected scope after their selected backing workflow actions are complete. For every selected action whose `judgeAuthoringContext.path.semanticNodeCodes` is non-empty, use the model to author only `judge.minimumScore`, `judge.expectedOutcome`, and `judge.rubric` from the scenario intent, widget contract, ordered semantic nodes, terminal output owners, grounding nodes, and LOOP boundary nodes when present. Every new or changed rubric item must be an object with a stable lowercase kebab-case `id`, a concise business-facing `name`, and its `criterion`; never use numbered placeholders such as `Semantic criterion 1` or `Criterion 2`. Keep `judge.expectedOutcome` and `judge.rubric` logically equivalent. Before authoring them, make an internal inventory of mandatory final-output requirements from the scenario intent, user request, effective panel display prompt, widget contract, and explicit output contract. Treat contributing terminal semantic-node prompts and system prompts as supporting implementation context, not independent authority for adding mandatory final-output requirements. Map every mandatory requirement to both the expected outcome and exactly one rubric criterion; the rubric must neither weaken nor strengthen that requirement. Keep each rubric criterion atomic and independently judgeable. Do not combine grounding, unsupported-claim avoidance, evidence-gap handling, recommendation quality, or other distinct obligations into one criterion. Preserve conjunction and alternatives exactly; the rubric must preserve `and` versus `or`, so an outcome requiring `A and B` cannot be represented by a criterion allowing `A or B`. Preserve conditional requirements as conditional: require evidence gaps to be identified when supplied evidence has gaps, but do not require an explicit no-gap statement unless the user-facing contract explicitly requires a status statement even when none exist. Do not turn general internal prompt guidance into an unconditional final-output requirement. Before calling the generate or update command, verify internally that each rubric criterion has a required source and a matching expected-outcome requirement. Do not persist this authoring checklist in the test file. Apply this rule when creating or explicitly refreshing a judge contract; preserve an existing judge during unrelated updates. Pass that compact judge definition to `do-generate-app-test` or `do-update-app-test`. Do not author `judge.authoring`, scenario identity, app stage, panel identity, workflow identity, path assertions, or widget assertions merely to satisfy judge authoring; the CLI owns and injects that structural metadata and judge provenance. For LOOP boundary app tests, require the judged final response to remain grounded in the recorded complete LOOP output as well as the widget contract. Do not use the generic fallback judge when model authoring context is available. Rerun the app sync plan after materializing the selected actions to confirm those actions are current; unrelated app actions do not block targeted completion.

For **app-wide execution**, run `do-sync-app-tests --file <app-file>` only after the latest app plan has no remaining required backing workflow actions or continuations and no app create or update action remains. Accounted workflow test failures and deferred scenarios may remain in reports, but they do not replace this reconciliation check. A defensive `authoring-required` response means semantic actions were skipped: execute its listed `do-generate-app-test` or `do-update-app-test` continuations, refresh the plan, and continue without asking the user. `do-sync-app-tests` does not generate, record, or run workflow tests. When the resulting app suite has pending local judge requests, create all judge results and attach them once with `do-attach-app-test-judge-results`; judge attachment refreshes the app-scoped app suite and app-scoped consolidated report, so do not rerun the suite. After the app suite and any judge attachment are complete, run `get-app-test-final-summary --file <app-file>` exactly once. Compose the final response with your concise creation, update, or run summary first, then add a section named exactly `Validation and Insights` based on the command output. The command output is authoritative evidence, not mandatory prose: you may reformat and deduplicate it, but you must preserve app test counts, the app-scoped consolidated report, the app-scoped app suite report, and every backing workflow's suite report, `Metrics:`, and `Optimization:`. Never substitute a workspace-wide aggregate report for either app-scoped report unless the user explicitly requested workspace-wide or package-wide test results. Preserve compact issue and next-step guidance when present. All test and report details belong under `Validation and Insights`, not in the creation summary. Do not return the `do-sync-app-tests` marked block as the final user-facing answer. If `get-app-test-final-summary` fails, report that command failure and the exact command instead of writing a substitute validation summary.

For **targeted workflow-and-panel execution**, never call `do-sync-app-tests`. If the matching app test needs recording, run `do-record-app-test-data --test-file <target-app-test>` directly and complete any `needs-model-test-data` continuation with `do-apply-app-test-data`. Then run `run-app-test --test-file <target-app-test>` without overriding its configured evaluation mode or the default local judge provider. If the targeted run needs a local judge result, create only its matching result and attach it with `do-attach-app-test-judge-results --report-path <target-result.json> --result-path <target-judge-result.json> --cleanup-scratch true`. Both `run-app-test` and targeted judge attachment refresh the individual app report, app suite, and app-scoped consolidated report from existing results; they do not execute unrelated app or workflow tests. Do not run a confirmation app suite afterward.

For either scope, a recording result with `status: needs-model-test-data` is not complete: read its `testDataRequestPath`, copy `replayDataPayloadTemplate` exactly, and fill every node or LOOP artifact named by `consistencyGroups`. Treat each group as one atomic data decision so source collections, LOOP outputs, identifiers, counts, and parent-child relationships remain coherent. Preserve every `rawArtifactsToPreserve` entry exactly and never add artifact codes outside the template. When the result includes `temporaryTestDataPath`, write the prepared payload only to that exact CLI-managed file and pass it to `do-apply-app-test-data`; do not create another raw scratch file or put raw values in command arguments, logs, reports, or judge files. The apply command removes the managed operation after success or failure. When no managed path is returned, retain the existing `.debug/app-tests/<test-name>-test-data.json` flow. Never copy a backend-truncated `.....` preview into testData. In app-wide scope, if `do-sync-app-tests` returns `status: recording-required` with `pendingTestData`, execute every printed `do-record-app-test-data` command and rerun `do-sync-app-tests` after every listed test has ready and validated test data. In targeted scope, record and apply only the matching app test, then run that test directly. Do not rerun backing workflow suites, resave workflows, or return control merely because selected app test recording or model compaction is pending. Treat the selected flow as blocked only after an attempted app recording, compaction, or apply operation fails for a concrete reason.
5. For each selected app `create` action, run `do-generate-app-test --file <app-file> --panel-segment <panelSegment> --data-capture-policy record-later --definition @<judge-definition-file>`. Omit `--definition` only when the action has no semantic nodes and therefore needs no model-authored judge.
6. For each selected app `update` action, run `do-update-app-test --file <app-file> --test-file <testFile> --definition @<judge-definition-file>` when refreshing its semantic judge contract. An unrelated explicit edit may omit the judge and preserves the existing judge unchanged.

Apply the named-assertion identity rules from `workflow-test-authoring.md` to app output, path, node, widget, and semantic assertions. Human-facing reports show concise assertion names and keep machine IDs in structured test and result JSON. When a user refers to a visible assertion name, read the current app test, resolve that name within its assertion category plus panel, widget, or node context, preserve the matching ID, and update only that assertion. If the name remains ambiguous, ask which visible check the user means. Never replace an assertion ID merely because the user referenced its report name.
7. For each selected app `review` action, stop and report the review reason. Do not rename or overwrite custom tests automatically.
8. During manual app-test authoring or repair, or during targeted workflow-and-panel execution, validate only the affected test. A transient deterministic run may be used before the final configured-mode targeted run. This does not apply to an ordinary direct suite request or post-judge confirmation:

```text
node .agents/skills/aistudio/scripts/aistudio.js run-app-test --test-file <target-app-test> --data-source file --evaluation-mode deterministic
```

9. Repair app, workflow, test data, path assertions, or widget expectations based on deterministic failures.
10. Run a final app suite without overriding evaluation mode only for app-wide execution when `do-sync-app-tests` is not being used or failed before producing app reports. Never run this suite for targeted workflow-and-panel execution:

```text
node .agents/skills/aistudio/scripts/aistudio.js run-app-tests --app-code <APP_CODE>
```

11. For app-wide execution, if local app judge requests are produced, create every matching judge result JSON file and attach them once:

```text
node .agents/skills/aistudio/scripts/aistudio.js do-attach-app-test-judge-results --report-root-dir test-reports/apps --app-code <app-code> --cleanup-scratch true
```

Use app-package report roots when the CLI prints package-local paths.

For app-wide execution, run `get-app-test-final-summary --file <app-file>` after judge attachment and use that command output as evidence for the final response section named exactly `Validation and Insights`. For targeted workflow-and-panel execution, use the selected workflow's `get-workflow-test-final-summary --file <workflow-file>` result plus the targeted `run-app-test` result and individual app report; do not call the app-wide final-summary command. Judge attachment already refreshes parent reports in either scope. Do not rerun `do-sync-app-tests`, an app suite, or workflow suites merely to refresh status or summary text.

For a direct test request spanning multiple app packages, follow the local-judge package sequence in the Direct Suite Execution section of `workflow-test-authoring.md`. File mode changes only the data source. Do not override evaluation mode, and do not run a deterministic confirmation suite after app judge attachment.

## Pre-App-Sync Gate

This gate applies only to app-wide execution. Before running `do-sync-app-tests`, read the latest app sync plan and reconcile every backing workflow. For each workflow, retain its code, file, latest sync-plan state, and current suite report. A required workflow is accounted only when its latest workflow plan reports `finalSummaryAllowed: true` with no create or update action in `coverageExecution.nextActionIds` and its final suite is current for the unchanged workflow and test state. Current workflows remain current without another suite run. If any required workflow still has an action, unfinished continuation, or stale or missing final suite, resume that workflow's sequential loop; do not run app sync yet. A targeted workflow-and-panel request reconciles only the selected workflow and does not use this app-wide gate.

Do not treat `Ready panels` in the app sync plan as permission to run app sync while backing workflow actions remain missing or out of sync. `Ready panels` only means app panel test definitions can exist; it does not mean backing workflow coverage is complete. Do not treat existing pending app test files as progress that replaces workflow sync. Do not ask the user to run the printed workflow commands; execute them yourself unless blocked by authentication, remote conflict, destructive action approval, explicit synthetic-data approval, missing live data, invalid workflow or app runtime behavior, or another concrete blocker.

If `do-sync-app-tests` reports incomplete backing workflow sync, refresh the app plan, resume the first required workflow's authoritative focused action, validate only the affected test, and continue the sequential workflow loop. Do not try to clear the gate by repeatedly running workflow suites while create or update actions remain. A workflow suite becomes stale only when the workflow, a test definition, or test data changed after its last valid run; judge attachment refreshes reports and does not require another suite run. Do not run both `run-workflow-tests --workflow-code <workflow-code>` and `run-workflow-tests --app-file <app-file>` for the same gate, and never use an app-scoped workflow suite to clear it. Use `--app-file` only for an explicit app-scoped workflow-suite request or a user-requested multi-workflow model comparison.

## Final Response Checkpoint

Before answering the user after an app test flow, verify the final response includes a concise action summary followed by a section named exactly `Validation and Insights`. For app-wide execution, base that section on the latest `get-app-test-final-summary --file <app-file>` output. For targeted workflow-and-panel execution, base it on the selected workflow final summary plus the targeted app test result and individual report; include only the selected workflow and panel counts and do not enumerate unrelated panel tests or backing workflow suites. For app creation or app modification, the action summary may include app and workflow names, file paths, panels created, and implemented behavior. For existing-app test generation, summarize only the test refresh work. For run-only requests, summarize what was run and do not use creation language. Do not duplicate test counts, report links, `Metrics:`, `Optimization:`, or next steps outside `Validation and Insights`.

If a concrete primary blocker prevents app-suite creation or leaves no valid final-summary artifact, do not omit the outcome or fabricate report data. Use the latest app and workflow sync plans to state which workflows were completed, which primary scenario failed, the observed fallback or command failure, which dependent workflow or app tests remain pending, and one natural-language corrective action. Preserve any valid suite links, metrics, and optimization information that does exist for independent completed workflows.

## Reports

App test runs write the same three report formats as workflow tests:

```text
result.json
result.md
result.html
suite-result.json
suite-result.md
suite-result.html
```

App reports should foreground app-specific signal: widget assertions, panel contract, returned widgets, judge result, deterministic app checks, final output, and then workflow path diagnostics. Path assertions remain useful, but they are secondary in app reports.

After final backing workflow and app suites run for one app, use that app's scoped consolidated report:

```text
test-reports/apps/<app-code>/consolidated-suite-result.html
```

Use the app-scoped app suite for panel-test-only results:

```text
test-reports/apps/<app-code>/suite-result.html
```

For app-package layout, use the package-local app-scoped application suite and consolidated report paths printed by the CLI. Workspace-wide package reports are for explicit package-wide test requests only.

## Final Summary Rules

After app-wide `do-sync-app-tests`, an app-wide `run-app-tests`, or an app-package test run for one app, use `get-app-test-final-summary --file <app-file>` as the authoritative evidence source for the final section named exactly `Validation and Insights`. Compose the final app-facing response yourself, with creation, update, refresh, or run information first when applicable. You may reformat and deduplicate the command output, but do not drop app test counts, the app-scoped consolidated report, the app-scoped app suite report, or any backing workflow's suite report, `Metrics:`, or `Optimization:`. Do not include or substitute workspace-wide reports unless the user explicitly requested workspace-wide or package-wide results. Preserve compact issue and next-step guidance when present. Do not wrap the section in a fenced code block and do not hand assemble these facts from report JSON. Use `--format json` only for explicit structured diagnostics or detailed failure investigation.

After targeted workflow-and-panel execution, do not call `get-app-test-final-summary` because it is app-wide. Present the selected workflow's summary and suite report plus the targeted app test status and individual HTML report. Parent app suite and consolidated reports may be refreshed and linked when useful, but do not present their app-wide counts as the targeted execution count and do not list unrelated backing workflows or panel tests.

When app-wide app and workflow suites ran, `get-app-test-final-summary` must include the app-scoped app suite, the app-scoped consolidated report, and every backing workflow from the app sync plan. If it reports blockers or unavailable Metrics/Optimization, present those lines from the command output. Do not collapse multiple workflow sections into one blob. Do not turn bare directory paths (paths without a file extension, such as `test/apps/my_app` or `test/workflows/my_workflow`) into Markdown links. Only report files ending in `.html`, `.json`, or `.md` should be linked in final summaries.

Do not add a separate `Backing workflow suite reports` list when each workflow subsection already includes its own report link. Keep the app-scoped consolidated report and app-scoped app suite report at the app level; keep each workflow suite report inside that workflow's subsection.

Do not drop an `Optimization:` section because tests passed or because optimization was mentioned earlier. If the final-summary command includes a `To run it, reply:` prompt, preserve the action but make it workflow-specific when presenting a multi-workflow app summary. Replace ambiguous text such as `this workflow` with the workflow name from that subsection, for example `Run the model optimization sweep for Delta Team Calibration Intelligence`. If multiple backing workflows have optimization available, show separate next actions per workflow. If the user later asks only to run `the optimization sweep` and multiple workflows are eligible, ask which workflow unless the prior user prompt clearly named one. If the user asks to run it for all backing workflows, run sweeps one workflow at a time.

An app-wide final response is incomplete if it omits app test counts, the app-scoped consolidated or app-scoped app suite report links, or any backing workflow's suite report, `Metrics:`, or `Optimization:` from `Validation and Insights`. A targeted workflow-and-panel response is incomplete if it omits the selected workflow's test count and suite report or the selected app test's status and individual report. `appSuite.summaryText` is app-suite evidence only; it is not the authoritative final app-flow validation summary.

If the app suite passed, do not add unrelated caveats about git status, pre-existing untracked files, or sync-plan churn unless the CLI summary or report says user action is required. Report those only when they block the test run or require a follow-up decision.

If app tests run in hybrid mode and produce pending judge requests, create and attach the app judge results before the final user response unless a real blocker prevents judging. After attachment, use the refreshed app suite and consolidated report statuses. Do not quote the pre-attachment `needs-judge` status as the final result.

## Widget Expectations

Generation and sync derive widget expectations in this order:

1. nonempty panel or agent `displayWidgetList` or init display widget override
2. terminal workflow node `aiAppOutputSpecification.dataDisplay.layouts`
3. no widget contract

At run time, validation uses the stored `widgetAssertions.source`, `allowedLayoutIds`, `allowedPatternIds`, `requiredPatternIds`, and `forbiddenPatternIds` in the test JSON. It does not recompute expectations from the app or workflow during the run.

If both panel widget list and workflow terminal layouts are absent, the app test can still run but widget validation falls back to structural checks only.

## Tags

App test tags follow workflow test tag behavior.

- Creation: `do-generate-app-test --tags smoke,regression`
- Update add: `do-update-app-test --add-tags regression`
- Update remove: `do-update-app-test --remove-tags smoke`
- Update replace: `do-update-app-test --tags release-upgrade`

Tags are user-owned metadata. Preserve existing tags unless the user explicitly asks to change them.

## Recorded Data Masking

App tests use the same named profiles, deterministic replacement, LOOP handling, compaction boundary, and replay validation as workflow tests. Do not create app-specific masking logic. Inspect `existingProfiles` before creating a profile, and reuse the backing workflow's suitable profile instead of creating an app-specific or differently named duplicate. When the user names fields, treat that list as authoritative and do not add similarly named fields or semantic variants. When the user supplies only business categories, resolve them to the smallest applicable concrete field set. Only when no field scope is supplied may you infer sensitive fields from available schemas. Reference the same named profile in every generated app test definition before `do-record-app-test-data`. Do not broaden an existing profile unless the user explicitly asks to change masking scope.

For a request that creates, changes, or reuses masking, finish profile setup before requesting an app or backing-workflow sync plan that may load tests referencing it. Inspect masking context and `existingProfiles`, reuse or create the profile, and only then request the sync plan. Do not parallelize masking-profile setup with sync-plan commands. This sequencing rule does not apply to ordinary unmasked app sync.

A profile rule may be absent from one panel or scenario. Preserve the profile reference and continue; never fabricate marker fields or alter replay data merely to create a match. A selected field identifies sensitive source values; replacing those values consistently in downstream locations does not broaden the profile scope. Partial model-data application may update only the requested nodes while preserving already masked values elsewhere. Use `do-mask-test-data --profile <name> --dry-run true` only for existing raw app test data that has never been masked, and let the command validate deterministic file replay before accepting the change. If an applied profile changed, use a two-step refresh: first update only the profile reference so the CLI clears old replay data, then record fresh app test data separately. Never submit old test data in the profile-changing update or mask existing replacement values again. Preserve app, panel, scenario, widget, path, and authoring metadata; only explicitly selected invocation or replay data and related assertion or judge text may change.

## Command Reference

Use these commands for app tests:

- `get-app-test-context --file <app-file>`
- `get-app-test-sync-plan --file <app-file>`
- `list-app-tests --app-code <APP_CODE>`
- `do-generate-app-test --file <app-file> --panel-segment <segment> --data-capture-policy record-later`
- `do-update-app-test --file <app-file> --test-file <test-file>`
- `do-record-app-test-data --test-file <test-file>`
- `do-apply-app-test-data --test-file <test-file> --test-data @<file> --cleanup-scratch true` (use the recording result's exact `temporaryTestDataPath` when present)
- `get-test-data-masking-context --test-file <test-file>`
- `do-mask-test-data --test-file <test-file> --profile <profile-name> --cleanup-scratch true`
- `run-app-test --test-file <test-file>`
- `run-app-tests --app-code <APP_CODE>`
- `do-attach-app-test-judge-results --report-root-dir <app-report-root> --app-code <app-code> --cleanup-scratch true`

Do not run bare `run-app-tests` for a focused app request unless the user explicitly asks for all app tests in the workspace.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
