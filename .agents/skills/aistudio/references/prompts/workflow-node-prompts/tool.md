### Tool

- Backend `type`: `TOOL`
- **Metadata:** `toolCode` (required). Additional fields by tool type:
  - Chat Attachments Reader: `parseFiles` (boolean), `makeRawFilesAvailable` (boolean)
  - Connector tools: `functionName` (selected Connector Tool function)
- **Inputs by tool type:**
  - Deep Link tools: one input per tool parameter
  - Chat Attachments Reader: `conversationId`
  - Intent Change Indicator: `intentId`
  - Connector tools: selected function parameters

#### Structure

- `TOOL` supports these workflow-builder tool categories:
  - `DEEPLINK`
  - `CONNECTOR`
  - `MULTI_FILE_PROCESSOR`
  - `INTENT_CHANGE_INDICATOR`
  - `USER_SESSION`
- A valid `TOOL` node must include:
  - `metadata.toolCode`
  - outer `outcomes.success`
- `family` and `product` are selection filters for deeplink-tool lookup in the editor. They are local authoring aids, not part of the persisted TOOL-node metadata contract.
- For non-deeplink built-in tool categories, the workflow builder uses these persisted tool codes:
  - `ORA_MULTI_FILE_PROCESSOR_TOOL`
  - `ORA_INTENT_CHANGE_INDICATOR_TOOL`
  - `ORA_USER_SESSION_TOOL`
- Do not assume that every persisted `ORA_*` value is invalid for `TOOL`. These built-in tool codes are valid TOOL metadata in this product.

#### Deeplink tools

- Deeplink tools are selected through the editor's family/product/tool search flow.
- For deeplink tools, `metadata.toolCode` should be the selected deeplink tool's real tool code.
- Deeplink-tool parameter inputs come from the selected tool's parameter definitions.
- After changing the selected deeplink tool, stale parameter inputs from the previous tool must not remain on the node.
- When using `do-create-node` or `do-modify-node`, each deeplink parameter input should be set to the final parameter value itself, not a nested input-entry object.
- Preserve the parameter type supplied by the selected deeplink tool definition when authoring each input.

#### Connector tools

- Connector tools are selected through the editor's connector-tool search flow.
- For connector tools, `metadata.toolCode` should be the selected Connector Tool's real tool code.
- Connector Tool functions come from the selected tool's `kmConnectorConfig.tools`.
- If exactly one function is selected on the Connector Tool, set `metadata.functionName` to that function.
- If multiple functions are selected on the Connector Tool, use the function explicitly named by the user; if none is explicit, ask instead of guessing.
- After changing `functionName`, do not retain stale inputs from the previous function. The node inputs should match the selected function parameters only.
- When using `do-create-node` or `do-modify-node`, each connector parameter input should be set to the final parameter value itself, not a nested input-entry object.
- When the user has not specified parameter values, apply only these conservative defaults for the selected function:
  - `query`, `inputMessage`, `userInput`, `userInputMessage`, `searchText`, or `searchQuery`: `{{$context.$system.$inputMessage}}`
  - `filter` or `filters`: `[]`
- Compare parameter names case-insensitively and ignore spaces, `_`, and `-` for those defaults.
- User-provided parameter values always override these defaults.

#### MULTI_FILE_PROCESSOR

- `MULTI_FILE_PROCESSOR` uses `metadata.toolCode = ORA_MULTI_FILE_PROCESSOR_TOOL`.
- It requires an input named `conversationId`.
- `conversationId` is a normal string-backed node input.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.conversationId` to the raw string value.
- `parseFiles` and `makeRawFilesAvailable` are metadata fields, not inputs.
- In this workflow builder, `parseFiles` defaults to `true` and `makeRawFilesAvailable` defaults to `false`.
- When the node is a `MULTI_FILE_PROCESSOR`, persist both metadata flags explicitly so the node behavior is fully defined.

#### INTENT_CHANGE_INDICATOR

- `INTENT_CHANGE_INDICATOR` uses `metadata.toolCode = ORA_INTENT_CHANGE_INDICATOR_TOOL`.
- It requires an input named `intentId`.
- `intentId` is a normal string-backed node input.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.intentId` to the raw string value.

#### USER_SESSION

- `USER_SESSION` uses `metadata.toolCode = ORA_USER_SESSION_TOOL`.
- Do not invent unsupported required inputs for `USER_SESSION` unless the existing workflow or selected product behavior clearly requires them.
- `USER_SESSION` often needs no additional node inputs at all.

#### Authoring rules

