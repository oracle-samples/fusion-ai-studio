### Agent

- Backend `type`: `AGENT`
- Default node subtype: always use private agent mode by setting metadata/spec `type` to `PRIVATE`.
- Do not create/use an `AGENT` node when no tools are attached. If the behavior is pure prompting/reasoning with no attached tools, use an `LLM` node instead.
- Only use a reusable/external agent selection flow when the user explicitly asks to use an existing reusable agent.

#### Structure

- A valid `AGENT` node must include:
  - `metadata.type`
  - an outer `outcomes.success`
  - an input named `message`
- `AGENT` uses the normal forward `success` path.
- Do not invent a normal `failure` outcome for `AGENT`. If error handling is needed, use the shared `metadata.errorNodeId` pattern.
- `metadata.type` must be exactly `PRIVATE` or `REUSABLE`.
- `message` is always a normal node input. In the workflow spec it should be stored as `type: "string"` with a string `value`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.message` to the raw message string only.
- Do not pass nested input objects such as `{ "type": "string", "value": "..." }` for `message`.
- Do not pass full input objects such as `{ "id": "...", "name": "message", "type": "string", "value": "..." }`.

#### Private Agent Properties

- **Inputs:**
  - `prompt` (required; text/template; supports expressions)
  - `message` (required; text/template; supports expressions)
- **Metadata / specification fields:**
  - `type`: `PRIVATE` (required for nodes you create)
  - `modelConfiguration` (optional) — same model settings surface as LLM node
  - `chatHistoryEnabled` (boolean)
  - `answerInUserLanguage` (boolean)
  - `maxInteractions` (required number)
  - `agentRole` (optional string; persona/instructions)
  - `summarizationMode` (`Default` | `Custom` | `Disabled`)
  - `summarizationPrompt` (string; only meaningful when `summarizationMode` is `Custom`)
  - `toolCodes` (string[]; attached tools)
  - `topicCodes` (string[]; optional attached topics)
  - `aiAppOutputSpecification.dataDisplay` (optional object for App Experience settings)
  - `outputSpecification` (optional JSON schema/string for expected output)
- Note: the editor reuses the LLM model selection fields and also exposes app-experience fields on Agent nodes.
- For private agents, `prompt` is a normal node input and should be stored as `type: "string"` with a string `value`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.prompt` to the raw prompt string only.
- Do not pass nested input objects or full input-entry objects for `prompt`.
- For private agents, `maxInteractions`, `agentRole`, `summarizationMode`, `summarizationPrompt`, and private `outputSpecification` belong under `metadata.specification`, not as top-level metadata fields.
- For private agents, `toolCodes` and `topicCodes` are persisted as top-level metadata arrays on the node, not inside `metadata.specification`.
- `maxInteractions` is required for private agents and should be an integer from `1` to `20`.
- If `summarizationMode` is `Disabled`, persist an empty `summarizationPrompt`.
- If `summarizationMode` is `Default`, persist the default summarization mode and prompt instead of inventing a custom prompt value.

#### Reusable Agent Properties

- Use reusable mode only when the user explicitly wants an existing reusable agent.
- Reusable agents must set `metadata.type = REUSABLE`.
- Reusable agents must set `metadata.agentCode` to the selected reusable agent's real code.
- Reusable agents still require the normal string-backed `message` input.
- Additional reusable-agent variable inputs may exist beyond `message`. Those inputs must come from the selected reusable agent's published specification.
- Do not invent adhoc reusable-agent variable inputs that are not declared by the selected reusable agent.
- Preserve the declared type of each reusable-agent variable input from the selected agent specification.
- If the selected reusable agent changes, stale variable inputs from the previous reusable agent must not remain on the node.
- Reusable agents may expose tools, topics, and a read-only output schema from the selected reusable agent definition. Treat those as selection-derived behavior, not something to improvise freely.

#### Chat history

