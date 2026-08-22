# Agentic App Ingestion

Use this reference before starting a new Agentic App or a material app redesign. The goal is to ask the fewest questions needed to avoid building the wrong artifact.

## Intake Principles

- First determine whether the user wants a `.app` artifact, an app-backed workflow, or both.
- Understand what the user is trying to build and which data sources or APIs could support that experience before asking follow-ups or implementing.
- Ask targeted questions only when the answer changes the app structure, backing workflow contract, data/API selection, generated actions, generated communications, or external side effects.
- When details are missing, offer reasonable choices based on the requested app, confirmed data sources, available APIs/tools, and relevant samples before asking the user to decide.
- Prefer concrete assumptions for low-risk choices such as labels, initial placeholder wording, and simple layout defaults.
- When the app needs workflow agents, inspect existing local workflows before asking the user to name agents.
- Do not ask the user for internal ids, action codes, panel discriminator names, generated workflow node ids, or schema-only fields.
- For any app or workflow create/edit request that displays, ranks, summarizes, analyzes, searches, filters, recommends from, or acts on records, documents, metrics, or enterprise knowledge, identify and confirm the external data source before changing the app, backing workflow, prompts, or workflow tests.
- If the likely data source is a Business Object and the user has not named a confirmed BO, search for candidate BOs before asking the user to provide one. Do not skip discovery just because the user used business-domain language instead of artifact names.
- Treat a confirmed Business Object, API, tool, or workflow as only one resolved intake item. It answers what data source to use; it does not answer the app goal, first-load experience, query behavior, actions, communications, side effects, launch context, or validation scenario.
- Treat prior suggestions as proposals, not approval. A later user response that confirms one item, such as "ok use this BO", confirms only that item unless the user explicitly says to use the rest of the proposed scope.
- Treat app context, user context, runtime context, attachments, and the user prompt as request context only. They do not satisfy the app's data-source requirement unless the user explicitly says the app is only for manually supplied or uploaded data.
- Before creating or materially editing app-backed workflows, confirm the action and communication scope with the user. Offer reasonable options, including omitting actions or communications for now, but do not build those paths before the user confirms the intended behavior.

## Questions To Resolve Before Building

Ask these when they are not already clear from the request or current files:

1. What business outcome should the app help the user decide or do?
2. Who is the primary user, and what decision or repeated workflow do they handle?
3. What data, records, documents, or systems should the app use?
4. Which panels or views are essential on first load?
5. Which existing workflow agents should power those panels, or should local workflows be created for them?
6. What should the app do when the user asks a free-form question?
7. Should the app produce actionable insights, communication suggestions, generated artifacts, or app actions?
8. If the app should produce priority actions, which important next steps can be inferred from the app goal and available data/API capabilities, and how should they be ranked and presented?
9. If the app should produce communications, which communication types can be reasonably suggested from the app goal, target audience, and available data/API capabilities?
10. Which actions have side effects, require confirmation, or need a specific target app/system?
11. What app context or input is available at launch, if any?
12. What validation or sample scenario should prove the app is working?

Before building, explicitly resolve this list and present the structured pre-build checkpoint for user confirmation. Each answer must come from the user's request, existing app/workflow files, confirmed data/API capabilities, or a clearly stated low-risk assumption. If the user provides many details, use them to fill the checkpoint, but do not treat the detailed request itself as confirmation to create artifacts. If the user only confirms a BO or other data source, continue intake for the unresolved questions instead of creating artifacts.

Do not ask all twelve questions verbatim when a compact follow-up will do. Group the unresolved structural decisions and include recommended choices, but do not put the checkpoint in one dense paragraph. Use short section headers and bullets so the user can scan each assumption and decide what to change.

The minimum pre-build checkpoint for a new app or app-backed workflow is:

- Confirmed business outcome and primary user.
- Confirmed external data source.
- Confirmed first-load panels or views.
- Confirmed free-form query behavior.
- Confirmed priority-action scope, or explicit decision to omit actions for now.
- Confirmed communication scope, or explicit decision to omit communications for now.
- Confirmed side-effect handling for any action or communication that writes, sends, updates, navigates, or invokes another agent.
- Confirmed launch context or statement that no launch context is required.
- Confirmed validation scenario.

