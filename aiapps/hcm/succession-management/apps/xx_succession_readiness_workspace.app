{
  "_comment": "Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl",
  "id": "300100700927144",
  "name": "Succession Readiness Workspace",
  "code": "XX_SUCCESSION_READINESS_WORKSPACE",
  "version": 1,
  "status": "DRAFT",
  "internalName": "Succession Readiness Workspace",
  "internalDescription": "Succession Planning Agentic Application",
  "specification": {
    "applicationMetadata": {
      "title": "Succession Planning",
      "pagePattern": "swimlanesPattern",
      "pageConfig": {
        "agentContainers": [
          {
            "id": "container-1776072592666",
            "title": "Top Performers",
            "agents": [
              "agent-1776072592666"
            ]
          },
          {
            "id": "container-1776072596694",
            "title": "Talent Needing Assistance",
            "agents": [
              "agent-1776072596694"
            ]
          },
          {
            "id": "container-1776073698497",
            "title": "Succession Overview",
            "agents": [
              "agent-1776073698497"
            ],
            "additionalPanels": [
              {
                "name": "ImpactOfLoss",
                "heading": "Impact Of Loss",
                "agent": "XX_SUCCESSION_OVERVIEW_ADVISOR"
              },
              {
                "name": "riskOfLoss",
                "heading": "Risk Of Loss",
                "agent": "XX_SUCCESSION_OVERVIEW_ADVISOR"
              },
              {
                "name": "successionInformation",
                "heading": "Succession Information",
                "agent": "XX_SUCCESSION_OVERVIEW_ADVISOR"
              }
            ]
          },
          {
            "id": "container-1776075460125",
            "title": "Compensation Summary",
            "agents": [
              "agent-1776075460125"
            ]
          },
          {
            "id": "container-1776079801568",
            "title": "Impact of Loss",
            "agents": [
              "agent-1776079801568"
            ]
          },
          {
            "id": "container-1776081240650",
            "title": "Risk of Loss",
            "agents": [
              "agent-1776081240650"
            ]
          }
        ],
        "layout": "2",
        "firstLane": [
          "container-1776073698497",
          "container-1776072592666",
          "container-1776072596694"
        ],
        "secondLane": [
          "container-1776081240650",
          "container-1776079801568",
          "container-1776075460125"
        ]
      },
      "agents": {
        "agent-1776072592666": {
          "agent": "XX_TOP_TALENT_ADVISOR",
          "name": "Top Talent Advisor",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776072596694": {
          "agent": "XX_BOTTOM_TALENT_ADVISOR",
          "name": "Bottom Talent Advisor",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776073698497": {
          "agent": "XX_SUCCESSION_OVERVIEW_ADVISOR",
          "name": "Succession Overview Advisor",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776075460125": {
          "agent": "XX_COMPENSATION_ADVISOR",
          "name": "Compensation Advisor",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776079801568": {
          "agent": "XX_IMPACT_OF_LOSS_ADVISOR",
          "name": "Impact of Loss Advisor",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776081240650": {
          "agent": "XX_RISK_OF_LOSS_ADVISOR",
          "name": "Risk Of Loss Advisor",
          "description": "",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        }
      },
      "communications": [],
      "actions": [
        {
          "id": "16f653d6-b75e-4da6-bd90-a3dec0b58d28",
          "code": "appNavigate",
          "displayName": "Navigate to App",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "a2665006-d31b-4a98-824e-e97c4228d2af",
                "type": "navigateToAgenticApp",
                "params": {
                  "appCode": "XX_PERSON_SUCCESSION_READINESS_WORKSPACE",
                  "passPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "2a36eb23-36b3-4750-9be6-9c97f0ba4706",
          "code": "rowNavigate",
          "displayName": "Row Action",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "8a0a1247-4650-49e0-9434-f64db51e917d",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "36282bab-dec7-41f9-937b-b2d65625b3e9",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "a7d3e77e-433e-4f7c-9b4b-c71dc2191d4b",
          "code": "successionCandidates",
          "displayName": "Succession Candidates",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "6fca2ede-8e2a-42d3-99f8-e53ef9cf9985",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "3585429a-4cca-4e04-a420-85a7bc2257b6",
          "code": "addSuccessor",
          "displayName": "Add Successor",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "75e97cfa-4f2e-4c08-81fb-995e46b15e46",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              },
              {
                "id": "e16edb3b-359d-4d5a-bf82-3156ea782248",
                "type": "refreshAgents",
                "params": {
                  "agentCodes": [
                    "XX_SUCCESSION_OVERVIEW_ADVISOR"
                  ],
                  "refreshPriorityActions": true,
                  "refreshSummary": true
                }
              }
            ]
          }
        },
        {
          "id": "9ea59b18-b330-4031-a90a-baff92fb80ad",
          "code": "viewSuccessorDetails",
          "displayName": "View Successor Details",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "a76cf91c-84fa-4173-b7c9-27506c36b7f6",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "b2548a35-d1c1-4b5a-b953-0d514e50348b",
          "code": "viewSuccessorInfo",
          "displayName": "View Successor Info",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "e935898f-dd97-4e23-8d35-001c078a6fdc",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        }
      ],
      "summary": {
        "agentCode": "XX_SUCCESSION_OVERVIEW_ADVISOR",
        "prompt": ""
      },
      "subTitle": "",
      "subtitleAgentCode": "SUCCESSION_OVERVIEW_ADVISOR",
      "enableFileUpload": false
    }
  },
  "seededFlag": false,
  "customizationPolicy": null,
  "$id": "300100700927144",
  "customizedSpecifications": {
    "items": [],
    "hasMore": false
  }
}