- If the Agent needs prior chat turns, set `metadata.chatHistoryEnabled = true`.
- When using `do-create-node` or `do-modify-node`, set this through `metadataPatch.chatHistoryEnabled = true`, not `inputsPatch`.
- Do not inject chat history into Agent `message`, `prompt`, `summarizationPrompt`, or Code node JavaScript with `$context.$system.$chatHistory`.
- Do not invent `$context.$system.$conversationHistory`.
- Use `{{$context.$system.$inputMessage}}` for the current user message when needed; let `chatHistoryEnabled` supply prior turns.

#### Concrete Examples

Valid private-agent shape:

- `CREATE_DRAFT_WITH_TOOLS.type = AGENT`
- `CREATE_DRAFT_WITH_TOOLS.metadata.type = PRIVATE`
- `CREATE_DRAFT_WITH_TOOLS.metadata.chatHistoryEnabled = true`
- `CREATE_DRAFT_WITH_TOOLS.outcomes.success = REVIEW_OUTPUT`
- `CREATE_DRAFT_WITH_TOOLS.inputs.message.type = string`
- `CREATE_DRAFT_WITH_TOOLS.inputs.message.value = "Draft an announcement for {{$context.$nodes.LOAD_INPUT.$output.topic}}."`
- `CREATE_DRAFT_WITH_TOOLS.inputs.prompt.type = string`
- `CREATE_DRAFT_WITH_TOOLS.inputs.prompt.value = "Use the available tools when needed, then return a structured draft summary."`
- `CREATE_DRAFT_WITH_TOOLS.metadata.specification.maxInteractions = 3`
- `CREATE_DRAFT_WITH_TOOLS.metadata.specification.agentRole = "You are an enterprise communications drafting assistant."`
- `CREATE_DRAFT_WITH_TOOLS.metadata.specification.summarizationMode = Default`
- `CREATE_DRAFT_WITH_TOOLS.metadata.specification.outputSpecification = {"type":"object","properties":{"draftTitle":{"type":"string"},"draftBody":{"type":"string"}}}`
- `CREATE_DRAFT_WITH_TOOLS.metadata.toolCodes = ["ORA_USER_SESSION_TOOL"]`
- `CREATE_DRAFT_WITH_TOOLS.metadata.topicCodes = ["INTERNAL_COMMS"]`

Valid reusable-agent shape:

- `RUN_REUSABLE_SUPPORT_AGENT.type = AGENT`
- `RUN_REUSABLE_SUPPORT_AGENT.metadata.type = REUSABLE`
- `RUN_REUSABLE_SUPPORT_AGENT.metadata.agentCode = EMPLOYEE_SUPPORT_AGENT`
- `RUN_REUSABLE_SUPPORT_AGENT.metadata.chatHistoryEnabled = true`
- `RUN_REUSABLE_SUPPORT_AGENT.outcomes.success = FINAL_RESPONSE`
- `RUN_REUSABLE_SUPPORT_AGENT.inputs.message.type = string`
- `RUN_REUSABLE_SUPPORT_AGENT.inputs.message.value = "Help with the employee request: {{$context.$system.$inputMessage}}"`
- `RUN_REUSABLE_SUPPORT_AGENT.inputs.caseId.type = string`
- `RUN_REUSABLE_SUPPORT_AGENT.inputs.caseId.value = "{{$context.$nodes.LOAD_CASE.$output.caseId}}"`
- `RUN_REUSABLE_SUPPORT_AGENT.inputs.employeeId.type = string`
- `RUN_REUSABLE_SUPPORT_AGENT.inputs.employeeId.value = "{{$context.$nodes.LOAD_CASE.$output.employeeId}}"`
- `RUN_REUSABLE_SUPPORT_AGENT` does not invent a private `prompt` input unless the selected reusable agent specification really defines an input with that exact name.
- `RUN_REUSABLE_SUPPORT_AGENT` uses the selected reusable agent's published variable inputs and read-only output schema.

Invalid mixed-mode examples:

- Invalid: `metadata.type = REUSABLE` together with an invented private `prompt` input when the selected reusable agent does not define one.
- Invalid: `metadata.type = PRIVATE` but `metadata.agentCode` is treated as the main configuration instead of private prompt/spec fields.
- Invalid: putting reusable-agent selection-derived variable inputs on the node before a real reusable `agentCode` has been selected.

