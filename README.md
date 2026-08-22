### ⚠️ Important Update: Repository Structure and Release Branching

The repository has been **restructured to simplify cloning, pulling updates, and consuming AI Studio and AI Apps skills**. Previously, users had to manually download, extract, and organize the **AI Studio Skills** and **AI Apps Skills** ZIP files. With the new structure, skills,  oracle authored template applications and workflows are organized directly within the repository, eliminating these additional steps.

##### Release Branches

The repository now follows a **release-based branching model**. You will see **`release-26C`** as the current release branch. As new releases become available, a dedicated branch will be created for each release (for example, `release-27A`, `release-27B`, etc.).

##### What This Means for Users

* Use standard **`git clone`** and **`git pull`** operations to access and update AI Studio skills and AI Studio Apps skills.
* Select the **release branch** corresponding to the product release you are using.
* Access AI Studio skill and oracle authored template applications and workflows directly from the **`aiapps`** folder without the previous manual extraction and organization steps.

> **Important:** If you have a local copy based on the previous repository structure, please review the new structure before pulling the latest changes. **Local artifacts created in the `src` folder will not be impacted.**


### Change Log Summary

| **Date**| **Operation** | **File/folder** | **Description**|
|--------------|---------------|---------------|---------------|
| 2026-08-21| Added |`.agents/skills, aiapps` |Directory restructured to support standard `**git clone**` and `**git pull**` operations to obtain the latest skills, applications, and workflow updates.|
| 2026-08-12| Added |`aiapps/scm/inventory` |Added inventory workflows, business objects for item shortage and lot expiry.|
| 2026-08-12| Added |`aiapps/prc/purchasing` |Added workflows, business objects in PRC family related to purchase orders and purchase agreements.|
| 2026-08-12| Updated |`aiapps/scm/cost-management` |Updated workflows, business objects in cost-management to handle no data scenarios.|
| 2026-08-06| Updated |`aistudio-skill.zip` |Added ATLAS (Agentic Testing and Lifecycle Automation Suite) framework - a new agentic testing infrastructure for AI Studio workflows and apps|
| 2026-08-06| Updated |`aistudio-extension.zip` |Added ATLAS (Agentic Testing and Lifecycle Automation Suite) framework - a new agentic testing infrastructure for AI Studio workflows and apps|
| 2026-07-25| Updated |`aistudio-skill.zip` |Updated to resolve authentication issues when connecting to the Fusion environment on the Windows platform|
| 2026-07-25| Updated |`aistudio-extension.zip` |Updated to resolve authentication issues when connecting to the Fusion environment on the Windows platform|
| 2026-07-25| Added |`aiapps/hcm/career-development` | Added career development workflows and business objects|
| 2026-07-25| Updated |`aiapps/hcm/human-resources` | Updated the descriptions and business object code reference in `xx_worker_card.wf`|
| 2026-07-25| Updated |`aiapps/hcm/absences` | Updated the descriptions and workflow `xx_team_upcoming_absences.wf`|
---------------

# Oracle Fusion AI Agent Studio Sample Apps and Workflows

This repository provides samples demonstrating how to use Oracle AI Agent Studio to build apps, workflows, etc.

## Oracle Fusion AI Agent Studio
**Oracle Fusion AI Agent Studio** (often referred to as AI Agent Studio) is Oracle’s primary platform for **building, configuring, and deploying agentic applications** and their underlying specialized agent teams. It serves as the "intelligence layer" of the agentic app framework, providing the tools needed to design how agents reason, analyze data, and generate responses. 

```text
AI Agent Studio is a specialized design-time environment that lets you create, configure, test, and deploy AI agents for your organization.
```

The primary purpose of the Studio is to allow users to create, configure, validate, and deploy agents. It offers a combination of pre-built agent template libraries for common scenarios (such as opportunity-to-quote processing) and extensibility tools to customize agents for specific industry needs.


### Fusion AI Agentic Apps
Oracle’s Agentic Apps, built within the AI Agent Studio, represent a completely new category of enterprise application – one that does not just store your data or present your data, but understands it, prioritizes it, and proactively tells you what to do about it.


The Builder UI is your primary workspace for creating and configuring agentic applications. It is where you choose your app’s pattern, arrange agents on the page, configure prompts, set up communications, and ultimately preview and publish your app. Everything starts here.

In Fusion AI Agent Studio, AI Agents are built using a few key parts that work together to complete business tasks automatically. Teams/Workflows are the step-by-step plans, Agents are the AI workers that perform tasks, Tools connect the agents to fusion (and external) systems and data, Instructions/Prompts control how the agent behaves and responds, Topics define the subject of conversation, and Testing ensures everything works correctly. Together, these components help organizations create smart, automated AI advisors that can talk to users, gather information, make decisions, and take actions efficiently.

