# Policy Store CLI Compatibility

Policy files live under `src/policies/*.policy`, one policy per file. The file content is normalized Policy Store builder JSON, not a wrapper object and not a JSON string.

Prefer CLI commands over hand-editing `.policy` files when the operation is supported:

- `do-create-policy`
- `do-update-policy`
- `validate-policy`
- `do-add-policy-documents`
- `do-remove-policy-document`
- `do-generate-policy-functions`
- `do-create-policy-function`
- `do-modify-policy-function`
- `do-delete-policy-function`
- `do-save-policy`
- `do-publish-policy`
- `do-customize-policy`
- `do-delete-policy`

For document upload, pass a JSON array to `--documents`.

```json
[
  { "path": "./docs/medical-policy.pdf", "description": "Medical policy" },
  {
    "documentId": "doc123",
    "parsedDocumentId": "parsed123",
    "fileName": "already-uploaded.pdf",
    "description": "Existing uploaded policy"
  }
]
```

Local paths are read by the CLI, base64 encoded, uploaded through the document batch endpoint with `parse: true`, and normalized into `metadata.policyDocuments`.

For workflow Policy nodes, prefer:

- `list-policy-node-policies`
- `list-policy-node-functions`
- `do-create-policy-node`
- `do-modify-policy-node`
- `do-delete-policy-node`

Use `--policy-file` for local policy drafts and `--policy-code` for published remote policies. Provide `--inputs` as a JSON object keyed by function parameter name.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
