# CLAUDE.md - Formulaire QF

## Commands

- Tests: `bundle exec rspec` (one file or line: `bundle exec rspec spec/path/to/file_spec.rb:LINE`), `bundle exec cucumber`
- Lint: `bundle exec rubocop` (auto-fix: `bundle exec rubocop -A`)
- Security scan: `bundle exec brakeman -q` (run by CI)
- Auto-test on save: `bundle exec guard`
- Booting needs the gitignored keys `config/credentials/development.key` and `test.key` (`config/master.key` optional in dev).

## Workflow

After each iteration:
1. Run `bundle exec rubocop` and fix any offense
2. Run the relevant specs and features

Commit messages are written in English.

## Code style

- RuboCop with `standard` and `rubocop-rails` (`.rubocop.yml`): double quotes, trailing commas on multiline array and hash literals.
- No comments in code.
- Business logic lives in organizers (`app/organizers/`) and small interactors (`app/interactors/`), never in controllers. Controllers call an organizer or an interactor, then redirect or render.
- Tests: RSpec and Cucumber. Do not test ActiveRecord associations, only custom behaviour; keep factories valid instead.
- Every file ends with a newline.

## Worktrees

By default, each subject is developed in its own worktree under `worktrees/<name>`, `<name>` being a ticket (`FQF-123`) or a slug for ad hoc work (`hubee-retry`). Do not develop in the main checkout unless asked.

- `bin/setup_worktree.sh [-p port] <name> [branch]`: create `worktrees/<name>` with its own databases and port; `bin/rails s` then needs no `-p`.
- `bin/remove_worktree.sh <name>`: stop its server, remove the worktree, delete the local branch if setup created it, drop its databases. Run it from the main checkout as soon as the PR is merged.

FranceConnect login only works on port 3000 (the only registered callback): use `-p 3000` with the main app stopped to test it.
