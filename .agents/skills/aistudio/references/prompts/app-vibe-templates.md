# Templates (App Builder)

This section defines how **templates** work in the Agentic App Framework app specification, and how to safely add/modify/delete them.

## What a template is

A template is a reusable artifact definition (email/text/docx/pdf/ppt/podcast) that can be used by **communications** and runtime generation flows.

Templates live at:

- `appConfig.templates: Template[]`

Each template has:

- `id` (string, required): stable internal identifier (used for references such as `communication.templateId`).
- `name` (string, required): user-facing name shown in the UI.
- `type` (required): one of `ppt | docx | pdf | email | text | podcast`.

Optional fields:

- `parts?: TemplatePart[]` (multi-part templates; most relevant for `ppt`, but can be used for others depending on implementation)
- `formatMetadata?: string`
- `formatMetadataSource?: string`
- `metadataLookupId?: string`
- `headline?: string`
- `recipient?: string`
- `cc?: string`
- `recipientIsAutoFilled?: boolean`
- `podcastHosts?: Array<{ id: string; name: string; voice: string }>` (podcast templates)

## Template parts

`TemplatePart` is a sub-unit of a template:

- `id` (string, required): stable internal identifier for the part.
- `generationInstructions` (string, required): what content to generate.
- `presentationInstructions` (string, required): how to present/format it.
- `presentationType?` (string): optional type hint.
- `useStaticContent?` (boolean): for email sections, when true the section uses literal content instead of generated content.
- `staticContent?` (string): literal content for the section when `useStaticContent` is `true`.
- `editable?` (boolean): whether users can edit this section; for email sections this should default to `true`.
- `title?` (string): optional part title.
- `hostId?` (string): optional podcast host id for this part (podcast templates).

In the Template Builder UI, template parts are often referred to as **sections**.

## Safety rules (references)

- Communications can reference templates via `communication.templateId`.
- When deleting a template:
  - First find and update/remove any communications that reference it (or explicitly allow dangling references if the user requests that behavior).
  - Never silently break references.

## When to use which tool

- **Inspect** a template: fetch it by id.
- **Add** a template: create a new entry in `appConfig.templates`.
- **Modify** a template: patch an existing entry in `appConfig.templates`.
- **Remove** a template: remove an existing entry from `appConfig.templates` (refuse if referenced unless explicitly overridden).

## Behavioral defaults

- Prefer editing the template the user is currently looking at (if a template is selected in the UI).
- In app-authoring contexts, interpret requests to create/generate/build a PPT or PowerPoint as requests to create a `ppt` template, not as requests to generate a `.pptx` file directly.
- In app-authoring contexts, interpret requests to create/generate/build a DOCX or Word document as requests to create a `docx` template, not as requests to generate a `.docx` file directly.
- For PPT templates, keep part instructions slide-safe: prefer additional concise slides over dense slides, keep titles under about 10 words, keep bulleted slides to about 5 short bullets, keep paragraph slides concise, and summarize large datasets instead of requesting raw tables or long lists.
- For DOCX templates backed by an uploaded file, each `parts[*].id` maps to a DOCX placeholder key. Preserve those ids exactly; generation uses them as the `/template/docx` input keys.
- If the user asks to “rename the template” or “change the template name/title”, change `template.name` (not the app title).
- Template ids should be stable. Avoid changing `template.id` unless the user explicitly asks and you also update all references.
- Do not leave a newly built template unreferenced: create or update a matching `appConfig.communications` entry with `templateId` pointing at the template, unless the user explicitly asks for a template-only draft.
- The matching communication's `applicableAgent` must use configured agent code(s) whose content/responsibilities match the requested template content.
- For template-backed communications, fillable inputs come from the referenced template, not from the communication's `parameters` array. For PPT and DOCX templates, each `parts[*]` entry is filled by `FillParameters` using the part `id`.
- If the template has fillable parts, verify or update the backing workflow for the communication's applicable agent code(s) so its `FillParameters` path fills those template part ids from the requested content/context.

## Modifying sections (parts) without overwriting

Be careful: editing `template.parts` can accidentally overwrite the whole sections list.

- If you call `do-modify-template` with `patch.parts` as an **array**, it **replaces** the entire parts list.
- To **add a new section** without overwriting existing ones, use:
  - `patch.parts: { mode: "append", parts: [...] }`
- To **update a specific existing section** (by `part.id`) or add if it doesn’t exist:
  - `patch.parts: { mode: "upsert", parts: [...] }`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