#### Key functions and Components
- **Building Agent Teams**: You can create specialized teams using two primary architectures:
  - **Workflow Teams (Recommended):** These use a structured graph of nodes (LLM, Code, Switch) for deterministic processing and predictable latency
- **The App Experience Tab:** This is a critical interface within the Studio where you grant an agent the right to participate in agentic apps. Here, you enable specific output features: 
  - **Enable Actions**: Allows agents to produce actionable insights.
  - **Enable Communications**: Allows agents to suggest outbound messages like emails or Slack notifications
  - **Select Widgets**: Determines which of the seven visual components (e.g., Charts, Sankey diagrams, Tables) the agent is allowed to render

### Fusion AI Workflows aka Agent Teams
In Oracle Fusion AI Agent Studio, Agent Teams are the foundational intelligence units that power agentic applications, while Workflows are the recommended architectural pattern used to build them. It is a specialized group of AI agents built to handle specific domains (such as HR, Finance, or Procurement). 

Agent Teams serve as the "brain" of the application, responsible for reasoning over data, generating insights, and producing the four pillars of the user experience: Information Displays, Actionable Insights, Communications, and Ask Oracle responses.
There are two primary architectures for these teams:
- **Workflow Teams :** These teams use a structured graph of nodes (LLM, Code, Switch, and Agent nodes) to process requests deterministically. They provide the most control over routing and ensure predictable latency, which is critical for meeting the framework's strict 60-second response limit

#### Workflows
A Workflow refers to the specific configuration of nodes that define how an Agent Team responds to the application framework.
Key characteristics of a Workflow include:
- **Message Hint Routing:** The workflow's first node is typically a Switch node that reads the $context.$app.$OraMessageHint variable. This allows the agent to branch its logic based on whether the app is requesting a summary, an initial display, an answer to a query, or an action execution.
- **Node-Based Logic:** Builders chain nodes together to perform complex tasks. For example, a Code node might be used to assemble a prompt, which is then passed to an LLM node for reasoning
- **Explicit Context Passing:** A critical rule of workflows is that user input and chat history are not passed automatically to internal nodes; builders must explicitly wire variables like $context.$system.$inputMessage and $context.$system.$chatHistory into the prompt for downstream LLM or Agent nodes to function correctly
- **Licensing Capabilities:** Within the workflow, builders use the App Experience Tab on LLM or Agent nodes to "license" what that team can produce, such as enabling specific widget types, actions, or communications.


#### Agentic App Builder
The Agentic App Builder (or Builder UI) is the primary workspace within the Oracle Fusion AI framework for creating, configuring, and publishing agentic applications. It is designed as a "no code" visual interface that allows domain experts and solution architects to build intelligent applications without needing a developer for every change. While AI Agent Studio defines what an agent team is capable of doing globally, the Agentic App Builder decides what that team should contribute within a specific application.
**Core Configuration Areas**:
The Builder UI organizes application design into several key functional areas:

- **App Settings:** Builders define the app shell, including its title, subtitle, security roles for access control, and page layout (e.g., asymmetric or multi-column arrangements).

- **Static Agents:** This area handles the top-level "Ask Oracle" and "Summary" slots. Builders can assign dedicated agents to these slots to control the application's unified voice, or rely on the orchestrator to dynamically aggregate insights from all panel agents.

- **Domain Agents:** In the central page pattern, builders arrange specialized agent teams into "slots." Clicking an agent card opens the Agent Editor, where local prompts are written to define exactly how that agent contributes its summary, actionable insights, and initial graphics for this specific app.


- **Integrated Editors:** From the Builder toolbar, you can access the Actions Editor to build reusable multi-step workflows and the Template Editor to design document formats (PowerPoint, PDF, Email, or Text) for outbound communications.


- **Communications List:** On the right panel, builders create communication buttons and link them to templates, designating which agents are allowed to suggest specific outreach

