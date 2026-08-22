### LLM

- Backend `type`: `LLM`
- **Inputs:** `systemPrompt` (text/template; supports expressions), `prompt` (User Prompt text/template; supports expressions)
- **Metadata:** `modelConfiguration` (optional) — includes `code`, `provider`, `model`, `modelProperties`; `chatHistoryEnabled` (boolean); `answerInUserLanguage` (boolean)
- **AI Apps / Agentic App metadata:** `aiAppOutputSpecification.dataDisplay` (optional object)
- **Output:** `outputSpecification` (editable JSON schema string)

#### Structure

- A valid `LLM` node should author `prompt` as a string input entry.
- `systemPrompt` is also a normal string input entry when used.
- `prompt` is required.
- `systemPrompt` is optional.
- `prompt` and `systemPrompt` should each be stored as standard node inputs with:
  - `name`
  - `type: "string"`
  - string `value`
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.prompt` and `inputsPatch.systemPrompt` to raw string values.
- `inputsPatch.prompt` and `inputsPatch.systemPrompt` must contain only the final prompt text, not mini input-entry wrappers.
- Never put `prompt` or `systemPrompt` in `metadataPatch`; they are node inputs, not metadata.
- If an LLM needs the current user message, include `{{$context.$system.$inputMessage}}` inside `inputsPatch.prompt`.
- Do not pass nested input objects such as `{ "type": "string", "value": "..." }` for `prompt` or `systemPrompt`.
- Do not pass full input objects such as `{ "id": "...", "name": "prompt", "type": "string", "value": "..." }`.
- `chatHistoryEnabled` and `answerInUserLanguage` are metadata flags, not node inputs.
- `LLM` uses a normal outer `outcomes.success` path. Do not invent a mandatory normal `failure` outcome.

#### Chat history

- If the LLM needs prior chat turns, set `metadata.chatHistoryEnabled = true`.
- When using `do-create-node` or `do-modify-node`, set this through `metadataPatch.chatHistoryEnabled = true`, not `inputsPatch`.
- Do not inject chat history into `prompt`, `systemPrompt`, or Code node JavaScript with `$context.$system.$chatHistory`.
- Do not invent `$context.$system.$conversationHistory`.
- Keep the LLM prompt focused on the latest task and explicit data inputs. Use `{{$context.$system.$inputMessage}}` for the current user message when needed; let `chatHistoryEnabled` supply prior turns.

#### Output schema contract

- `LLM` nodes have an editable `outputSpecification`.
- If downstream nodes reference field-level output paths such as `$context.$nodes.MY_LLM.$output.someField`, those fields must be explicitly declared in the `LLM` node's `outputSpecification`.
- If the intended downstream usage is only free-form text and no field-level access is needed, downstream nodes may reference the raw `$output` instead of inventing schema fields.
- Do not reference undeclared `$output` fields from an `LLM` node just because the prompt asks the model to return JSON-like content.
- If you change the expected structured shape of an `LLM` node's output, update its `outputSpecification` in the same pass.
- Keep the prompt and `outputSpecification` aligned. If `outputSpecification` declares `{ "summary": { "type": "string" } }`, the prompt must instruct the model to return a structured result with a `summary` field. If the desired output is plain text or markdown only, do not declare an object schema that downstream code is not actually using.

#### AI Apps / Agentic App properties

When an `LLM` node is used on an app-stage path (`InitDisplay`, `InitActions`, `InitCommunications`, `Query`, or `Summary`), you must also consider its **App Experience** properties, not just the prompt text.

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
  - Use this when the node is expected to emit `oraInfoDisplay` widget output.
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

#### CRITICAL: LLM node `prompt` (User Prompt) is NOT the final user-facing message

When configuring an LLM node, the `prompt` input (User Prompt) must be **instructions to the model**, not the final user-facing message.

- The `prompt` MUST be phrased like an instruction (e.g. start with verbs like `Generate...`, `Write...`, `Summarize...`).
- The `prompt` MUST NOT contain the final user message text (e.g. do not write `We couldn't find...` inside the prompt).
- Use `systemPrompt` for higher-level role/behavior constraints and `prompt` for task-specific instructions.
- The LLM node's **output** is what will be shown to the user.

Bad (incorrect prompt — written like the final user-facing message):

- `We couldn't find any talent data for your team at the moment. Please check back later... Meanwhile, here's a creative message...`

Good (correct prompt — instructions for what to generate):

- `Generate a friendly message telling the user no team talent data is available right now. Keep it 1–2 sentences. Return only the message text.`

CRITICAL: Do not include meta text like `here's a creative message` or `the following is the message` in the prompt.

Valid input-authoring examples:

- `inputsPatch.prompt = "Generate a short status update for {{$context.$nodes.LOAD_STATUS.$output}}."`
- `inputsPatch.prompt = "Extract the user's request from this message: {{$context.$system.$inputMessage}}. Return strict JSON."`
- `inputsPatch.systemPrompt = "You are a concise enterprise writing assistant."`

Invalid input-authoring examples:

- `metadataPatch.prompt = "Extract the user's request from {{$context.$system.$inputMessage}}."`
- `metadataPatch.systemPrompt = "You are a JSON extraction assistant."`
- `inputsPatch.prompt = { "type": "string", "value": "Generate a short status update." }`
- `inputsPatch.systemPrompt = { "id": "x", "name": "systemPrompt", "type": "string", "value": "You are..." }`
- `outputSpecification = {"type":"object","properties":{"summary":{"type":"string"}}}` while the prompt says `Return only a markdown summary` and never instructs the model to produce the `summary` field.

