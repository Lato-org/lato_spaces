# Upgrading Lato Spaces

Version-specific notes. For the generic upgrade steps see the [README](README.md#upgrading).

## 3.3.0

- Run `rails lato_spaces:install:migrations && rails db:migrate`: a new migration adds unique indexes on memberships (group + user, group + invitation) and associations (group + item). It removes duplicate rows before adding the indexes.
- `AssociableRequired` and `AssociableUnique` apply only to models including them: removing an association no longer destroys items of other models.
- When `Lato.config.auth_disable_signup` is enabled, non admin members cannot invite unregistered emails.
- The `lato_spaces.welcome` translation is now `lato_spaces.welcome_html`: rename it in custom locale files.
- `LatoSpaces::Groupable` helpers are protected and `authenticate_group` answers 403 to JSON requests.

## Lato 3.25 compatibility

Requires Lato 3.25.0 or newer. Install the Lato session migration before deployment (`rails lato:install:migrations && rails db:migrate`): sessions become revocable database records and existing sessions are invalidated, so every user signs in again.