#### Output schema contract

- `AGENT` nodes may declare an editable `outputSpecification`.
- In private mode, the editable output schema is part of `metadata.specification.outputSpecification`.
- In reusable mode, the output schema comes from the selected reusable agent definition and should be treated as read-only.
- If downstream nodes reference field-level output paths such as `$context.$nodes.MY_AGENT.$output.someField`, those fields must exist in the Agent node's `outputSpecification`.
- Do not invent `$output` fields that are not declared in the schema.
- If the Agent output is intended to stay unstructured, prefer referencing raw `$output` instead of pretending field-level properties exist.
- If you change the expected structured output of an `AGENT` node, update `outputSpecification` in the same pass.

#### AI Apps / Agentic App properties

When an `AGENT` node is used on an app-stage path (`InitDisplay`, `InitActions`, `InitCommunications`, `Query`, or `Summary`), you must also configure its **App Experience** properties when structured app output is expected.

- `aiAppOutputSpecification.dataDisplay.layouts: string[]`
  - The selected widget ids for this node.
  - Current supported values:
    - `ORA_LAYOUT_CARD`
    - `ORA_LAYOUT_ARTIFACT_PREVIEW`
    - `ORA_LAYOUT_MULTICARD`
    - `ORA_LAYOUT_MESSAGES_LIST`
    - `ORA_LAYOUT_CHANGE_LIST`
    - `ORA_LAYOUT_CHART`
    - `ORA_LAYOUT_RECORD`
    - `ORA_LAYOUT_MULTIRECORD`
    - `ORA_LAYOUT_SANKEY`
  - Required when the node is expected to emit `oraInfoDisplay` widget output.
- `aiAppOutputSpecification.dataDisplay.enableActions: boolean`
  - Corresponds to **Enable Actions for the widgets** in the UI.
  - Required when the node is expected to emit `oraInsight` action suggestions.
- `aiAppOutputSpecification.dataDisplay.enableCommunications: boolean`
  - Corresponds to **Enable Communications for the widgets** in the UI.
  - Required when the node is expected to emit `oraComms` communication suggestions.
- `aiAppOutputSpecification.dataDisplay.enablePowerPoints: boolean`
  - Nested under communications in the UI.
  - Required in addition to `enableCommunications: true` when the node is expected to emit PowerPoint (`type: "ppt"`) communication suggestions.
- `aiAppOutputSpecification.dataDisplay.customNotes: string`
  - Corresponds to the **Instructions** field in App Experience.
  - Use it to describe when/how the node should use its selected widgets, actions, or communications.

If the prompt expects widget/action/communication output but the matching App Experience property is not enabled, treat the node configuration as incomplete.
For non-PowerPoint agent-driven communications such as `text`, `email`, or `pdf`, `enableCommunications: true` is sufficient; do not require `enablePowerPoints`.

If `ORA_LAYOUT_ARTIFACT_PREVIEW` is selected:

- emit `artifactPreviewWidget` items with required `artifactId`, `title`, `mode`, and `content`
- use `action` only for `custom`; `preview` and `edit` open the artifact viewer directly
- use `content.sections` for `structuredRichText` items; each section must be `{ name, locked, text }`
- expect editable saves to return as `oraFormSubmit` with `newValue` and `metadata.artifactId`

#### Node Choice Rule

- If the node does not need tools, do not use `AGENT`; use `LLM`.
- Use `AGENT` only when tool-backed behavior is required and you can attach at least one tool via `toolCodes`.
- For vibe-created agent nodes, prefer the minimum viable private-agent configuration:
  - `type: PRIVATE`
  - `prompt`
  - `message`
  - `maxInteractions`
  - `toolCodes` (non-empty)
  - optional model/summarization/output fields only when needed

#### Special note: ambiguous Agent node requests

If the user asks to “modify”, “fix”, “check”, or “update” an **Agent** node but does not specify *what part*, assume they mean the `prompt` input.

