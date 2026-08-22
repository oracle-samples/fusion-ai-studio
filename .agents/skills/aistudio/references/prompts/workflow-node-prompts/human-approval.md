### Human Approval

- Backend `type`: `HUMAN`
- `HUMAN` is a human-in-the-loop review node with three distinct channel-specific shapes: `CHAT`, `EMAIL`, and `APPROVAL_PROCESS`.
- **Metadata:**
  - `channelType`: `CHAT`, `EMAIL`, or `APPROVAL_PROCESS` (required)
  - `approvalEnabledFlag`: boolean
  - `feedbackEnabledFlag`: boolean
  - `maxIterations`: number (required for approval-enabled feedback loops)
  - `loopBackNodeId`: node ID
  - `emailAccountId`, `emailAccountMappingRowId`: email configuration (EMAIL channel)
  - `approvalProcessCode`: approval process identifier (APPROVAL_PROCESS channel)
- **Inputs:**
  - `emailChannelInput`: object with `timeoutUnit`, `timeout`, `messageTemplate`, `timeoutTemplate`, `maxIterationsExceededTemplate`, `attachments`, `actions`
  - `approvalProcessInput`: object with `approvalRuntimePayload`, `attachments`, `actions`, `subject`, `message`
  - `chatChannelInput`: object with `messageTemplate`; approval-enabled CHAT feedback loops may also include `maxIterationsExceededTemplate` and `requestChangeMessage`

#### Shared rules

- `channelType` is required.
- The selected channel must provide the matching input payload:
  - `CHAT` -> `chatChannelInput`
  - `EMAIL` -> `emailChannelInput`
  - `APPROVAL_PROCESS` -> `approvalProcessInput`
- `loopBackNodeId` must be a real node id, not a node code or display name.
- For approval-enabled feedback loops, `maxIterations` must be present in metadata.
- If `maxIterations` is present for a feedback loop, it must be a positive integer.
- Approval-off CHAT conversational router loopbacks are different from approval/review loops: they may keep `feedbackEnabledFlag = true` so the loopback target can consume typed follow-up text, but they should not carry approval-only iteration payloads just to satisfy feedback.
- For approval-off CHAT conversational router loopbacks, `feedbackEnabledFlag` must be `true` whenever the loopback target reads `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`.
- For approval-off CHAT conversational router loopbacks, do not include `maxIterations`; that field belongs to approval-enabled feedback/review loops.
- The editor defaults new `HUMAN` nodes to `feedbackEnabledFlag = true`, `approvalEnabledFlag = true`, and `maxIterations = 3`.
- `HUMAN` nodes continue through `outcomes.success` after resume. Do not invent `failure`, `reject`, or `timeout` outcomes for normal Human-node branching.
- When a feedback loop returns to an LLM or other generation node, make the initial and feedback instructions mutually exclusive. State the initial-only behavior under an explicit absent-or-empty-feedback condition, and state the revision behavior under an explicit feedback-present condition. Revision metadata must explain what changed. Never append an unconditional initial-response requirement after the feedback-present instruction.
- A `HUMAN` node must have a `success` outcome.
- Do not place `HUMAN` nodes inside `LOOP`, `WHILE`, or `PARALLEL` containers.
- Do not invent extra top-level HUMAN metadata fields.

#### CHAT channel

