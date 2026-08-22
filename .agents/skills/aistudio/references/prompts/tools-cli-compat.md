# Tools CLI Compatibility

- Users may describe the Tool they want in natural language; do not require `.tool` wording before using Tool CLI commands.
- Use `aistudio do-create-tool --tool-type ...` only when the target artifact is a Tool under `src/tools/*.tool`; it does not create Business Object `.bo` files, Deeplink `.dl` files, or workflow nodes.
- If the user asks for a "tool node" or to add/call/use a tool in a workflow, switch to workflow node authoring instead of creating a `.tool` draft.
- For "business object tool" or "BO tool" requests, run `aistudio do-create-tool --tool-type business-object`; do not run `aistudio do-create-bo` unless the user separately asks to create the source Business Object.
- Use `aistudio do-create-tool --tool-type <type>` as the creation entrypoint for local Tool drafts. For example, use `aistudio do-create-tool --tool-type business-object` for a Business Object Tool and `aistudio do-create-tool --tool-type external-rest` for an External REST Tool.
- Separate Tool discovery from Tool creation. Discovery commands such as `list-supported-business-objects`, `list-deep-links`, `list-km-connectors`, and `list-km-connector-tools` may require `env.properties` and network access, but `do-create-tool --tool-type business-object` is local-only once `supportedObjectId`, `objectCode`, and `functions` are known.
- Do not request approval/escalation merely because `do-create-tool --tool-type business-object` writes a local `.tool` file. Treat that local write like `do-create-bo`, `do-create-topic`, `do-create-deeplink`, and other local artifact creation commands.
- Accepted `--tool-type` values are `business-object`, `deep-link`, `document`, `email`, `external-rest`, `mcp`, and `connector`. Uppercase enum values are also accepted: `BUSINESS_OBJECT`, `DEEP_LINK`, `DOCUMENT`, `EMAIL`, `EXTERNAL_REST`, `MCP`, and `CONNECTOR`.
- Local Tool files live under `src/tools/*.tool`, one Tool per file.
- Do not hand-edit `.tool` files when a CLI command supports the requested operation. Use `do-update-tool` for local metadata or parsed child-collection changes.
- Do not add authentication, secrets, API keys, passwords, client secrets, private keys, Authorization headers, MCP credential ids, or External REST non-`none` auth through CLI.
- External REST CLI drafts use `specification.externalRestMetadata.authInfo.type = "none"`. MCP CLI drafts use `credentialType = "none"` and an empty `credentialId`.
- Use `list-supported-business-objects`, `list-deep-links`, `list-km-connectors`, and `list-km-connector-tools` to discover existing references before creating the matching Tool draft when exact ids or function/tool names are not already known.
- Business Object tool and Deep Link Tool creation can infer `--family` and `--product` from the selected source when the CLI can resolve it. Do not override those values with a different family/product; the CLI stops with a warning because the builder selection may be cleared.
- Document, Email, External REST, MCP, and Connector Tool creation still require explicit `--family` and `--product` values.
- Creating a Deep Link Tool references an existing deep link. The tool displays the selected deep link message as read-only; do not pass or patch a message on the Deep Link Tool. Creating or editing the deep link itself stays in the `do-create-deeplink` / `.dl` flow.
- Document Tool CLI creation supports metadata, existing uploaded `documentId` attachments, and local file uploads through `--documents` entries with `filePath` or `localFilePath`. Document `status` may be `DRAFT`, `READY_TO_PUBLISH`, `READY_TO_DELETE`, `PUBLISHED`, or `DELETED`; local files upload during create, while `do-save-tool` persists metadata and starts indexing only for documents marked `READY_TO_PUBLISH` or `READY_TO_DELETE`.
- Email Tool CLI creation supports `HCM_EMAIL` and `HCM_ALERTS`; missing option, object, and template codes are generated as stable local defaults.
- After material Tool changes, run `aistudio validate-tool --file <tool-file>` and fix reported issues.
- Run `aistudio do-save-tool --file <tool-file>` only when the user explicitly asks to persist the Tool remotely.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
