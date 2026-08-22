# Connector Instance CLI Compatibility

Use this reference for configured Connector Instance artifacts.

## Boundary

- Connector Instance `.connectorInstance` artifacts are configured connector records.
- They are always bound to a Connector Definition.
- Reuse existing Connector Definitions before generating a new one unless the user explicitly wants a new definition or no suitable definition exists.

## Reuse-First Flow

1. Run `aistudio search-connector-definitions --query <keyword>` to get top matches.
2. If more than one plausible definition matches and the user did not provide an exact Connector Definition id, show matching `displayOptions` and ask the user to select one.
3. Present options like the connector drawer: `Name: <name>` and `Overview: <overview or description>`.
4. Do not show internal Connector Definition ids unless the user explicitly asks.
5. Treat "starts with" as a prefix match, not a unique selector, unless exactly one returned definition matches that prefix.

## Staged Create Flow

- Before every `aistudio do-create-connector-instance` attempt, run `aistudio prepare-connector-instance-create --connector-definition-id <id> --name <instance-name>` with values already collected.
- Include `--family`, `--product`, `--prefix`, `--user-groups`, `--config-values`, and `--reviewed-optional-config-paths` as they become available.
- Treat the single returned `nextStage` as authoritative: `family`, `product`, `syncFields`, `config`, `optionalConfig`, or `ready`.
- Ask only for the returned stage. Do not combine family/product, sync fields, required config, and optional config in one prompt.
- For `family`, show returned family labels/codes and ask for family.
- For `product`, show returned products for the selected family and ask for product.
- For `syncFields`, show the uppercase max-8 suggested prefix when returned, show user groups as numbered choices by name, keep record ids internal, and require All Users / record id `-5` to be selected alone.
- For `config`, ask only `configQuestion.prompt`. If `choices` exist, show numbered choice labels and ask the user to select by number. Keep `fieldPath` plus choice `value` internal for `configValues`.
- For secret config, warn before collecting the value and never echo secret values.
- For `optionalConfig`, ask only `optionalConfigQuestion.prompt`. If the user accepts a default or skips it, pass its `fieldPath` in `--reviewed-optional-config-paths` on the next prepare call.
- For `ready`, run `aistudio do-create-connector-instance` with reviewed values.

## New Definition Path

- If no suitable Connector Definition exists or the user explicitly wants a new definition, run `aistudio do-generate-connector-definition` first.
- After generation succeeds, take the returned `connectorDefinitionId` and immediately follow the same staged create flow.
- Generation success is only the first step; never ask for auth/config before prepare returns `nextStage=config`.

## Drafts, Secrets, And Save

- For custom/internal content-type definitions that have no connector UI form, `do-create-connector-instance` directly creates the server Connector Instance and best-effort unpublishes the definition. It does not write a local `.connectorInstance` draft.
- For form-backed definitions, `do-create-connector-instance` creates a local draft only.
- If a required config field is marked secret, warn that the value will be stored in the local draft and later sent to the server if the user confirms save. Ask whether they want to provide the secret through CLI now or stop and add it another way.
- If the user provides a secret, include it in `configValues` but do not repeat it in summaries, confirmations, logs, or final responses.
- Prefer `--config-values @file` when the user already has config in a file.
- After creation, read returned `nextPrompt` / `saveCommand`, tell the user the draft path, and ask whether to save it to the server now.
- Use `aistudio do-save-connector-instance --file <connector-instance-file>` only after the user explicitly confirms save/push/persist.
- If save fails with `connectorInstanceSaveFailure`, tell the user the save failed and ask whether to show the redacted payload preview. Only after they agree, run the returned `payloadPreviewCommand`.
- Use `aistudio do-update-connector-instance --file <connector-instance-file> --patch <json>` for local edits.
- Use `aistudio do-fetch-connector-instance` only when the user asks to refresh from the server.
- Use `aistudio do-delete-connector-instance` only when the user explicitly asks to delete the server connector instance; it does not remove the local file.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
