{
  "_comment": "Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl",
  "id": "300100649745688",
  "name": "Attrition Analysis",
  "code": "XX_ATTRITION_ANALYSIS",
  "version": 1,
  "status": "DRAFT",
  "internalName": "Attrition Analysis",
  "internalDescription": "Provides an attrition analysis workspace for Managers/HR to review recent leaver trends by manager, job, reason, tenure, and location, view summary metrics, drill into related employee details, and export results to PDF.",
  "specification": {
    "applicationMetadata": {
      "title": "Attrition Analysis",
      "pagePattern": "swimlanesPattern",
      "pageConfig": {
        "agentContainers": [
          {
            "id": "container-1775638561146",
            "title": "Top Leavers by Reason",
            "agents": [
              "agent-1775638561146"
            ],
            "additionalPanels": [
              {
                "name": "LeaversByReason",
                "heading": "Leavers By Reason",
                "agent": "XX_TOP_LEAVERS_BY_REASON"
              }
            ]
          },
          {
            "id": "container-1775641493527",
            "title": "Top Leavers by Location",
            "agents": [
              "agent-1775641493527"
            ],
            "additionalPanels": [
              {
                "name": "All Leavers By Locations",
                "heading": "Leavers By Locations",
                "prompt": "",
                "agent": "XX_TOP_LEAVERS_BY_LOCATION"
              }
            ]
          },
          {
            "id": "container-1776239749390",
            "title": "Top Leavers by Job",
            "agents": [
              "agent-1776239749390"
            ],
            "additionalPanels": [
              {
                "name": "All Leavers By Jobs",
                "heading": "Leavers By Jobs",
                "agent": "XX_TOP_LEAVERS_BY_JOB"
              }
            ]
          },
          {
            "id": "container-1776261178650",
            "title": "Top Leavers by Manager",
            "agents": [
              "agent-1776261178650"
            ],
            "additionalPanels": [
              {
                "name": "Leavers by Manager",
                "heading": "Leavers by Manager",
                "agent": "XX_TOP_LEAVERS_BY_MANAGER"
              }
            ]
          },
          {
            "id": "container-1776950176666",
            "title": "Top Leavers by Tenure",
            "agents": [
              "agent-1776950176666"
            ]
          }
        ],
        "layout": "2",
        "firstLane": [
          "container-1776261178650",
          "container-1776239749390"
        ],
        "secondLane": [
          "container-1775638561146",
          "container-1776950176666",
          "container-1775641493527"
        ]
      },
      "agents": {
        "agent-1775638561146": {
          "agent": "XX_TOP_LEAVERS_BY_REASON",
          "name": "Top Leavers by Reason",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": true,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1775641493527": {
          "agent": "XX_TOP_LEAVERS_BY_LOCATION",
          "name": "Top Leavers by Location",
          "description": "Shows attrition across the organization by grouping leavers by location, enabling location and manager-level drilldown, suggesting active employees with similar attrition risk patterns, and surfacing corrective actions alongside those suggestions.",
          "includeInSummary": true,
          "includeInActions": true,
          "includeInCommunications": true,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1776239749390": {
          "agent": "XX_TOP_LEAVERS_BY_JOB",
          "name": "Top Leavers by Job",
          "description": "Shows attrition across the organization by grouping leavers by job role, enabling job and manager-level drilldown, suggesting active employees with similar attrition risk patterns, and surfacing corrective actions alongside those suggestions.",
          "includeInSummary": true,
          "includeInActions": true,
          "includeInCommunications": true,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1776261178650": {
          "agent": "XX_TOP_LEAVERS_BY_MANAGER",
          "name": "Top Leavers By Manager",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": true,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1776950176666": {
          "agent": "XX_TOP_LEAVERS_BY_TENURE",
          "name": "Top Leavers by Tenure",
          "description": "Shows attrition across the organization by grouping leavers by tenure band, enabling tenure and manager-level drilldown, suggesting active employees with similar attrition risk patterns, and surfacing corrective actions alongside those suggestions.",
          "includeInSummary": true,
          "includeInActions": true,
          "includeInCommunications": true,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1779200000000": {
          "agent": "XX_ATTRITION_SUMMARY",
          "name": "Attrition Summary",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        }
      },
      "communications": [
        {
          "id": "comm_1776951531601",
          "title": "Save as PDF",
          "description": "Generates a PDF export of the current attrition analysis view, including displayed leaver trends and employee details.",
          "applicableAgent": [
            "XX_TOP_LEAVERS_BY_REASON",
            "XX_TOP_LEAVERS_BY_LOCATION",
            "XX_TOP_LEAVERS_BY_JOB",
            "XX_TOP_LEAVERS_BY_MANAGER",
            "XX_TOP_LEAVERS_BY_TENURE"
          ],
          "templateId": "1429984d-03a1-4d05-a7ac-630ba3b0b0ff",
          "actionText": "Save to pdf"
        }
      ],
      "summary": {
        "agentCode": "XX_ATTRITION_SUMMARY",
        "prompt": ""
      },
      "actions": [
        {
          "id": "19c4fe6f-63ae-4736-99d7-7c822fdb602b",
          "code": "rowNavigate",
          "displayName": "Show top managers",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "85b94559-056c-498f-a1b5-4d31bab16e34",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "c3587d2b-03c3-4351-85e8-cbc565ce415f",
          "code": "rowNavigateLoc",
          "displayName": "Show managers for location",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "0b0a6321-9d6c-41ea-8745-0ad870297afa",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              },
              {
                "id": "3fbe7ad5-c450-4859-bbf4-ea58b0fc177e",
                "type": "preserveAction",
                "params": {}
              }
            ]
          }
        },
        {
          "id": "1652b952-c61f-44bf-bf5c-dc57e9cf994a",
          "code": "displayEmp",
          "displayName": "displayEmp",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "0234145e-857e-4673-9676-09ccc8ed1f51",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              },
              {
                "id": "035d3566-38dd-4f24-b877-21068ad78e00",
                "type": "preserveAction",
                "params": {}
              }
            ]
          }
        },
        {
          "id": "fe88d673-17dd-4729-97d8-45c525c9bf26",
          "code": "action1",
          "displayName": "action1",
          "description": "",
          "events": {
            "onInvoke": []
          }
        },
        {
          "id": "55f2c316-5c47-4a31-8dbd-82970a570d81",
          "code": "saveToPdf",
          "displayName": "Save to pdf",
          "description": "Send displayed employee details to Communications for PDF generation.",
          "events": {
            "onInvoke": [
              {
                "id": "9d5ef0a5-4380-49db-9453-1c0f0af006d7",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              },
              {
                "id": "87616614-97e1-4019-9d48-2f4f8efea1ad",
                "type": "preserveAction",
                "params": {}
              }
            ]
          }
        }
      ],
      "queryAgent": "XX_ATTRITION_ADVISOR",
      "subTitle": "Past 6 months",
      "templates": [
        {
          "id": "1429984d-03a1-4d05-a7ac-630ba3b0b0ff",
          "name": "PDF",
          "type": "pdf",
          "parts": [
            {
              "id": "9a363ee7-8624-455e-aeae-9387b6084381",
              "generationInstructions": "Attrition data by managers count",
              "presentationInstructions": "Show a section with header \"Employee attrition report by managers\" and a table below with 3 Columns : Manager, Department, Count\nEach row will display manager, it's department and count of employees left under that manager in decreasing order of count. Keep less padding between table and heading. Above the table, show a short summary/insight from the data showed in above table.",
              "presentationType": "autofill",
              "title": "Managers"
            },
            {
              "id": "347482e8-1718-4b4d-ba2e-f607c86a54a5",
              "generationInstructions": "Attrition data by reasons count",
              "presentationInstructions": "Show a section with header \"Employee attrition report by reasons\" and a list below with each row having 2 values : Reason, Count\nEach row will display reason and count of employees left with that reason in decreasing order of count. Keep less padding between list and heading. Above the list, show a short summary/insight from the data showed in below list.",
              "presentationType": "autofill",
              "title": "Reason"
            },
            {
              "id": "49323c29-c9d1-498e-ad23-04c7d15a6c27",
              "generationInstructions": "Attrition data by jobs count",
              "presentationInstructions": "Show a section with header \"Employee attrition report by jobs\" and a bulleted list below with each row having 2 values :  job and count of employees left having that job in decreasing order of count. Keep less padding between list and heading. Above the list, show a short summary/insight from the data showed in above list.",
              "presentationType": "autofill",
              "title": "JOB"
            },
            {
              "id": "491778c9-63ed-446a-8c34-616669cb3ded",
              "generationInstructions": "Attrition data by tenure count",
              "presentationInstructions": "Show a section with header \"Employee attrition report by tenure\" and a bulleted list below with each row having 2 values :  tenure and count of employees left having that tenure in decreasing order of count. Keep less padding between list and heading. Above the list, show a short summary/insight from the data showed in above list.",
              "presentationType": "autofill",
              "title": "TENURE"
            },
            {
              "id": "c3a23fc3-4edb-4b1d-85a9-0167f75387c0",
              "generationInstructions": "Attrition data by locations count",
              "presentationInstructions": "Show a section with header \"Employee attrition report by location\" and a bulleted list below with each row having 2 values :  location and count of employees left having that location in decreasing order of count. Keep less padding between list and heading. Above the list, show a short summary/insight from the data showed in above list.",
              "presentationType": "autofill",
              "title": "LOCATION"
            },
            {
              "id": "employee-leaver-details-by-manager",
              "generationInstructions": "Employee leaver details by manager",
              "presentationInstructions": "Show a section with header \"Employee leaver details by manager\" and a table below with columns: Employee Name, Department, Job, Location, Quartile, Hire Date, Termination Date, Action Reason. Each row should display one employee from the selected manager leaver details. Above the table, show a short summary or insight from the displayed employee rows.",
              "presentationType": "autofill",
              "title": "Employees"
            }
          ]
        }
      ],
      "enableFileUpload": true
    }
  },
  "seededFlag": false,
  "customizationPolicy": null,
  "$id": "300100649745688",
  "customizedSpecifications": {
    "items": [],
    "hasMore": false
  }
}