#### Invalid patterns

- Invalid: omitting `metadata.type`
- Invalid: using a `metadata.type` other than `PRIVATE` or `REUSABLE`
- Invalid: omitting the required `message` input
- Invalid: authoring `message` as a non-string input type
- Invalid: setting `inputsPatch.message` to a nested input object instead of the raw message string
- Invalid: setting `inputsPatch.message` to a full input object
- Invalid: in private mode, omitting the required `prompt` input
- Invalid: in private mode, authoring `prompt` as a non-string input type
- Invalid: in private mode, setting `inputsPatch.prompt` to a nested input object instead of the raw prompt string
- Invalid: in private mode, omitting `metadata.specification.maxInteractions`
- Invalid: in private mode, using a non-integer, zero, negative, or out-of-range `maxInteractions`
- Invalid: in private mode, storing `maxInteractions`, `agentRole`, `summarizationMode`, `summarizationPrompt`, or private `outputSpecification` as top-level metadata fields instead of under `metadata.specification`
- Invalid: in private mode, storing `toolCodes` or `topicCodes` inside `metadata.specification` instead of as top-level metadata arrays
- Invalid: in reusable mode, omitting `metadata.agentCode`
- Invalid: in reusable mode, inventing adhoc variable inputs that are not declared by the selected reusable agent
- Invalid: leaving stale reusable-agent variable inputs from a previous agent selection
- Invalid: inventing a normal `failure` outcome on the `AGENT` node

Examples:

- `DRAFT_WITH_TOOLS.type = AGENT`
- `DRAFT_WITH_TOOLS.metadata.type = PRIVATE`
- `DRAFT_WITH_TOOLS.inputs.message.type = string`
- `DRAFT_WITH_TOOLS.inputs.prompt.type = string`
- `DRAFT_WITH_TOOLS.metadata.specification.maxInteractions = 3`
- `DRAFT_WITH_TOOLS.metadata.toolCodes = ["ORA_USER_SESSION_TOOL"]`
- `USE_REUSABLE_COACH.metadata.type = REUSABLE`
- `USE_REUSABLE_COACH.metadata.agentCode = EXISTING_COACH_AGENT`

#### CRITICAL: Agent nodes on required app-stage paths

When an `AGENT` node is used as the terminal generator for an app-stage path:

- `InitDisplay`: it must be configured to produce at least one `oraInfoDisplay` block and must have at least one widget selected in App Experience. If the same workflow powers multiple app panels, use `$context.$app.$OraAppDisplayDiscriminator` to distinguish the requesting panel/container.
- `InitActions`: it must be configured to produce zero or more `oraInsight` blocks and must have `enableActions: true`.
- `InitCommunications`: it must be configured to produce zero or more `oraComms` blocks and must have `enableCommunications: true`.
- `Query`: it may return normal text, widgets, actions, or communications depending on the prompt and App Experience settings.
- `Summary`: it should return summary text for this agent's contribution unless the app-stage prompt explicitly asks for structured app output.
- A required app-stage `AGENT` node must be dedicated to that stage. Shared upstream prep is fine, but do not reuse one terminal `AGENT` node for multiple required stages by branching inside the prompt on `$context.$app.$OraMessageHint`.
- A shared `CODE`, `RETURN`, or `SET_FIELDS` node after the app-stage router does not count as a dedicated app-stage terminal. Use shared `CODE` only before the router for data normalization, then route to separate stage-specific `AGENT` nodes.
- If you are handed one prompt with multiple app-stage branches, split it across separate stage-specific terminal `AGENT` nodes behind the workflow's `$context.$app.$OraMessageHint` router.
- Do not create one terminal `AGENT` node whose prompt handles startup display, normal query, and summary behavior. Use separate `AGENT` nodes for `InitDisplay`, `Query`, and `Summary` when those stages are required.
- Do not put `if USER_MESSAGE is empty` routing inside a terminal app-stage `AGENT` prompt; route that case in the graph.

Do not leave an app-stage `AGENT` node configured as plain text only when the path is supposed to produce structured app output.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
