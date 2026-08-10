# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- `.github/toolchain.json` owns the exact local and CI Flutter toolchain contract; verify it with `ruby scripts/verify_toolchain.rb .github/toolchain.json` before dependency resolution.
- Public-repository CI is intentionally manual-only on protected `main`; validate its security invariants with `ruby test/workflow_policy_test.rb`.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