[![Watch the demo](https://img.youtube.com/vi/TDJJLHdBvnY/mqdefault.jpg)](https://www.youtube.com/watch?v=TDJJLHdBvnY)

## Installation 

### How do I install and use Fusion AI Studio with Visual Studio Code (VS Code) and Codex?

Fusion AI Studio provides the tools for building the AI Studio Agentic apps and workflows, while VS Code acts as the workspace where files are created, opened, reviewed, and updated. The Fusion AI Studio VS Code extension adds guided commands and visual editing options so users can complete common tasks from one place. This includes setting up a workspace, connecting to the correct environment, creating new artifacts, opening existing artifacts, and making changes in a structured way.

Codex can also be used as an optional assistant when a task involves several related changes or when users want help creating, reviewing, or updating artifacts. Instead of manually changing each file one by one, users can describe the intended business outcome and ask Codex to help apply the change across the relevant local files. This can be useful when creating an app that depends on workflows, business objects, agents, or other supporting artifacts.

You may need to refer to `install-and-use-fusion-ai-studio-CLI_vscode-codex.md` in the  `how-to` folder for more detail. The guide focuses on the practical steps needed to get started. It explains how to install the required tools, open a workspace, configure access, create or fetch artifacts, and understand the main approaches available for building AI Studio apps and workflows. 

### How to Uptake Incremental Updates for Fusion AI Studio Skills and Samples in Existing Fusion AI Apps Workspaces?

Instructions for upgrading existing Fusion Agentic Apps workspaces with the latest skill versions and sample apps and workflows are available in the `how-to-uptake-incremental-updates` guide, located in the `how-to` folder.


## Fusion AI Studio Artifacts
| Artifact | Plain-language meaning | Typical use |
| --- | --- | --- |
| App | A user-facing workspace with panels, actions, and agents. | Give HR, finance, supply chain, or project users one place to complete AI-assisted work. |
| Workflow | A step-by-step deterministic flow that can call AI, services, code, or approvals. | Fetch data, analyze it, make recommendations, and return results. |
| Business Object | A reusable data connection to Fusion or another service. | Retrieve workers, jobs, plans, invoices, suppliers, or other business records. |
| Agent | A reusable AI worker with a role, tools, and instructions. | Answer domain-specific questions or perform tasks. |
| Tool | A reusable capability for an agent or workflow. | Call a business object, open a deeplink, call REST, or use a connector. |
| Topic | Instructions that guide an agent on a specific subject. | Tell an agent how to answer benefits, succession, payroll, or policy questions. |
| Deeplink | A link definition that opens a target page or record. | Open an employee profile, succession plan, transaction, or work area. |
| Connector Instance | A configured connection to an external connector. | Connect to approved external systems. |

## ATLAS - Agentic Testing and Lifecycle Automation Suite

Fusion AI Studio ATLAS, the Agentic Testing and Lifecycle Automation Suite, helps teams turn important agent scenarios into repeatable, executable tests. Each test combines an input, expected workflow behavior, representative replay data, and evaluation criteria, enabling teams to verify that an agent continues to behave as intended as workflows, prompts, models, and environments evolve. By reducing dependence on changing external data and manual result review, ATLAS provides a consistent foundation for validating agentic workflows throughout development.

ATLAS supports both structural and semantic validation. Teams can confirm required and prohibited workflow paths, verify deterministic outcomes, and apply semantic evaluation to natural-language responses where exact text matching would be too rigid. Tests can be authored from natural-language scenarios, generated or recorded with representative data, organized with tags for different validation scopes, and maintained alongside workflow source. File-based replay keeps external service boundaries stable while routing, conditions, code, and LLM nodes continue to execute, making regressions easier to reproduce, investigate, and resolve without requiring every test run to recreate the same external conditions manually.

ATLAS integrates with local development and CI/CD workflows, allowing tests to run individually or as suites and producing reports that capture results, evaluated outputs, warnings, token usage, and execution duration. Labeled runs support consistent baseline and candidate-model comparisons, while optimization sweeps evaluate model placement at the individual LLM-node level using quality, latency, and usage evidence. Reports can be retained as reviewable engineering artifacts and incorporated into existing test pipelines and quality dashboards. Together, these capabilities help teams detect regressions earlier, compare changes using consistent evidence, improve model selection, and maintain reliable quality across Fusion AI agents as workflows and application experiences continue to evolve across release cycles.


## Documentation

You can find the online documentation for Oracle Fusion AI Agent Studio at [official documentation](https://docs.oracle.com/en/cloud/saas/fusion-ai/) and information about the project at [Oracle Fusion AI](https://www.oracle.com/in/applications/fusion-ai/).

### Change Log Details

##### 21th Aug 2026
-----
The repository has been **restructured to simplify cloning, pulling updates, and consuming AI Studio and AI Apps skills**. Previously, users had to manually download, extract, and organize the **AI Studio Skills** and **AI Apps Skills** ZIP files. With the new structure, skills,  oracle authored template applications and workflows are organized directly within the repository, eliminating these additional steps.

###### What Changed?

Previously, users had to perform additional manual steps after downloading or cloning the repository, including extracting and organizing the AI Studio Skills and AI Apps Skills ZIP files into the required directory structure.To eliminate these manual steps, the repository has now been restructured so that the required oracle authored skills and sample applications, and workflows are available directly in their expected locations.

In addition, the repository now follows a release-based branching model.

###### Release Branches

You will now see release-26C as the current release branch. Going forward, as additional releases become available, a dedicated branch will be created for each release (for example, release-27A, release-27B, and so on).

This approach makes it easier to:
- Identify the repository content associated with a specific product release.
- Pull updates for the release you are currently using.
- Maintain a clear separation between different release versions.

###### Why Was This Change Made?

The primary goal of this restructuring is to provide a simpler, more consistent, and maintainable repository experience. Users can now clone the appropriate release branch once and subsequently use git pull to receive updates, without repeatedly downloading ZIP files, extracting their contents, and manually placing files into the required directories.

##### 12th Aug 2026
-----
Added inventory workflows, business objects for item shortage and lot expiry in folder `aiapps/scm/inventory` 

- Workflows : Inventory Item Shortage Monitor, Inventory Item Stockout Monitor Workflows
- Business Objects : Expiring Inventory Lots, Items Awaiting Inspection, Item Stockout Subinventory Locations, Transfer Lots to Subinventory

Added workflows, business objects in PRC family related to purchase orders and purchase agreements in folder `aiapps/prc/purchasing`

- Workflows : Compliance Checklists, My Recent Requisitions, Purchase Agrements,Purchase Orders Purchase Order Status Distribution,Purchase Agreement Status Distribution
- Business Objects : Compliance Checklist, Purchase Agreements, Purchase Orders, My Requisitions

Updated workflows, business objects in cost-management to handle no data scenarios in folder `aiapps/scm/cost-management`
- Workflows : Inventory Valuation Comparision Advisor, Period Validation Exceptions Advisor

Updated succession planning agentic app and supporting workflow to fix bugs while adding potential successor in folder `aiapps/hcm/succession-management`
- Application : Person Succession Readiness Workspace
- Workflows : Succession Overview Advisor, Succession Overview Agent Team
- Business Object : Direct Reports Context

##### 6th Aug 2026
-----
Added ATLAS (Agentic Testing and Lifecycle Automation Suite) framework - a new agentic testing infrastructure for AI Studio workflows and apps in `aistudio-skill.zip`, `aistudio-extension.zip`

Fusion AI Studio ATLAS—the Agentic Testing and Lifecycle Automation Suite—enables teams to transform critical agent scenarios into repeatable, executable tests. Each test brings together an input, expected workflow behavior, representative replay data, and evaluation criteria to verify that agents continue to perform as intended as prompts, models, workflows, and environments evolve. By minimizing reliance on dynamic external data and manual result validation, ATLAS provides a reliable and consistent foundation for testing and validating agentic workflows throughout the development lifecycle.

ATLAS enables both structural and semantic validation of agentic workflows. Teams can verify required or prohibited execution paths, validate deterministic outcomes, and use semantic evaluation for natural-language responses where exact text matching may be overly restrictive. Tests can be created from natural-language scenarios, generated or recorded using representative data, tagged for different validation scopes, and maintained alongside workflow source code. File-based replay provides consistent external service boundaries while allowing routing, conditions, code, and LLM nodes to execute normally. This makes regressions more reproducible and easier to diagnose and resolve, without requiring each test run to manually recreate the same external conditions.

ATLAS integrates seamlessly with local development and CI/CD workflows, enabling teams to execute individual tests or complete test suites and generate detailed reports covering results, evaluated outputs, warnings, token usage, and execution time. Labeled runs provide a consistent basis for comparing baselines with candidate models, while optimization sweeps assess model selection at the individual LLM-node level using evidence across quality, latency, and usage. Reports can be preserved as reviewable engineering artifacts and integrated into existing test pipelines and quality dashboards. Together, these capabilities enable teams to identify regressions earlier, evaluate changes against consistent evidence, optimize model selection, and sustain reliable quality across Fusion AI agents as workflows and application experiences evolve from one release cycle to the next.

##### 25th July 2026
-----
Updated skill in `aistudio-skill.zip`, `aistudio-extension.zip` to resolve authentication issues when connecting to the Fusion environment on the Windows platform

Added workflows, business objects in HCM family related to career development in folders `aiapps/hcm/career-development`,`aiapps/hcm/journeys`,`aiapps/hcm/learning` 

- Workflows : My Career Development Tasks, My Current Learning, My Self Developing Skills
- Business Objects : Career development skills lookup, Career Development Tasks, Learning Searches

Updated descriptions and business object code reference in below workflows
-  `aiapps/hcm/human-resources/xx_worker_card.wf` 
-  `aiapps/hcm/absences/xx_team_upcoming_absences.wf`

## Contributing

This project do not accept external pull requests. Please [review our contribution guide](./CONTRIBUTING.md)

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process

## License

Copyright © 2026, Oracle and/or its affiliates.  Licensed under the Universal Permissive License (UPL), Version 1.0 as shown at https://oss.oracle.com/licenses/upl/

## Disclaimer

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY.  IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
