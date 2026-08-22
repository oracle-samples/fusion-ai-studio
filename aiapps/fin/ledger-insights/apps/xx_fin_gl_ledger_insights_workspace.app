{
  "_comment": "Copyright © 2026, Oracle and/or its affiliates. ** Licensed under the Universal Permissive License (UPL), Version 1.0  as shown at oss.oracle.com/licenses/upl",
  "id": "300100659469803",
  "name": "Ledger Insights",
  "code": "XX_FIN_GL_LEDGER_INSIGHTS_WORKSPACE",
  "version": 1,
  "status": "DRAFT",
  "internalName": "Ledger Insights",
  "internalDescription": "Ledger Insights is a unified workspace for monitoring General Ledger period close health. It brings together period status, accounting exceptions, clearing account balances, variance analysis, and controls and compliance insights so finance users can identify close risks, drill into supporting balances and journals, switch ledger context, and take guided review or remediation actions.",
  "specification": {
    "applicationMetadata": {
      "title": "Ledger Insights",
      "pagePattern": "swimlanesPattern",
      "pageConfig": {
        "agentContainers": [
          {
            "id": "container-1777364097719",
            "title": "Accounting Exceptions",
            "agents": [
              "agent-1777364097719"
            ],
            "additionalPanels": [
              {
                "name": "accountingExceptions",
                "heading": "More Accounting Exceptions",
                "agent": "XX_FIN_GL_ACCOUNTING_EXCEPTIONS_WORKFLOW"
              }
            ]
          },
          {
            "id": "container-1777439356205",
            "title": "Period Status",
            "agents": [
              "agent-1777439356205"
            ]
          },
          {
            "id": "container-1777524402497",
            "title": "Controls & Compliance",
            "agents": [
              "agent-1777524402497"
            ]
          },
          {
            "id": "container-1782213733509",
            "title": "Clearing Account Balances",
            "agents": [
              "agent-1782213733509"
            ]
          },
          {
            "id": "container-1782291297606",
            "title": "Variance Analysis",
            "agents": [
              "agent-1782291297606"
            ]
          }
        ],
        "layout": "2",
        "firstLane": [
          "container-1777364097719",
          "container-1782291297606",
          "container-1777439356205"
        ],
        "secondLane": [
          "container-1782213733509",
          "container-1777524402497"
        ]
      },
      "agents": {
        "agent-1777364097719": {
          "agent": "XX_FIN_GL_ACCOUNTING_EXCEPTIONS_WORKFLOW",
          "name": "Accounting Exceptions",
          "description": "Identifies accounting exceptions that can block period close, summarizes exception categories by ledger and period, drills into affected transactions, and supports corrective actions such as reviewing transaction details or submitting the related accounting process.",
          "includeInSummary": true,
          "includeInActions": true,
          "includeInCommunications": true,
          "summaryPrompt": "",
          "useDraftWorkflowWhileDeveloping": false,
          "displayPrompt": ""
        },
        "agent-1777439356205": {
          "agent": "XX_FIN_GL_PERIOD_STATUS_WORKFLOW",
          "name": "Period Status",
          "description": "Provides a single view to monitor and manage period status across GL and subledgers, including close readiness, days remaining, and status-change actions.",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1777524402497": {
          "agent": "XX_FIN_GL_CONTROLS_COMPLIANCE_WORKFLOW",
          "name": "Controls and Compliance",
          "description": "Surfaces controls and compliance insights for ledger close, prioritizes policy exceptions and audit risks, supports review or dismissal of flagged issues, and provides drilldowns into journals, balances, and supporting details.",
          "includeInSummary": true,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1782213733509": {
          "agent": "XX_FIN_GL_CLEARING_ACCOUNT_WORKFLOW",
          "name": "Clearing Account Balances",
          "description": "Monitors clearing account insights for the selected ledger and period, highlights unreconciled or unusual clearing balances, and lets users drill into balances, journals, and supporting transactions to understand and resolve close risks.",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": false
        },
        "agent-1782291297606": {
          "agent": "XX_FIN_GL_VARIANCE_ANALYSIS_WORKFLOW",
          "name": "Variance Analysis",
          "description": "Analyzes significant balance variances for the selected ledger and period, ranks variance insights by business impact, and supports drilldowns into balances and review or dismissal actions.",
          "includeInSummary": false,
          "includeInActions": true,
          "includeInCommunications": false,
          "useDraftWorkflowWhileDeveloping": false
        }
      },
      "communications": [],
      "subtitleAgentCode": "XX_FIN_GL_ACCOUNTING_EXCEPTIONS_WORKFLOW",
      "actions": [
        {
          "id": "b25820d5-a023-48c0-b190-cc496ab3cf4e",
          "code": "clearExceptions",
          "displayName": "Clear Exceptions",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "da307a4d-8db5-4230-9e60-6dc205414859",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "d2e24b09-9876-4ccd-8d8b-0bbb9e45c266",
          "code": "drillDownToTransactions",
          "displayName": "View Transactions",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "7a9a132b-f086-41ec-bed7-fc3e0eda2198",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              },
              {
                "id": "e54324af-9418-4d72-8fa0-6e859a6e8256",
                "type": "preserveAction",
                "params": {}
              }
            ]
          }
        },
        {
          "id": "6adfc8bb-22cd-4552-8648-95600210e1dd",
          "code": "openClrAccBalInsight",
          "displayName": "Open Clear Accounting Balance Insight",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "71d8f4c1-cfda-40aa-a8cf-53e864081231",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "2c0610bf-50a3-444d-8a9b-7f1aab13f5b3",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true,
                  "doNotAutoRefresh": true
                }
              }
            ]
          }
        },
        {
          "id": "2a2e98ca-e9b4-49e2-90bf-0e218bb3c9a5",
          "code": "initDisplay",
          "displayName": "Show More Init Display",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "0e6a5fd6-5930-4eaf-876e-24c0d32d40d9",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "c4677999-ca11-4042-8aae-d9f3e75798e5",
          "code": "validateFields",
          "displayName": "Validate Arguments Accounting Exceptions",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "e8f664d1-a175-478d-b15d-ed9f6b12ef2b",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "15d51f40-f7e8-45a4-9d67-e7298b164d9c",
          "code": "submitEss",
          "displayName": "Submit ESS",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "95407af8-0911-4f36-b59a-49052dc39ea2",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "98ca2059-0ab1-4ea3-ae1e-e15f757abb49",
          "code": "openVarInsight",
          "displayName": "Open Variance Insight",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "15800d07-065b-42b6-adde-cffc94d93ed0",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "84342b04-925a-4970-ba2b-821c3d12fbb5",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "9e351b50-343a-4d06-865e-dd37d602f9d1",
          "code": "openCtrlCmpInsight",
          "displayName": "Open Control & Compliance Insight",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "af6702eb-f488-4ac3-8bc3-64d05aaa7c03",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "cd88c5fd-d6cd-457b-bc5d-3a2bdd037b63",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "3f21913f-2d53-4649-8664-42c931e2cc26",
          "code": "explain",
          "displayName": "Explain",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "14761a3a-2351-41dd-9c40-dca03ad9f46c",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "749f33d0-76b6-4bce-bc4c-d201c790c7a9",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true,
                  "doNotAutoRefresh": true
                }
              }
            ]
          }
        },
        {
          "id": "c51c525f-14d0-4899-8a2d-47af99430023",
          "code": "actionSwitchAppContext",
          "displayName": "Switch App Context",
          "description": "Switch App Context",
          "events": {
            "onInvoke": [
              {
                "id": "e748bf87-9d56-4da4-9d8e-47529f745a7b",
                "type": "switchAppContext",
                "params": {
                  "usePayloadAsContext": true,
                  "refreshApp": true
                }
              }
            ]
          }
        },
        {
          "id": "3fb164a9-2079-4676-baaa-39aa79f0f46e",
          "code": "openFAPeriodStatus",
          "displayName": "Open FA Period Status Workspace",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "ae4f5e4b-b9ca-476c-977c-f38e45540285",
                "type": "navigateToAgenticApp",
                "params": {
                  "appCode": "ORA_COST_ACCOUNTING_PERIOD_CLOSE_WORKSPACE",
                  "passPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "b28d99ef-8d4c-4139-953d-c43093ba2597",
          "code": "openCAPeriodStatus",
          "displayName": "Open Cost Organization Details",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "23b38c46-df57-4507-98d9-d7ad7a4d06f2",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "4cc07829-aac7-4618-98e4-0d0bd101459b",
          "code": "markAsReviewed",
          "displayName": "Mark As Reviewed",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "f01bf6c8-1791-410a-b3d3-662ab04f234f",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "1c81cc35-cb7c-421e-b2d6-1732cc41805d",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true,
                  "doNotAutoRefresh": true
                }
              }
            ]
          }
        },
        {
          "id": "5b6e8d19-7c18-4e98-8d8c-bed970ca7fee",
          "code": "dismiss",
          "displayName": "Dismiss",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "708f3260-63d4-465d-a7dd-12a27d8a0029",
                "type": "preserveAction",
                "params": {}
              },
              {
                "id": "a425fcfe-a3f2-4a9f-90f9-26357ab0e9c7",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true,
                  "doNotAutoRefresh": false
                }
              },
              {
                "id": "39752e5e-5d29-4d7e-9fce-85a5afc983ff",
                "type": "refreshAgents",
                "params": {
                  "agentCodes": [
                    "XX_FIN_GL_CONTROLS_COMPLIANCE_WORKFLOW"
                  ],
                  "refreshSummary": true,
                  "refreshPriorityActions": false
                }
              }
            ]
          }
        },
        {
          "id": "8bbfd487-2ea7-4c1f-84cf-2484195c9c9c",
          "code": "openCAWorkSpace",
          "displayName": "Open Cost Accounting Workspace",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "d4095c82-a7d6-44d3-a635-3abc37351772",
                "type": "navigateToAgenticApp",
                "params": {
                  "passPayloadAsContext": true,
                  "appCode": "ORA_COST_ACCOUNTING_PERIOD_CLOSE_WORKSPACE"
                }
              },
              {
                "id": "a3856863-b6e2-4a45-b663-a5ccba157e10",
                "type": "preserveAction",
                "params": {}
              }
            ]
          }
        },
        {
          "id": "ba44ea5b-97ec-40b4-b07d-35a8b0e4aada",
          "code": "selectLedger",
          "displayName": "Select Ledger",
          "description": "Select Ledger to Switch",
          "events": {
            "onInvoke": [
              {
                "id": "0e9e32a5-598e-4389-a6a4-088a05c4a4e9",
                "type": "agentCommand",
                "params": {
                  "sendPayloadAsContext": true
                }
              }
            ]
          }
        },
        {
          "id": "c4fc9310-0cf7-47de-8989-f4123a1cc463",
          "code": "action1",
          "displayName": "action1",
          "description": "",
          "events": {
            "onInvoke": []
          }
        },
        {
          "id": "3d09162a-bb70-4a52-808b-cc455b65c07d",
          "code": "actionUpdateAppContext",
          "displayName": "Update App Context",
          "description": "",
          "events": {
            "onInvoke": [
              {
                "id": "75909560-7abb-4cab-a228-b2cd941f342e",
                "type": "switchAppContext",
                "params": {
                  "usePayloadAsContext": true
                }
              }
            ]
          }
        }
      ],
      "subTitle": "",
      "enableFileUpload": false,
      "summary": {
        "agentCode": "XX_FIN_GL_LEDGER_CLOSURE_WORKFLOW"
      },
      "autoTranslate": true,
      "appContextView": {
        "agentCode": "XX_FIN_GL_LEDGER_SWITCH_WORKFLOW"
      },
      "queryAgent": "XX_FIN_GL_LEDGER_SWITCH_WORKFLOW"
    }
  },
  "createdBy": "MOCKUSER",
  "updatedBy": "MOCKUSER",
  "seededFlag": false,
  "customizationPolicy": null,
  "$id": "300100659469803",
  "customizedSpecifications": {
    "items": [],
    "hasMore": false
  }
}