## Confirmation Rules

Use these rules when interpreting the user's replies during ingestion.

- A user reply confirms only the specific item it names or directly accepts.
- A detailed build request that names BOs, workflows, guardrails, user questions, actions, communication behavior, launch context, or validation scenarios pre-fills the checkpoint; it does not replace the checkpoint or authorize artifact creation.
- A user must confirm after seeing the structured checkpoint. The original request, even if detailed, is not the confirmation turn.
- A reply like "ok use that BO", "use CX_FUSIONCLAW_ACCOUNT_BOSS_EXTRACTION", or "that data source is fine" confirms only the data source. Continue asking for any unresolved checkpoint items.
- A reply like "ok", "sounds good", or "go ahead" confirms the full checkpoint only when the immediately preceding assistant message explicitly presented the complete checkpoint and asked the user to confirm all of it.
- A reply like "build it", "create it", or "go ahead" in the initial request means the user wants an app, but still does not skip the pre-build checkpoint. Show the checkpoint first and wait for the next confirmation.
- If the assistant previously suggested default panels, query behavior, no actions, no communications, no launch context, or a validation scenario, those remain unconfirmed until the user explicitly accepts those defaults or confirms the full checkpoint.
- If a user response resolves only part of the checkpoint, acknowledge that item, list the remaining unresolved items, offer recommended choices, and stop for confirmation.
- Do not create local app files, backing workflows, prompts, tests, or validation artifacts in the same turn where you ask the checkpoint question. Wait for the user's confirmation first.
- Do not create local app files, backing workflows, prompts, tests, or validation artifacts in the same turn as the first structured checkpoint, even if the checkpoint is fully populated from the user's detailed request. Wait for the user's explicit confirmation after the checkpoint.
- Do not describe skipped intake as "local only" or "draft only"; local artifact creation is still building and requires checkpoint confirmation.

Before building a new app or app-backed workflow, always send a compact, structured checkpoint message and wait for explicit confirmation. Use this shape:

```
I can use `<confirmed source>`.

Before I build, please review these assumptions:

Data source
- `<confirmed source and what it supplies>`
- `<which requested behaviors this source satisfies>`
- `<any requested behavior not covered by the provided sources, and the extra source/API search or user question needed>`

App goal and user
- `<business outcome>`
- `<primary user>`

First-load experience
- `<recommended panels/views>`
- `<what data InitDisplay retrieves and how the LLM/AGENT reasons over it, or the user question needed if this is unclear>`

Query behavior
- `<how free-form questions should work>`

Priority actions
- `<recommended important actions and the API/tool/workflow/nav support for each>`
- `<only say omit for now if no meaningful or supportable actions were found after checking related APIs/tools/workflows>`

Communications
- `<recommended communication types and the send/draft/template/agent support for each>`
- `<only say omit for now if no meaningful or supportable communications were found after checking related APIs/tools/workflows>`

Side effects
- `<writes/sends/updates/navigation/agent invocation and confirmation behavior>`

Launch context
- `<required app context, or no launch context required>`
- `<if required, the exact context fields and why they are needed>`

Validation
- `<scenario that proves the app works>`

Do you want any changes, or should I continue with this scope?
```

Keep the checkpoint concise, but preserve the headings. If an item is genuinely not applicable, show it with "omit for now" or "not required" rather than hiding it.

When launch context is required, identify the smallest fields needed for routing, filtering, ids, or personalization. Do not assume raw app context or user context should be passed into an `LLM` or `AGENT` prompt.

When preparing the checkpoint, flag any requested behavior that the provided BOs do not appear to support. Do not proceed until the missing source is found, the user provides it, or the user confirms that behavior should be removed.

`InitDisplay` is an essential part of the app and cannot be left for later. Before building, identify what data the first-load display will retrieve and how an `LLM` or `AGENT` node will reason over that data to produce a useful startup result. If you cannot determine a real data-backed first-load behavior from the confirmed sources, ask the user what `InitDisplay` should do before creating artifacts.

