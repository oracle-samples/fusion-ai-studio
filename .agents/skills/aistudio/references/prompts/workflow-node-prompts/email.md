### Email

- Backend `type`: `EMAIL`
- **Inputs:** `toList`, `ccList`, `subject`, `body`, `attachments`
- Use `EMAIL` when the workflow should send an email notification or email-based message to recipients.
- A valid `EMAIL` node must include:
  - an input named `toList`
  - an input named `subject`
  - an input named `body`
  - outer `outcomes.success`

#### Structure

- `toList`, `ccList`, `subject`, `body`, and `attachments` are normal node inputs.
- In the workflow spec, each of those inputs should be stored as `type: "string"` with a string `value`.
- When using `do-create-node` or `do-modify-node`, set `inputsPatch.toList`, `inputsPatch.ccList`, `inputsPatch.subject`, `inputsPatch.body`, and `inputsPatch.attachments` to raw string values.
- Do not pass nested input objects such as `{ "type": "string", "value": "..." }` for any EMAIL input.
- Do not pass full input objects such as `{ "id": "...", "name": "subject", "type": "string", "value": "..." }`.
- `toList` is required and should contain the recipient list or an expression that resolves to it.
- `ccList` is optional.
- `subject` is required and should be authored as a single-line string input.
- `body` is required and may be multiline.
- `attachments` is optional and should still be authored as a string-backed input in this workflow builder implementation.
- `outcomes.success` is required and must point to the next node after the email is sent.
- If error handling is needed, use the shared `metadata.errorNodeId` pattern. Do not invent a normal `failure` outcome for EMAIL delivery.

#### Authoring rules

- Keep `toList` focused on the actual recipients, whether literal addresses or expression-driven addresses.
- Use `subject` for a concise subject line, not a long message body.
- Put the full email message content in `body`, not in `subject`.
- `body` may contain real line breaks when the email should render as multiple lines or paragraphs.
- Do not store broken escaped body text that would render literal `\\n` instead of actual line breaks unless the user literally wants backslash characters in the email content.
- If the email content depends on upstream workflow data, inject that data explicitly with normal workflow expressions.
- If attachments are not needed, omit `attachments` or leave it as an empty string rather than inventing a different payload shape.

#### Invalid patterns

- Invalid: omitting the required `toList` input
- Invalid: omitting the required `subject` input
- Invalid: omitting the required `body` input
- Invalid: authoring any EMAIL input as a non-string input type
- Invalid: setting any `inputsPatch.<emailInput>` value to a nested input object instead of the raw string value
- Invalid: using full input-entry objects in `inputsPatch`
- Invalid: inventing a normal `failure` outcome on the EMAIL node instead of using `success` plus optional `metadata.errorNodeId`
- Invalid: putting the whole email message into `subject` and leaving `body` empty
- Invalid: treating `attachments` as an object payload in this workflow builder implementation

#### Example

User request:
- "Send an approval email to the manager, copy HR, and include the request summary in the body."

Expected structure:
- `SEND_APPROVAL_EMAIL.type = EMAIL`
- `SEND_APPROVAL_EMAIL.inputs.toList.type = string`
- `SEND_APPROVAL_EMAIL.inputs.toList = {{$context.$nodes.GET_MANAGER.$output.email}}`
- `SEND_APPROVAL_EMAIL.inputs.ccList.type = string`
- `SEND_APPROVAL_EMAIL.inputs.ccList = hr@company.com`
- `SEND_APPROVAL_EMAIL.inputs.subject.type = string`
- `SEND_APPROVAL_EMAIL.inputs.subject = Approval required for request {{$context.$workflow.requestId}}`
- `SEND_APPROVAL_EMAIL.inputs.body.type = string`
- `SEND_APPROVAL_EMAIL.inputs.body = Please review request {{$context.$workflow.requestId}}.\n\nSummary: {{$context.$nodes.PREPARE_EMAIL_SUMMARY.$output.result.summary}}`
- `SEND_APPROVAL_EMAIL.outcomes.success = NEXT_NODE`

Invalid examples:

- Invalid: `inputsPatch.subject = { "type": "string", "value": "Approval required" }`
- Invalid: `inputsPatch.body = { "id": "x", "name": "body", "type": "string", "value": "Please review." }`
- Invalid: `SEND_APPROVAL_EMAIL.inputs.attachments = { "files": ["doc1.pdf"] }`
- Invalid: `SEND_APPROVAL_EMAIL.outcomes.failure = HANDLE_EMAIL_FAILURE`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
