# AGENTS

## Project overview

Lato is ecosystem of Rails engines for building admin panels with authentication, user management, Bootstrap UI, reusable components, operations, settings, storage, spaces, and CMS features.

`lato_spaces` is extension gem for the base `lato` engine.

## Gem purpose

`lato_spaces` adds workspace/group support to a Lato application.

Use it when users must select an active group and application data must be scoped by group.

Users/admins can:

- See available groups.
- Select active group for current session.
- Manage groups and memberships when allowed.
- Invite users to groups.
- Scope application records to selected group.

## Documentation

- User-facing documentation lives in `test/dummy/app/views/application/documentation.html.erb`.
- Keep that file updated whenever install steps, permissions, configuration, group behavior, associations, or usage changes.
- Documentation should explain what the gem does, how to install it, and how to use it.
- Keep `README.md` in sync with it (configuration table with defaults, permissions matrix, invitations, `Groupable` API, `Associable` scopes/methods).
- Avoid internal implementation details such as controller internals, route lists, private models, or database mechanics unless required for usage. Always document destructive or surprising behavior (e.g. `AssociableRequired` destroying records).
- Engine is mounted at `/lato-spaces` in docs and in the dummy app.

## Local setup

- Ruby via `rbenv`.
- Install gems: `bundle`.
- Migrate dummy DB: `rails db:migrate`.
- Seed dummy DB: `rails db:seed`.
- Start dev stack: `foreman start -f Procfile.dev`.

## Main commands

- Run tests: `bin/rails test`.
- Tests live in `test/`: `test/integration/security_test.rb` (tenant isolation), `test/integration/hardening_test.rb` (permissions, XSS, invitations, a11y markup), `test/models/lato_spaces/` (concerns and memberships). `test/dummy/test/` is not run by `bin/rails test`.
- Publish gem: `ruby ./bin/publish.rb`.

## Agent notes

- `AssociableRequired` / `AssociableUnique` are markers checked by `LatoSpaces::Association` per item: never register callbacks on `LatoSpaces::Association` from model concerns.
- User-facing strings go in `config/locales/en.yml` and `it.yml` (keep both in sync).
- `lato_page_head` renders the title raw: escape user data passed as title.
- Keep Ruby strings double quoted.
- Keep examples focused on group selection, permissions, and associating application data.
- Do not touch `.DS_Store` files if present.

## Security release baseline

- Rails 8.1.3.1 or newer in the 8.1 series is required.
- Run `ruby bin/publish.rb` from a named release branch after tests pass. It builds the exact version, commits changes, tags that commit, publishes to RubyGems, and pushes the branch and tag.
- Applications using Active Storage with vips require libvips 8.13 or newer.
