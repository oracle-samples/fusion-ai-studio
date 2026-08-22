{
  "_comment": "Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl",
  "id": "300000339413899",
  "name": "Person Succession Readiness Workspace",
  "code": "XX_PERSON_SUCCESSION_READINESS_WORKSPACE",
  "version": 1,
  "status": "DRAFT",
  "internalName": "Person Succession Readiness Workspace",
  "internalDescription": "Succession Overview Agentic Application that lists Succession Information, Compensation History, Risk and Impact of Loss in Detail",
  "specification": {
    "applicationMetadata": {
      "title": "Succession Planning",
      "pagePattern": "swimlanesPattern",
      "pageConfig": {
        "agentContainers": [
          {
            "id": "container-1776076009568",
            "title": "Compensation History",
            "agents": [
              "agent-1776076009568"
            ]
          },
          {
            "id": "container-1776083617218",
            "title": "Impact Of Loss",
            "agents": [
              "agent-1776083617218"
            ]
          },
          {
            "id": "container-1776084341971",
            "title": "Risk Of Loss",
            "agents": [
              "agent-1776084341971"
            ]
          },
          {
            "id": "container-1776150884309",
            "title": "Succession Information",
            "agents": [
              "agent-1776150884309"
            ]
          }
        ],
        "layout": "2",
        "firstLane": [
          "container-1776150884309"
        ],
        "secondLane": [
          "container-1776084341971",
          "container-1776083617218",
          "container-1776076009568"
        ]
      },
      "agents": {
        "agent-1776076009568": {
          "agent": "XX_COMPENSATION_ANALYSIS",
          "name": "Compensation Analysis",
          "description": "Shows salary history for the selected worker assignment.",
          "includeInSummary": false,
          "includeInActions": false,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776083617218": {
          "agent": "XX_IMPACT_OF_LOSS_ANALYSIS",
          "name": "Impact of Loss Analysis",
          "description": "Displays the impact assessment if the worker were lost, highlighting business criticality and coverage gaps.",
          "includeInSummary": false,
          "includeInActions": false,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776084341971": {
          "agent": "XX_RISK_OF_LOSS_ANALYSIS",
          "name": "Risk of Loss Analysis",
          "description": "Shows the risk-of-loss assessment for the worker, helping identify how likely it is that this person could leave or become unavailable.",
          "includeInSummary": false,
          "includeInActions": false,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        },
        "agent-1776150884309": {
          "agent": "XX_SUCCESSION_ANALYSIS",
          "name": "Succession Analysis",
          "description": "Shows a selected worker's succession readiness, plan coverage, candidate count, and supporting talent context.",
          "includeInSummary": false,
          "includeInActions": false,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": true
        }
      },
      "communications": [],
      "actions": [],
      "subtitleAgentCode": "XX_SUCCESSION_ANALYSIS",
      "enableFileUpload": false
    }
  },
  "seededFlag": false,
  "customizationPolicy": null,
  "$id": "300000339413899",
  "customizedSpecifications": {
    "items": [],
    "hasMore": false
  }
}