Concrete valid node shape:

- `GENERATE_STATUS_SUMMARY.type = LLM`
- `GENERATE_STATUS_SUMMARY.inputs.prompt.type = string`
- `GENERATE_STATUS_SUMMARY.inputs.prompt = Generate a concise status summary using this data: {{$context.$nodes.LOAD_STATUS.$output}}. Return only the summary text.`
- `GENERATE_STATUS_SUMMARY.inputs.systemPrompt.type = string`
- `GENERATE_STATUS_SUMMARY.inputs.systemPrompt = You are a concise enterprise writing assistant.`
- `GENERATE_STATUS_SUMMARY.metadata.chatHistoryEnabled = true`
- `GENERATE_STATUS_SUMMARY.metadata.answerInUserLanguage = true`
- `GENERATE_STATUS_SUMMARY.outputSpecification = {"type":"object","properties":{"summary":{"type":"string"}}}`
- `GENERATE_STATUS_SUMMARY.outcomes.success = NEXT_NODE`

Concrete invalid patterns:

- Invalid: `inputsPatch.prompt = { "type": "string", "value": "Write a short summary." }`
- Invalid: `metadataPatch.prompt = "Write a short summary."`
- Invalid: `metadataPatch.systemPrompt = "You are helpful."`
- Invalid: `inputsPatch.chatHistoryEnabled = true`
- Invalid: `inputsPatch.prompt = "Use prior turns: {{$context.$system.$chatHistory}}"`
- Invalid: `inputsPatch.prompt = "Use prior turns: {{$context.$system.$conversationHistory}}"`
- Invalid: `GENERATE_STATUS_SUMMARY.inputs.answerInUserLanguage = true`
- Invalid: `GENERATE_STATUS_SUMMARY.outcomes.failure = HANDLE_LLM_FAILURE`
- Invalid: downstream uses `{{$context.$nodes.GENERATE_STATUS_SUMMARY.$output.result.summary}}` even though the LLM `outputSpecification` declares top-level `summary`
- Invalid: downstream uses `{{$context.$nodes.GENERATE_STATUS_SUMMARY.$output.summary}}` when the node has no `outputSpecification` field named `summary`

#### CRITICAL: Data-driven LLM prompts must include node expressions

If an `LLM` node is meant to operate on workflow data, include the data explicitly in the `prompt` with expression token(s). Do not assume the model will implicitly receive upstream data.

Bad (missing data injection):

- `Generate a friendly and clear presentation of the team talent data provided in the input.`

Good (explicit data injection):

- `Generate a friendly and clear presentation of this team talent data: {{$context.$nodes.FETCH_TEAM_TALENT_DETAILS.$output}}. Highlight key strengths, keep it concise, and return only the final message text.`

#### CRITICAL: Preserve user-requested output requirements

When the user asks for specific output content, format, fields, ordering, tone, boundaries, or transformations, encode those requirements directly in the local `LLM` node prompt. Do not replace a detailed requested contract with a vague instruction such as "summarize the data".

If tests or debugging show the LLM output is incomplete, repair the prompt by making the original contract clearer and better grounded in upstream data. Do not remove required fields, record-level detail, formatting boundaries, visual/textual presentation requirements, or exact fallback semantics just to make a test pass.

#### Special note: ambiguous LLM node requests

If the user asks to “modify”, “fix”, “check”, or “update” an **LLM** node but does not specify *what part*, assume they mean the `prompt` (User Prompt) input.

#### CRITICAL: LLM nodes on required app-stage paths

When an `LLM` node is used as the terminal generator for an app-stage path:

- `InitDisplay`: it must be configured to produce at least one `oraInfoDisplay` block and must have at least one widget selected in App Experience. If the same workflow powers multiple app panels, use `$context.$app.$OraAppDisplayDiscriminator` to distinguish the requesting panel/container.
- `InitActions`: it must be configured to produce zero or more `oraInsight` blocks and must have `enableActions: true`.
- `InitCommunications`: it must be configured to produce zero or more `oraComms` blocks and must have `enableCommunications: true`.
- `Query`: it may return normal text, widgets, actions, or communications depending on the prompt and App Experience settings.
- `Summary`: it should return summary text for this agent's contribution unless the app-stage prompt explicitly asks for structured app output.
- A required app-stage `LLM` node must be dedicated to that stage. Shared upstream prep is fine, but do not reuse one terminal `LLM` node for multiple required stages by branching inside the prompt on `$context.$app.$OraMessageHint`.
- A shared `CODE`, `RETURN`, or `SET_FIELDS` node after the app-stage router does not count as a dedicated app-stage terminal. Use shared `CODE` only before the router for data normalization, then route to separate stage-specific `LLM` nodes.
- Do not replace an app-stage `LLM` with a terminal `CODE` node that assembles or returns `oraInfoDisplay` XML or widget JSON. If widget output is needed, keep the terminal app-stage `LLM` and configure its App Experience layouts.
- If you are handed one prompt with multiple app-stage branches, split it across separate stage-specific terminal `LLM` nodes behind the workflow's `$context.$app.$OraMessageHint` router.
- Do not create one terminal `LLM` node whose prompt handles startup display, normal query, and summary behavior. Use separate `LLM` nodes for `InitDisplay`, `Query`, and `Summary` when those stages are required.
- Do not put `if USER_MESSAGE is empty` routing inside a terminal app-stage `LLM` prompt; route that case in the graph.

Do not leave an app-stage `LLM` node configured as plain text only when the path is supposed to produce structured app output.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