- Use `TOOL` for supported utility-tool behavior, not for BO function calls or generic REST integrations.
- Do not use `TOOL` when the requirement is really a business object function call; use `BO_FUNCTION` instead.
- Do not invent a normal `failure` outcome for `TOOL` nodes. Use the normal `success` path and shared error-handling model.
- For deeplink tools, keep only the parameters defined by the selected tool.
- For connector tools, keep only the parameters defined by the selected function.
- For `MULTI_FILE_PROCESSOR`, do not move `parseFiles` or `makeRawFilesAvailable` into node inputs.
- For `INTENT_CHANGE_INDICATOR`, do not invent extra required inputs beyond `intentId`.
- If the tool type changes, remove stale metadata and inputs that only applied to the previous tool type.

#### Invalid patterns

- Invalid: omitting `metadata.toolCode`
- Invalid: omitting `metadata.functionName` for a Connector Tool after the connector function has been selected
- Invalid: using nested input objects such as `{ "type": "string", "value": "..." }` for `conversationId`, `intentId`, or deeplink parameters
- Invalid: using full input objects in `inputsPatch`
- Invalid: leaving stale deeplink parameters after the selected tool changes
- Invalid: guessing a Connector Tool `functionName` when the selected Connector Tool exposes multiple functions and the user did not choose one
- Invalid: leaving stale connector parameters after the selected connector `functionName` changes
- Invalid: putting `parseFiles` or `makeRawFilesAvailable` into `inputsPatch`
- Invalid: keeping `parseFiles` or `makeRawFilesAvailable` metadata on non-`MULTI_FILE_PROCESSOR` tools
- Invalid: omitting required `conversationId` for `MULTI_FILE_PROCESSOR`
- Invalid: omitting required `intentId` for `INTENT_CHANGE_INDICATOR`
- Invalid: inventing a normal `failure` outcome on the `TOOL` node
- Invalid: using `TOOL` for a BO/REST operation that should be modeled as `BO_FUNCTION`

#### Example

User request:
- "Generate a deeplink for an employee record and then continue to the next step."

Expected deeplink shape:
- `GENERATE_EMPLOYEE_LINK.type = TOOL`
- `GENERATE_EMPLOYEE_LINK.metadata.toolCode = <real selected deeplink tool code>`
- `GENERATE_EMPLOYEE_LINK.inputs.personId = {{$context.$nodes.GET_EMPLOYEE.$output.result.personId}}`
- `GENERATE_EMPLOYEE_LINK.outcomes.success = NEXT_NODE`

Expected chat-attachments-reader shape:
- `READ_CHAT_ATTACHMENTS.type = TOOL`
- `READ_CHAT_ATTACHMENTS.metadata.toolCode = ORA_MULTI_FILE_PROCESSOR_TOOL`
- `READ_CHAT_ATTACHMENTS.metadata.parseFiles = true`
- `READ_CHAT_ATTACHMENTS.metadata.makeRawFilesAvailable = false`
- `READ_CHAT_ATTACHMENTS.inputs.conversationId = {{$context.$workflow.chatConversationId}}`
- `READ_CHAT_ATTACHMENTS.outcomes.success = NEXT_NODE`

Expected intent-indicator shape:
- `CHECK_INTENT_CHANGE.type = TOOL`
- `CHECK_INTENT_CHANGE.metadata.toolCode = ORA_INTENT_CHANGE_INDICATOR_TOOL`
- `CHECK_INTENT_CHANGE.inputs.intentId = {{$context.$nodes.CLASSIFY_REQUEST.$output.intentId}}`
- `CHECK_INTENT_CHANGE.outcomes.success = NEXT_NODE`

Expected connector-tool shape:
- `SEARCH_WEB.type = TOOL`
- `SEARCH_WEB.metadata.toolCode = <real selected Connector Tool code>`
- `SEARCH_WEB.metadata.functionName = <only selected connector function, or user-selected function>`
- `SEARCH_WEB.inputs.query = {{$context.$system.$inputMessage}}`
- `SEARCH_WEB.inputs.filters = []`
- `SEARCH_WEB.outcomes.success = NEXT_NODE`

Expected user-session shape:
- `READ_USER_SESSION.type = TOOL`
- `READ_USER_SESSION.metadata.toolCode = ORA_USER_SESSION_TOOL`
- `READ_USER_SESSION.outcomes.success = NEXT_NODE`

Invalid examples:

- Invalid: `GENERATE_EMPLOYEE_LINK.metadata.toolCode` is changed to `ORA_MULTI_FILE_PROCESSOR_TOOL` but stale deeplink parameters such as `personId` remain on the node
- Invalid: `inputsPatch.conversationId = { "type": "string", "value": "{{$context.$workflow.chatConversationId}}" }`
- Invalid: `READ_CHAT_ATTACHMENTS.inputs.parseFiles = true`
- Invalid: `CHECK_INTENT_CHANGE.outcomes.failure = HANDLE_TOOL_FAILURE`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
