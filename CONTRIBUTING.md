# Contributing

## Scope and Priorities
When improving this project, prioritize in this order:
1. Script correctness and reliability
2. Portability and safe defaults
3. Security hardening
4. Documentation clarity

## Conventions
* Prefer POSIX-compatible shell where practical; use zsh-specific behavior only in `.zsh` modules.
* Quote variable expansions unless word-splitting is explicitly intended.
* Ensure scripts fail fast on invalid input and print a clear usage message.
* Keep function/alias names descriptive and hyphenated (for example `git-browser`, `ssh-key-info`).
* Avoid duplicate function implementations across always-loaded modules and optional utils.

## File Organization
* `commands/` - standalone CLI entrypoints.
* `modules/` - always-loaded shell configuration modules.
* `utils/` - optional utility bundles.
* `notes/` - user-facing snippet documentation.

## Validation
Run before opening a PR:

```shell
bash ./scripts/lint.sh
bash ./scripts/smoke-test.sh
```
