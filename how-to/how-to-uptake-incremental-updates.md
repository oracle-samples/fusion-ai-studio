# How to uptake incremental updates to existing Fusion AI Apps workspaces?

This guide explains how to upgrade an existing Fusion App workspace with new versions of skills and sample applications are published in the GitHub repository.

## Contents

1. [Steps to update Fusion AI Studio artefacts](#steps-to-update-fusion-ai-studio-artifacts)
2. [Download or clone the latest repo](#download-or-clone-the-latest-repo)  

A Fusion App workspace typically contains the following folders:

```text
fusion-ai-workspace/
└── aiapps/
└── extensions/
└── how-to/
└── .agents/
    └── skills/
        └── <list-of-aistudio-apps-domain-skills>
        └── aistudio/
└── src/
```

| Folder  | Artifacts   | Impact  | 
|---------|-------------|----------|
|`aiapps`|  Sample apps, workflows, and other artifacts|Updated automatically to the latest version on repository download or pull|
|`.agents/skills/aistudio/`|  Hosts the Fusion AI Studio skill|Updated automatically to the latest version on repository download or pull|
|`.agents/skills/<list-of-ai-apps-domain-skills>`|  Multiple directories of domain-specific skills|Updated automatically to the latest version on repository download or pull|
|`src` or `app-pkg`|  Local artifacts created during the app/workflow building process. |This directory will not be present when the repository is pulled or downloaded. This gets created when you start building. |

## Steps to update Fusion AI Studio Artifacts

### For the Current Release

To get any updates to sample apps or bundled skills in the current release cycle:

1. Open the workspace folder in a Terminal.
2. Run the command `git pull`
3. Resolve merge conflicts (if any) before continuing

After a successful pull, the current branch contains latest updates to the existing AI Studio artefacts.

### For a New Release

When a new release is published, identify the branch name specified for that release before updating. There are three approaches to get the updates:

#### Option 1. Create a new workspace

To use a new release in a separate workspace, clone the repository (as per instructions above) into a new folder. The latest release is set as the default branch.

#### Option 2. Upgrade to Latest Release Branch
If you wish to get the latest release branch in the existing cloned repository:
1. Run `git fetch origin`.
2. Run `git branch -a` to view all branches.
3. Switch to the latest release branch by running `git switch <branch-name>`.
4. Run the command `git pull`.

#### Option 3. Upgrade Existing Branch By Merging with Latest Release Branch

If you wish to use the existing branch then:
1. Open the workspace folder in a Terminal.
2. Run the command `git pull origin <branch-name>`.
3. Resolve merge conflicts.
4. The current workspace will now have the artefacts from the latest release.

## Download or clone the latest repo

The latest repository can either be downloaded as a ZIP file and extracted, or cloned from [GitHub](https://github.com/oracle/fusion-ai-studio).

#### Download as ZIP 
To download the repository as a ZIP file:

1. Open the GitHub link in your browser and click **Code**.
2. Click **Download ZIP**.
3. Extract the downloaded ZIP file to an easy-to-find location.
4. On Windows, select **Extract All...**.
5. On macOS, select **Open With > Archive Utility** or double-click the ZIP file.
6. The extracted folder name depends on the branch or release you downloaded; use the folder created by the extraction.
7. Confirm that a folder named similarly to `fusion-ai-studio-<release>` is present. 
8. Open the extracted folder.

#### Clone GitHub Repository 
If you prefer to clone the repository instead of downloading it as a ZIP file, follow the steps below.

To clone the repository, ensure that Git is installed on your system. Refer to this [guide](https://github.com/git-guides/install-git) for installation instructions. Once Git is installed, you can clone the repository using the following steps:

1. Open the GitHub link in your browser and click **Code**.
2. Copy the link similar to `https://github.com/oracle/fusion-ai-studio.git` (mentioned above under *Clone using the web URL*).
3. Create a folder named `fusion-ai-repo` in an easy-to-find location.
4. Open a terminal and enter the following command inside the `fusion-ai-repo` folder.
   
   ```bash
   git clone https://github.com/oracle/fusion-ai-studio.git
   ```

5. The repository will be cloned into your current `fusion-ai-repo` folder.
6. Confirm that it now contains a folder named `fusion-ai-studio`.

## Disclaimer

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY.  IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
