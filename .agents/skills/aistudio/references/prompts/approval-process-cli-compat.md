# CLI Compatibility

The approval-process builder prompt is authored for the builder UI. When it is used from the bundled AI Studio prompt references, apply these CLI-specific overrides.

- In CLI mode, the target draft is the local `.approval` file passed with `--file`, not the currently open draft in the details view.
- In CLI mode, prefer file-oriented guidance over builder UI language such as "open the details view", "inspect the current draft", or "mutate the currently focused draft".
- `aistudio get-approval-process --code <approvalProcessCode>` is a remote read-only lookup for workflow HUMAN approval-node authoring. It is not the UI draft-inspection tool and is not a prerequisite before local approval-process mutations.
- Approval-process mutation commands operate on local `.approval` files with `aistudio <command> --file <approval-process-file> ...`.
- CLI flags map directly to tool arguments using kebab-case names.
- For object and array arguments, pass JSON inline or use `@path/to/file.json`.
- Prefer `@file` JSON input for nested payload schema, rule `criteria`, and `routeUsing` updates instead of hand-escaping large inline JSON blobs.
- Use `--dry-run` only when the user explicitly wants an exact file diff preview before writing.
- Do not run mutating approval-process commands in parallel against the same `.approval` file. Apply them serially and treat the updated file as the source of truth after each step.
- Use `aistudio do-save-approval-process --file <approval-process-file>` only when the user explicitly asks to persist the approval process remotely. It checks the server by `moduleIdentifier` first, then checks identifier uniqueness only when that lookup misses, and creates only when the identifier is unique.
- If save returns `conflictType: "existing-remote"` or `conflictType: "duplicate-create"`, ask the user whether to fetch the existing approval process and update it instead. Only after the user says yes, rerun the same save with `--allow-conflict-update`.
- If save returns `conflictType: "duplicate-unavailable"`, ask the user for a different `moduleIdentifier`; do not invent a replacement code automatically.
- Use `aistudio do-fetch-approval-process --code <moduleIdentifier>` only when the user explicitly asks to fetch, pull, load, or refresh an approval process from the server.
- A top-level `.approval` `processId` is tolerated only for legacy local files. CLI create/modify/fetch/save normalization strips it; saves check existence by `moduleIdentifier` and never send `processId` in create/update payloads.
- Do not hand-edit the `.approval` JSON when the CLI already supports the operation.

UI-to-CLI command mapping:

- UI builder-agent `do-update-approval-process` is a draft-mutation tool, not CLI remote persistence. Map it to the local CLI mutation commands below, and use `aistudio do-save-approval-process` only when the user asks to persist remotely.
- UI `do-update-approval-process` top-level metadata updates -> `aistudio do-modify-approval-process`
- UI `do-update-approval-process` full payload replacement -> `aistudio do-create-approval-payload`
- UI `do-update-approval-process` payload leaf add/replace -> `aistudio do-create-approval-attribute` / `aistudio do-modify-approval-attribute`
- UI `do-update-approval-process` approver routing updates -> `aistudio do-modify-approver-type`
- UI `do-update-approval-process` notification channel updates -> `aistudio do-modify-notification-channel`
- UI `do-update-approval-process` email account updates -> `aistudio do-modify-email-account`
- UI `do-update-approval-process` rule add/replace/delete -> `aistudio do-create-approval-rule` / `aistudio do-modify-approval-rule` / `aistudio do-delete-approval-rule`
- UI `validate-approval-process` -> `aistudio validate-approval-process`
- UI `search-approval-users` -> `aistudio search-approval-users --query <text>`
- UI `get-approval-email-account-options` -> `aistudio list-approval-email-accounts [--query <text>]`
- UI `get-management-hierarchy-starts-with-options` -> `aistudio list-approval-management-hierarchy-starts-with [--query <text>] [--code <approvalProcessCode>]`
- UI `get-manager-type-options` -> `aistudio list-approval-manager-types [--query <text>]`
- UI `get-representative-type-options` -> `aistudio list-approval-representative-types [--query <text>]`

CLI gaps relative to the UI builder tools:

- The CLI still does not provide a direct equivalent for `generate-approval-conditions`.
- In CLI mode, use the CLI lookup commands first for users, email accounts, manager types, representative types, and management hierarchy `startWith`, then pass the returned values exactly into the subsequent mutation command.
- In CLI mode, ask the user for exact rule criteria when they are not already specified instead of guessing or inventing them.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
