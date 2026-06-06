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
- Avoid internal implementation details such as controller internals, route lists, private models, or database mechanics unless required for usage.

## Local setup

- Ruby via `rbenv`.
- Install gems: `bundle`.
- Migrate dummy DB: `rails db:migrate`.
- Seed dummy DB: `rails db:seed`.
- Start dev stack: `foreman start -f Procfile.dev`.

## Main commands

- Run tests: `bin/rails test`.
- Publish gem: `ruby ./bin/publish.rb`.

## Agent notes

- Keep Ruby strings double quoted.
- Keep examples focused on group selection, permissions, and associating application data.
- Do not touch `.DS_Store` files if present.
