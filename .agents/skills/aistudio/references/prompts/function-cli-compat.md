# Function CLI Compatibility

- Prefer `aistudio do-create-function` to create a local Function Template draft under `src/functions`.
- Function files live under `src/functions/*.function`, one Function Template per file.
- Local `.function` files store normalized Function Template JSON directly, not a wrapper and not a JSON string.
- Prefer `aistudio do-update-function`, function-definition CRUD, test-case CRUD, and run commands instead of hand-editing `.function` files.
- Prefer `aistudio do-add-function-documents` for document metadata and local path uploads. Local path entries upload through the document batch endpoint with `parse: true`; every local path entry must include a description.
- Use `aistudio do-generate-function-implementation` after a function definition exists. Uploaded parsed documents and the optional prompt can guide generation.
- Use `aistudio do-generate-function-test-cases` after JavaScript is present.
- Use `aistudio do-create-function-node`, `aistudio do-modify-function-node`, and `aistudio do-delete-function-node` for workflow reusable-function `CODE` nodes instead of hand-writing node metadata and inputs.
- For workflow nodes, use `--function-file` for local Function Templates and `--function-template-code` for published remote Function Templates.
- If a Function Template has one function, use it. If it has multiple functions and the user did not specify one, ask which function to use.
- Use `aistudio validate-function --file <function-file>` after material local changes.
- Use `aistudio do-save-function --file <function-file>` and `aistudio do-publish-function --file <function-file>` only when the user explicitly asks to save or publish.
- Upload, generation, list/get, save, publish, customize, remote delete, and remote workflow function lookup require `env.properties`. Local create/update/validate/function-definition CRUD/test-case CRUD/run commands do not.
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
