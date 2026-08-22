### External REST

- Backend `type`: `EXTERNAL_REST`
- **Metadata:** `externalRestToolCode` (selected tool), `functionName` (selected endpoint/function)
- **Inputs:** One input per token parameter for the selected endpoint
- **Output:** `outputSpecification` (editable JSON schema string)

#### Structure

- A valid `EXTERNAL_REST` node must include:
  - `metadata.externalRestToolCode`
  - `metadata.functionName`
  - outer `outcomes.success`
- `family` and `product` are selection filters in the editor. They help locate the external REST tool, but they are not part of the persisted `EXTERNAL_REST` node metadata contract.
- `metadata.externalRestToolCode` must point to the selected preconfigured external REST tool definition.
- `metadata.functionName` must point to a real endpoint/function from that selected tool's specification.
- Node inputs should correspond only to token parameters (`isToken === true`) for the selected endpoint.

#### Authoring rules

- Use `EXTERNAL_REST` for preconfigured third-party or external REST integrations, not for Oracle business object calls.
- If the requirement is really an Oracle business object function call, use `BO_FUNCTION` instead of `EXTERNAL_REST`.
- Do not guess `externalRestToolCode` or `functionName`. Use the selected tool and the selected endpoint from that tool.
- After changing `externalRestToolCode`, clear or replace the previous `functionName`; functions are tool-specific.
- After changing `functionName`, do not retain stale inputs from the previous endpoint. The node inputs should match the currently selected endpoint's token parameters only.
- Do not invent extra input names that are not real token parameters of the selected endpoint.
- When using `do-create-node` or `do-modify-node`, each `inputsPatch.<parameterName>` value must be the final parameter value itself, not a nested input-entry object with `id`, `name`, `type`, or `value`.
- Preserve the parameter type expected by the selected endpoint when authoring each input.
- Use the normal outer `success` outcome for the forward execution path. Do not invent a mandatory `failure` outcome rule if the workflow does not already require one.

#### Output schema contract

- `EXTERNAL_REST` nodes have an editable `outputSpecification`.
- Any downstream reference under `$context.$nodes.<EXTERNAL_REST_CODE>.$output...` must resolve to a real field path in that schema.
- Do not invent response fields in downstream expressions unless they are declared in `outputSpecification`.
- If downstream nodes need field-level access to the REST response, update `outputSpecification` to match the intended response shape in the same pass.

#### Invalid patterns

- Invalid: omitting `metadata.externalRestToolCode`
- Invalid: omitting `metadata.functionName`
- Invalid: persisting editor filter values such as `family` or `product` as if they were required `EXTERNAL_REST` node metadata
- Invalid: leaving stale endpoint inputs from a previous function after the node's `functionName` changes
- Invalid: keeping a stale `functionName` after switching to a different external REST tool
- Invalid: inventing input names that are not real token parameters of the selected endpoint
- Invalid: using nested input objects or full input-entry objects in `inputsPatch` for endpoint parameters
- Invalid: inventing a mandatory normal `failure` outcome for `EXTERNAL_REST`
- Invalid: using `EXTERNAL_REST` for a BO operation that should be modeled as `BO_FUNCTION`
- Invalid: referencing downstream `$output` fields that are not declared in the node's effective `outputSpecification`

#### Example

User request:
- "Call an external weather API tool with a city parameter, then summarize the returned forecast."

Expected structure:
- `CALL_WEATHER_API.type = EXTERNAL_REST`
- `CALL_WEATHER_API.metadata.externalRestToolCode = <real selected external REST tool code>`
- `CALL_WEATHER_API.metadata.functionName = <real selected endpoint name for that tool>`
- `CALL_WEATHER_API.inputs` contains only the token parameters defined by that selected endpoint
- `CALL_WEATHER_API.inputs.city = {{$context.$nodes.PREPARE_LOCATION.$output.result.city}}`
- `CALL_WEATHER_API.outcomes.success = SUMMARIZE_FORECAST`
- `CALL_WEATHER_API.outputSpecification` declares the response fields that downstream expressions will reference

Invalid examples:

- Invalid: `CALL_WEATHER_API.metadata.externalRestToolCode = WEATHER_TOOL` but `metadata.functionName` still points to a function from a previously selected tool
- Invalid: `CALL_WEATHER_API.inputs.apiKey = ...` when `apiKey` is not a real token parameter of the selected endpoint
- Invalid: `inputsPatch.city = { "type": "string", "value": "London" }`
- Invalid: `CALL_WEATHER_API.outcomes.failure = HANDLE_REST_FAILURE`
<!-- Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl -->