- Use `metadata.channelType = CHAT`.
- `chatChannelInput` must be an object, not a JSON string.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.chatChannelInput` to the native payload object itself.
- Do not wrap `chatChannelInput` in a nested input object such as `{ "type": "object", "value": { ... } }` or a full input object with `id` / `name` / `type` / `value`.
- The node input entry's `value` for `chatChannelInput` must be a native object in the workflow spec, not a stringified JSON blob.
- The node input entry itself should use `type: "object"` for `chatChannelInput`, not `type: "string"`.
- Do not serialize `chatChannelInput.value` with `JSON.stringify(...)` or emit escaped JSON text.
- If a generated workflow artifact shows `chatChannelInput.type = "string"` or `chatChannelInput.value = "{\"messageTemplate\":...}"`, treat the HUMAN node as invalid and fix it before finishing.
- `chatChannelInput.messageTemplate` must itself be an object with shape:
  - `{ "message": "..." }`
- `chatChannelInput.messageTemplate.message` is required.
- Keep CHAT `messageTemplate.message` single-line. Do not emit literal line breaks or `\n` in the stored CHAT message.
- For approval-enabled CHAT feedback/review loops where both `approvalEnabledFlag` and `feedbackEnabledFlag` are `true`, include:
  - `chatChannelInput.maxIterationsExceededTemplate = { "message": "..." }`
  - `chatChannelInput.requestChangeMessage = "..."`
- `requestChangeMessage` is only meaningful for approval-enabled CHAT feedback/review loops where both approval and feedback are enabled.
- If `approvalEnabledFlag` is `false`, do not model approval-specific chat behavior as if approval were still enabled.
- For approval-off CHAT conversational router loopbacks, keep `chatChannelInput` to the message template only unless there is an explicit post-human continuation design that needs more.

Valid CHAT shape:

```json
{
  "type": "HUMAN",
  "metadata": {
    "channelType": "CHAT",
    "approvalEnabledFlag": true,
    "feedbackEnabledFlag": true,
    "maxIterations": 3,
    "loopBackNodeId": "1"
  },
  "inputs": [
    {
      "name": "chatChannelInput",
      "value": {
        "messageTemplate": {
          "message": "Review this announcement draft and approve it if it is ready to send: {{$context.$nodes.PREPARE_DRAFT_ANNOUNCEMENT.$output.result.draftAnnouncement}}"
        },
        "maxIterationsExceededTemplate": {
          "message": "Maximum review iterations reached."
        },
        "requestChangeMessage": "If you want changes, explain exactly what needs to be changed."
      }
    }
  ]
}
```

Invalid CHAT shape:

```json
{
  "inputs": [
    {
      "name": "chatChannelInput",
      "value": "{\"messageTemplate\":\"Please review...\",\"requestChangeMessage\":\"Explain changes\",\"maxIterationsExceededTemplate\":\"Maximum review iterations reached.\"}"
    }
  ]
}
```

Why invalid:
- `chatChannelInput` should be an object, not a serialized JSON string
- the node input type should be `object`, not `string`
- the `value` field should directly hold the object, not a JSON-encoded string
- `messageTemplate` must be an object with a `message` field
- `maxIterationsExceededTemplate` must be an object with a `message` field

Example same-session CHAT input collection pattern:

- A `HUMAN` node can be used to collect typed feedback in the same chat session.
- In that pattern:
  - `approvalEnabledFlag = true`
  - `feedbackEnabledFlag = true`
  - `loopBackNodeId` points to the node that consumes the typed feedback
  - the consumer reads `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`
- If the workflow claims to collect free-form user input through a CHAT Human node, it must wire the loopback so a downstream step actually consumes `$feedbackReceived`.

Example approval-off CHAT conversational router loopback pattern:

- Use this pattern when a CHAT `HUMAN` node asks/shows something, waits for the user's next typed message, and then returns to an extractor/router.
- In that pattern:
  - `approvalEnabledFlag = false`
  - `feedbackEnabledFlag = true`
  - `loopBackNodeId` points to the extractor/router node id that will process the next typed message
  - `outcomes.success` points to `end`
  - the loopback target reads `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`
- Do not create `Approve`, `Request Changes`, or other approval-style outcomes for this pattern.
- Do not create a normal `HUMAN -> ROUTER` success edge for this pattern; the re-entry path is `metadata.loopBackNodeId`.
- Do not set `feedbackEnabledFlag = false` for this pattern; without feedback enabled, the next typed user message is not available through `$feedbackReceived`.
- Do not add `metadata.maxIterations` for this pattern.
- Do not add `chatChannelInput.requestChangeMessage` or `chatChannelInput.maxIterationsExceededTemplate` for approval-off CHAT router-loopbacks.
- This is not a blanket rule for every approval-off `HUMAN` node. If a Human node intentionally continues to a post-human processing node, `outcomes.success` may point to that real downstream node.

Valid approval-off CHAT router loopback shape:

```json
{
  "type": "HUMAN",
  "metadata": {
    "channelType": "CHAT",
    "approvalEnabledFlag": false,
    "feedbackEnabledFlag": true,
    "loopBackNodeId": "1"
  },
  "inputs": [
    {
      "name": "chatChannelInput",
      "value": {
        "messageTemplate": {
          "message": "Please provide the missing customer id."
        }
      }
    }
  ],
  "outcomes": {
    "success": "end"
  }
}
```

#### EMAIL channel

- Use `metadata.channelType = EMAIL`.
- `metadata.emailAccountId` is required for EMAIL.
- Persist `metadata.emailAccountMappingRowId` alongside `emailAccountId` for EMAIL artifacts when the account mapping identifier is available from the selected account configuration.
- For EMAIL artifacts, `approvalEnabledFlag` should remain `true`.
- `emailChannelInput` must be an object, not a JSON string.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.emailChannelInput` to the native payload object itself.
- Do not wrap `emailChannelInput` in a nested input object such as `{ "type": "object", "value": { ... } }` or a full input object with `id` / `name` / `type` / `value`.
- The node input entry's `value` for `emailChannelInput` must be a native object in the workflow spec, not a stringified JSON blob.
- `emailChannelInput` should include:
  - `timeoutUnit`
  - `timeout`
  - `messageTemplate`
  - `timeoutTemplate`