## Data Source Confirmation

Use this for new apps and edits to existing apps or app-backed workflows.

- If the request needs data to complete, first inspect the current app/workflow and available local artifacts for data-producing sources.
- Data-producing sources include confirmed Business Objects, BO Function nodes, Tool nodes, External REST nodes, RAG Document Tool nodes, Vector DB Reader nodes, Document Processor nodes, connector/MCP-backed tools, or another workflow explicitly responsible for retrieving data.
- When the request appears to depend on enterprise records and no confirmed source is already present, search for matching Business Objects and related data tools/APIs before deciding the data source is missing.
- If the first BO search does not find a clear fit, automatically expand the search before stopping. Try broader and adjacent terms from the user's requested functionality, such as singular/plural names, synonyms, parent or child record types, related business processes, product/module terms, and verbs implied by the app goal. For example, an opportunity prioritization app may require searches beyond "opportunity" to related sales, account, lead, revenue, forecast, activity, recommendation, or engagement concepts.
- When expanded search returns partial or ambiguous candidates, describe the best options in terms of the app functionality they could support and ask the user to confirm one. Do not select a BO silently.
- If expanded BO/data-source search still finds no fit, report that no matching source was found, summarize the concepts searched at a high level, and ask the user to provide a BO/schema/API, approve a different external source, or change the requested functionality.
- If one or more candidate sources exist, describe each source in terms of the user's requested functionality and ask the user to choose or confirm the source before modifying artifacts.
- Treat user-provided BOs, APIs, tools, or workflows as candidates for the requested behavior, not automatic proof that every requirement is covered.
- Map the requested app behavior to confirmed data sources before building: first-load display, query answers, eligibility/rules, balances/counts, overlaps/history, actions, communications, and validation scenario. Only include categories that apply to the request.
- For first-load display, confirm the exact data source for `InitDisplay`. A prompt-only startup panel with no retrieved data is not a data-backed first-load experience.
- If the provided BOs or APIs do not satisfy any requested behavior, search for additional BOs/APIs/tools/workflows that could fill the gap. If no fit is found, ask the user for the missing source or ask whether to remove that behavior from scope.
- Do not write prompts that imply missing data will come from provided BOs when those BOs have not been confirmed to expose the needed fields or operations.
- If no candidate source exists, say that no available data source can satisfy the request with the current information and ask the user to provide/confirm a source.
- After the user confirms a source, return to the pre-build checkpoint and resolve any remaining app-structure, action, communication, launch-context, and validation questions before creating or editing artifacts.
- Before recommending action or communication scope, inspect related APIs, tools, connector-backed operations, BO functions, External REST nodes, MCP-backed tools, reusable workflows, and nearby Business Objects that could support those suggestions.
- Expand action/API discovery beyond the primary display data source. Search adjacent operations using verbs and nouns implied by the app goal, such as create, update, assign, schedule, request, approve, escalate, notify, send, draft, note, task, meeting, follow-up, recommendation, feedback, goal, document, profile, history, or owner.
- For communication discovery, look for send/draft email tools, notification APIs, document/template generation, conversation or activity APIs, target agents, and workflow actions that can create a message, brief, note, summary, or artifact.
- Do not treat built-in expressions, app context, user context, runtime context, attachments, or the user prompt as data sources.
- Do not create placeholder workflows, context-only fallbacks, fake tests, or prompts that assume the missing data will appear later.

## Action And Communication Suggestions

Use this before building app-backed workflows, app action wiring, communication paths, or tests.

