---
name: file-ticket
description: Use when the user asks to create a Jira ticket from the current thread.
---

# File Ticket

Create the ticket with the Atlassian MCP (`createJiraIssue`) on
formstack.atlassian.net.

## Steps

1. **Space.** Default `FE`. Never `NT` unless the user asks.
2. **Parent epic.** Pick from this table. If unsure, ask with
   `AskUserQuestion`.

   | Topic | Epic |
   | --- | --- |
   | session-kit | FE-744 |
   | accessibility, WCAG | FE-634 |
   | external or interrupt work | search by name: "2026Q4 External and Interrupt Work" |

   Look the interrupt epic up by name. Do not guess its key.
3. **Description.** Draft with `ghostwrite`: summary, context, acceptance
   criteria. Show it before creating.
4. **Assignee and status.** Assign to the user. Move to In Progress only when
   they are already working on it. Otherwise ask.
5. **Link.** If a PR exists, add the ticket to its description or thread.
6. **Return** `https://formstack.atlassian.net/browse/<KEY>`.