- When `feedbackEnabledFlag` is `true`, also include `maxIterationsExceededTemplate`.
- `messageTemplate`, `timeoutTemplate`, and `maxIterationsExceededTemplate` are structured email template objects, not plain strings.
- `messageTemplate.message` is required.
- `attachments` is a top-level EMAIL channel field, not a per-template field.
- `actions` is a top-level EMAIL channel field containing action entries for `APPROVE`, `REJECT`, and optionally `RFI_ACTION` when feedback is enabled.
- Each email template object should follow the editor-authored shape:
  - `from`
  - `message`
  - `emailHeaders` with `to`, `cc`, `bcc`, and `subject`
- EMAIL templates must keep their delivery fields inside the channel input object. Do not move `requestChangeMessage`, `timeout`, or `timeoutUnit` into metadata.

Valid EMAIL shape:

```json
{
  "type": "HUMAN",
  "metadata": {
    "channelType": "EMAIL",
    "feedbackEnabledFlag": true,
    "maxIterations": 3,
    "loopBackNodeId": "1",
    "emailAccountId": "acc1",
    "emailAccountMappingRowId": "row-1"
  },
  "inputs": [
    {
      "name": "emailChannelInput",
      "value": {
        "timeoutUnit": "HOUR",
        "timeout": "{{$context.$system.$currentDateTime}}",
        "messageTemplate": {
          "from": "approvals@acme.com",
          "message": "Please review this draft.",
          "emailHeaders": {
            "to": "reviewer@acme.com",
            "cc": "",
            "bcc": "",
            "subject": "Review request"
          }
        },
        "timeoutTemplate": {
          "from": "approvals@acme.com",
          "message": "The review request timed out.",
          "emailHeaders": {
            "to": "reviewer@acme.com",
            "cc": "",
            "bcc": "",
            "subject": "Review timeout"
          }
        },
        "maxIterationsExceededTemplate": {
          "from": "approvals@acme.com",
          "message": "Maximum review iterations reached.",
          "emailHeaders": {
            "to": "reviewer@acme.com",
            "cc": "",
            "bcc": "",
            "subject": "Review closed"
          }
        },
        "attachments": "{{$context.$nodes.COLLECT_FILES.$output.result.attachments}}",
        "actions": [
          { "type": "APPROVE_ACTION", "label": "Approve" },
          { "type": "REJECT_ACTION", "label": "Reject" },
          { "type": "RFI_ACTION", "label": "Request changes" }
        ]
      }
    }
  ]
}
```

#### APPROVAL_PROCESS channel

