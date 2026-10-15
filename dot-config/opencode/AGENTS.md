- Keep responses concise; no preamble or recap.

## Basic Memory

You have persistent memory through Basic Memory's MCP tools.

- In `~/Projects/<group>/<repo>`, use project `<group>` and put notes under
  folder `<repo>/`. Cross-cutting notes (preferences, general knowledge)
  go in project `global`.
- Writing to Basic Memory (write_note/edit_note) is allowed in plan mode;
  it doesn't count as modifying files.
- Before answering questions about prior work or decisions, search first:
  `search_notes`, then `build_context` on relevant `memory://` URLs.
- Capture important decisions, findings, and context as notes with
  `write_note` during the conversation — don't wait to be asked.
- Structure notes semantically: observations as `- [category] fact #tag`
  and relations as `- relates_to [[Other Note]]`. Use exact titles of
  existing notes in wikilinks so they resolve.
- Update existing notes with `edit_note` instead of creating duplicates.
