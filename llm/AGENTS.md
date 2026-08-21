# Global agent instructions

- This only applies to Cursor - use Composer for implementation and exploration unless told otherwise. The goal for a big frontier model is orchestration, Composer does the work in an attempt to reduce frontier model token usage.
- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When doing bug fixes, always start by reproducing the bug as close to end-user behavior as practical. If full E2E is not feasible, use the closest reliable reproduction.
  This makes sure you find the real problem so your fix will actually solve it.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
- Do not preserve backwards compatibility unless told to. Remove clearly dead internal paths that are no longer referenced instead of adding compatibility layers, fallbacks, or migrations.
- Choose the simplest implementation that fully meets the current requirements. Avoid speculative abstractions, configurations, and indirection.
- Grow the system in layers. Start from the smallest version that works end to end, and add each new capability on top of a product that already works. Never trade a working product for unfinished complexity.
- Keep components modular and concerns clearly separated.
- Prefer established, well-maintained libraries when they reduce overall complexity or improve reliability. Do not reimplement common functionality without a clear reason.
- Lean on the dependencies already in the project before writing your own implementation or adding packages. Do not assume a library lacks a capability without checking its documentation and types.
- Make architectural decisions for the long term. Do not accept a stopgap that only works for now and is meant to be replaced later unless told to.
- If ponytail is in effect, it outranks these global rules on shape and size, including modularity and long-term architecture. Follow the project's ponytail precedence.
- Always respond to the user in plain language using ISO 24495-1:2023
