# Connector Definition CLI Compatibility

Use this reference for Connector Definition artifacts generated from OpenAPI or MCP specs.

## Creation

- Use `aistudio do-generate-connector-definition` as the public creation command.
- Generation calls the same server-backed `/api/ci/v2/connectorDefinitions/generate` API used by the Connector Definition UI, then fetches detail and writes a local `.connectorDefinition` file with returned server IDs.
- Use `--spec-file`, `--spec-content`, `--spec-url`, `--mcp-instance-url`, or `--payload` to build the backend generate payload.
- Use `--payload @file` when you need the exact UI/backend request shape.
- `do-generate-connector-definition` supports `--args` JSON for Codex/tool callers. Use command help as the source of truth for supported options.
- Do not use unsupported stop-gap generation flags.

## Failure Handling

- If backend generation, DNS, or network access fails before a `connectorDefinitionId` is returned, retry once with `--verbose`.
- Then report the redacted route, resolved URL, auth mode, failure stage, and curl-style command.
- If the server returns a clear HTTP validation error, report it without retrying.
- If generation returned `message`, `connectorDefinitionId`, `connectorDefinitionVersionId`, or `connectorInfoVersionId` but the later detail fetch failed, do not run generation again.
- In that partial-success case, use `aistudio do-fetch-connector-definition --connector-definition-id <id> --verbose` to retry the GET and report redacted diagnostics.
- Do not manually assemble a local `.connectorDefinition` as a substitute for server creation.

## Lifecycle

- Generated Connector Definition files live under `src/connectorDefinitions/*.connectorDefinition` by default and should include server IDs after successful generation.
- Use `aistudio validate-connector-definition --file <connector-definition-file>` after material local changes.
- Use `aistudio do-save-connector-definition` only to PATCH editable fields for an existing server Connector Definition from a local file. It is not the required second step after successful generation.
- Use `aistudio do-publish-connector-definition` and `aistudio do-unpublish-connector-definition` only when the user explicitly asks to change lifecycle state.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