- Use `metadata.channelType = APPROVAL_PROCESS`.
- `metadata.approvalProcessCode` is required for APPROVAL_PROCESS and should be populated from the approval-process LOV selection.
- For APPROVAL_PROCESS artifacts, `approvalEnabledFlag` should remain `true`.
- `approvalProcessInput` must be an object, not a JSON string.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.approvalProcessInput` to the native payload object itself.
- Do not wrap `approvalProcessInput` in a nested input object such as `{ "type": "object", "value": { ... } }` or a full input object with `id` / `name` / `type` / `value`.
- The node input entry's `value` for `approvalProcessInput` must be a native object in the workflow spec, not a stringified JSON blob.
- `approvalProcessInput` may include:
  - `approvalRuntimePayload`
  - `attachments`
  - `actions`
  - `subject`
  - `message`
- `approvalProcessInput.approvalRuntimePayload` is optional. If present, it must itself be a string value. Use either:
  - a stringified JSON payload string such as `"{\"employees\":{\"name\":\"Taylor Brooks\"}}"`, or
  - an expression string such as `{{$context.$nodes.BUILD_APPROVAL_PAYLOAD.$output.result}}`
- Do not emit `approvalRuntimePayload` as a nested object or array inside `approvalProcessInput`.
- `attachments` is optional and string-backed. When present, store either an expression string or `""`; do not store an array literal.
- Action labels are optional in the UI. Blank labels are valid.
- If `actions` is present, use `APPROVE_ACTION` and `REJECT_ACTION`, and include `RFI_ACTION` only when `feedbackEnabledFlag` is `true`.
- Missing `actions` entries should be treated as blank labels, not as a reason to change the payload shape.
- `subject` is optional. When present, it may be authored as either a literal string or an expression-backed string value.
- `message` is optional. When present, it may include normal template text with expressions.

Valid APPROVAL_PROCESS shape:

```json
{
  "type": "HUMAN",
  "metadata": {
    "channelType": "APPROVAL_PROCESS",
    "approvalEnabledFlag": true,
    "feedbackEnabledFlag": true,
    "maxIterations": 3,
    "loopBackNodeId": "1",
    "approvalProcessCode": "PROMOTE_AI_AGENT_001"
  },
  "inputs": [
    {
      "name": "approvalProcessInput",
      "value": {
        "approvalRuntimePayload": "{{$context.$nodes.BUILD_APPROVAL_PAYLOAD.$output.result}}",
        "attachments": "{{$context.$nodes.COLLECT_FILES.$output.result.attachments}}",
        "actions": [
          { "type": "APPROVE_ACTION", "label": "Approve" },
          { "type": "REJECT_ACTION", "label": "Reject" },
          { "type": "RFI_ACTION", "label": "Need more info" }
        ],
        "subject": "Promotion approval for {{$context.$input.employeeName}}",
        "message": "Please review and approve this promotion request."
      }
    }
  ]
}
```

#### Loopback rule

- `loopBackNodeId` must target the actual node id of the node to revisit when feedback continues the loop.
- Do not set `loopBackNodeId` to a node code such as `PREPARE_DRAFT_ANNOUNCEMENT`.
- Do not invent or guess node ids.

#### Runtime expressions exposed by HUMAN nodes

After a HUMAN node resumes, downstream logic may read Human-specific runtime fields from that node.

Supported HUMAN runtime expressions:

- `$context.$nodes.<HUMAN_CODE>.$actionPerformed`
  - action taken by the human, such as approval, rejection, feedback/request-change, or timeout
- `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`
  - text entered by the reviewer when they request changes
- `$context.$nodes.<HUMAN_CODE>.$iterationsPerformed`
  - number of completed feedback iterations

Use these exact Human-node fields when designing a feedback loop.

- If a revision step must incorporate reviewer comments, read them from `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`.
- If a loopback target/extractor must understand the user's follow-up text after a Human node, read it from `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`.
- If downstream behavior depends on how the human responded, inspect `$context.$nodes.<HUMAN_CODE>.$actionPerformed`.
- If the workflow must reason about retry count, inspect `$context.$nodes.<HUMAN_CODE>.$iterationsPerformed`.
- Typical action values include approval, rejection, feedback/request-change, and timeout. Model downstream logic from `$actionPerformed` instead of inventing extra outcomes.
- When adding or modifying a Human loopback, update the loopback target prompt/source/configuration in the same pass so it consumes the Human runtime fields it needs.

Do not invent alternate Human-output field paths such as:

- `$context.$nodes.<HUMAN_CODE>.$output`
- `$context.$nodes.<HUMAN_CODE>.$output.feedback`
- `$context.$nodes.<HUMAN_CODE>.$output.requestChangeMessage`
- `$context.$nodes.<HUMAN_CODE>.$output.comments`
- `$context.$nodes.<HUMAN_CODE>.$output.comment`

When the user explicitly asks for a feedback-driven rewrite loop, prefer a pattern where the looped-back node reads `$context.$nodes.<HUMAN_CODE>.$feedbackReceived` directly and regenerates the draft from that value.

Example pattern for a rewrite loop:

- `DRAFT_REWRITE` (`CODE`) reads:
  - `$context.$nodes.REVIEW_COPY.$feedbackReceived`
  - `$context.$nodes.REVIEW_COPY.$iterationsPerformed`
- `REVIEW_COPY` (`HUMAN`) loops back to `DRAFT_REWRITE` when feedback is requested
- The rewrite node updates the next draft using the real reviewer feedback instead of reusing the same static draft

Invalid pattern:

- a looped-back `CODE` node that tries to recover reviewer comments from imaginary paths like `reviewOutput.feedback`, `reviewOutput.requestChangeMessage`, or `reviewOutput.comments`
- a workflow that claims to support revision feedback but never reads `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`
- a router/extractor loopback that reads `$context.$nodes.<HUMAN_CODE>.$output` instead of `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`

#### Invalid patterns

- Invalid: `loopBackNodeId` is a node code or display name instead of a node id
- Invalid: omitting the channel-matching input payload (`chatChannelInput` for CHAT, `emailChannelInput` for EMAIL, or `approvalProcessInput` for APPROVAL_PROCESS)
- Invalid: emitting `failure`, `reject`, or `timeout` outcomes on the HUMAN node instead of a single `success` path plus runtime-state inspection
- Invalid: creating `Approve`, `Request Changes`, or approval-style outcomes on an approval-off CHAT conversational router loopback
- Invalid: wiring an approval-off CHAT router-loopback with a normal `HUMAN -> ROUTER` success edge instead of `outcomes.success = "end"` plus `metadata.loopBackNodeId`
- Invalid: an approval-off CHAT router-loopback sets `feedbackEnabledFlag = false` while the router/extractor reads `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`
- Invalid: an approval-off CHAT router-loopback includes `metadata.maxIterations`
- Invalid: an approval-off CHAT router-loopback includes `chatChannelInput.requestChangeMessage` or `chatChannelInput.maxIterationsExceededTemplate`
- Invalid: placing a `HUMAN` node inside `LOOP`, `WHILE`, or `PARALLEL`
- Invalid: `chatChannelInput` is emitted as a JSON string
- Invalid: `inputsPatch.chatChannelInput` is emitted as `{ "type": "object", "value": { ... } }` instead of the native payload object
- Invalid: `chatChannelInput.type` is emitted as `string` instead of `object`
- Invalid: `chatChannelInput.value` contains a JSON string like `"{\"messageTemplate\":...}"` instead of a native object
- Invalid: `chatChannelInput.messageTemplate` is a raw string instead of `{ "message": "..." }`
- Invalid: `chatChannelInput.maxIterationsExceededTemplate` is a raw string instead of `{ "message": "..." }`
- Invalid: CHAT `messageTemplate.message` contains line breaks or stored `\n`
- Invalid: feedback-loop logic uses invented Human-node fields instead of `$actionPerformed`, `$feedbackReceived`, and `$iterationsPerformed`
- Invalid: loopback target logic reads `$context.$nodes.<HUMAN_CODE>.$output` for Human follow-up text instead of `$context.$nodes.<HUMAN_CODE>.$feedbackReceived`
- Invalid: `emailChannelInput` is emitted as a JSON string
- Invalid: `inputsPatch.emailChannelInput` is emitted as `{ "type": "object", "value": { ... } }` instead of the native payload object
- Invalid: `emailChannelInput.value` contains a JSON string instead of a native object
- Invalid: EMAIL channel omits `emailAccountId`
- Invalid: placing EMAIL `attachments` inside the individual template objects instead of the top-level `emailChannelInput` object
- Invalid: approval-enabled feedback is enabled but `maxIterations` is omitted
- Invalid: `maxIterations` is zero, negative, fractional, or otherwise non-positive for a feedback loop
- Invalid: EMAIL templates are emitted as plain strings instead of structured template objects
- Invalid: `approvalProcessInput` is emitted as a JSON string
- Invalid: `inputsPatch.approvalProcessInput` is emitted as `{ "type": "object", "value": { ... } }` instead of the native payload object
- Invalid: `approvalProcessInput.approvalRuntimePayload` is emitted as an object or array instead of a string
- Invalid: `approvalProcessInput.attachments` is emitted as `[]` or any non-string value
- Invalid: APPROVAL_PROCESS channel omits `approvalProcessCode`
- Invalid: APPROVAL_PROCESS channel omits `approvalProcessInput`
- Invalid: channel-delivery fields such as `requestChangeMessage`, `timeout`, or `timeoutUnit` are stored in metadata instead of the channel input object
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
