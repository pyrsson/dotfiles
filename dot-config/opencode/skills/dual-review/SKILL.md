---
name: Dual Review
description: Cross-checked code review by two reviewer subagents on different models that verify each other's findings and reach a consensus on what is worth fixing. Use when asked for a thorough, dual, or second-opinion review of changes.
---

Run a review with the `reviewer` and `reviewer-gpt` subagents. Do not edit files during this workflow.

## 1. Scope

Use the target the user gave (paths, commit range, branch, PR). If none, review uncommitted changes: run `git status --short` and `git diff HEAD --stat`, and include untracked files. If there is nothing to review, say so and stop.

## 2. Independent reviews

Launch both subagents in the background in the same turn, with the same prompt. Neither may see the other's output. The prompt must contain the scope, how to inspect it (exact git commands), and these instructions:

> Review for bugs, regressions, security issues, and significant design problems. Skip pure style preferences. Read surrounding code to verify each claim before reporting it. Return a numbered list; for each finding give: ID (prefix `A` for reviewer, `B` for reviewer-gpt), severity (critical/high/medium/low), `file:line`, claim, evidence (what in the code proves it), and suggested fix. Return "No findings" if there are none.

Record both returned `sessionID`s.

## 3. Cross-check

When both finish, continue each reviewer's session (pass its `sessionID`) with the other reviewer's findings, in parallel. Ask:

> Another reviewer reported the findings below. For each ID, verify against the actual code and answer `confirm`, `refute`, or `unsure`, with one or two sentences of evidence. Note duplicates of your own findings (`dup of A3`) and overstated or understated severity. Do not repeat your own findings; you may add at most a few new issues you discovered while checking, using the same format.

## 4. Consensus

Classify every finding (merge duplicates first):

- **Fix**: found by both, or confirmed by the peer.
- **Disputed**: peer refuted or was unsure. Read the code yourself and rule `fix` or `drop`, with a one-line reason.
- **Dropped**: refuted and your check agrees, or it is speculative or stylistic.

Use the agreed severity; when they disagree, decide and state why.

## 5. Report

Keep it concise:

1. **Fix** — severity order: `file:line`, issue, fix, and who found/confirmed it.
2. **Disputed** — each with your ruling and reason.
3. **Dropped** — one line each.

Stop after the report. Offer to apply the Fix items, but do not apply them unless the user asks.