- Do not default to omitting priority actions or communications. First make a good-faith search for related APIs, tools, BO functions, reusable workflows, target agents, navigation targets, and templates that could support useful suggestions.
- Propose 2-5 reasonable priority actions when the app's purpose and data/API surface imply important user next steps.
- Priority actions must be important and actionable: tied to a real retrieved record or condition, framed as a user decision or follow-up, and supported by confirmed data plus an available app action, workflow, BO/API operation, navigation target, or agent command.
- Rank suggested actions by urgency, business impact, risk, or time sensitivity when the data supports it.
- For each suggested action, state what data identifies it and what action/API/workflow would execute or support it.
- If no write/update operation is confirmed, still consider useful read-only or low-side-effect actions such as opening a relevant record, showing supporting evidence, invoking a target agent, drafting a task payload for review, generating a summary, or preparing a recommendation for user approval.
- Propose communication types when the app's purpose implies outreach or generated content, such as customer email, meeting brief, follow-up note, escalation summary, executive summary, or generated document.
- For each suggested communication type, state the likely audience, the data source, whether a template is needed, and whether a send/draft API or target agent is required.
- If a suggested action or communication needs an API that is not available or not confirmed, present it as a candidate dependency, not as buildable behavior.
- Recommend omitting priority actions or communications only when no meaningful or supportable option can be inferred after related API/tool/workflow discovery. If omitting, say what you checked and why no action or communication should be included yet.
- Before creating or editing workflow paths for `InitActions`, `InitCommunications`, `FillParameters`, `SendCommunication`, or action/communication-specific `Query` behavior, ask the user to confirm which suggested actions and communication types to include, which to omit, and which require side-effect confirmation.
- If the user has not confirmed action or communication behavior yet, stop before building the app-backed workflow and ask one compact follow-up that includes your recommended choices and an option to omit actions or communications for now.

## Default Shape When Details Are Sparse

When the user wants a new app but gives limited direction:

- Build a focused decision-support app with one or two agent panels rather than many generic panels.
- Prefer a scannable layout with startup widgets, priority actions, and a direct ask/query path.
- Use existing compatible local workflows when present.
- If no suitable workflow exists and the app has a confirmed external data source, create the minimum local workflow needed for the primary panel and make it app-compatible.
- If the app is about business records, documents, metrics, or enterprise knowledge and the external data source is not confirmed, stop before creating or editing artifacts and ask which source to use.
- Leave `queryAgent`, `summary.agentCode`, and `subtitleAgentCode` unset unless the user explicitly asks for specialized app-level roles.
- Add communications, templates, and actions only when the user asks for generated outbound content, document generation, or interactivity, or after the user approves suggested priority actions or communication types.

## When To Stop And Ask

Stop for one targeted follow-up when:

- Multiple workflow agents are plausible and wiring the wrong one would change behavior.
- The user wants priority actions, but after offering reasonable suggestions there is still no confirmed rule for how they should be identified, ranked, or presented.
- The user wants communications, but after offering reasonable suggestions there is still no confirmed communication type, audience, data source, or delivery/draft behavior.
- A new app or app-backed workflow is being built and the user has not confirmed whether to include priority actions, generated communications, both, or neither.
- A user has confirmed the BO/data source but one or more minimum pre-build checkpoint items are still unresolved.
- The latest user reply confirms only one checkpoint item and does not explicitly confirm the remaining proposed defaults.
- The user provided a detailed build request, but has not yet confirmed the structured pre-build checkpoint in a follow-up reply.
- The action has external side effects and the target, payload, or confirmation expectation is unclear.
- The app depends on servlet-provided production bootstrap data and servlet readiness has not been confirmed.
- Required data sources are missing, ambiguous, or cannot be represented by the available local artifacts.
- Multiple data sources could satisfy the request and the user has not chosen one.
- Business Object discovery/search or another required data-source discovery mechanism is unavailable.
- The only apparent data source is app context, user context, runtime context, attachments, or the user prompt, and the user did not explicitly request a manually supplied-data app.
- The user asks to reuse server state but local and remote versions conflict.

## Output Expectations

After intake, proceed with implementation only after the minimum pre-build checkpoint is resolved and the user has explicitly confirmed the structured checkpoint in a follow-up reply. This applies even when the user's original request already named the BOs, workflow, guardrails, user question, actions, communications, launch context, and validation scenario. State assumptions briefly, then create or modify the `.app` and any required app-backed workflows using the CLI commands described in the app and workflow prompt references.

If a confirmed data source is blocking, do not create an app shell, backing workflow, tests, prompt-only behavior, or context-only fallback. Tell the user exactly which data source is missing, ambiguous, or unavailable, offer candidate sources when possible, and ask for the smallest next decision that can unblock the build.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
