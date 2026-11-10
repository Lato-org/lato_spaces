# Lato Spaces
Integrate different workspaces on Lato projects.

Users select an active group; application data is scoped to it. Group selection requires a current membership. Every request protected by `authenticate_group` rechecks access and clears revoked selections. Users with `lato_spaces_admin` can select and manage all groups.

## Installation

Requires Rails 8.1.3.1 or newer in the 8.1 series and Lato 3.25.0 or newer. Existing applications must install the new Lato session migration before deployment; previous sessions are invalidated.
Add required dependencies to your application's Gemfile:

```ruby
# Use lato as application panel
gem "lato"
gem "lato_spaces"
```

Install gem and run required tasks:

```bash
$ bundle
$ rails lato_spaces:install:application
$ rails lato_spaces:install:migrations
$ rails db:migrate
```

Mount lato spaces routes on the **config/routes.rb** file:

```ruby
Rails.application.routes.draw do
  mount LatoSpaces::Engine => "/lato-spaces"

  # ....
end
```

Import Lato Scss on **app/assets/stylesheets/application.scss** file:
```scss
@import 'lato_spaces/application';

// ....
```

Import Lato Spaces Js on **app/javascript/application.js** file:
```js
import "lato_spaces/application";

// ....
```

Add a menu entry pointing to `lato_spaces.root_path` (the group selection page), e.g. in `app/views/layouts/lato/_navbar-nav_content.html.erb`:

```erb
<%= lato_navbar_nav_item :lato_spaces, lato_spaces.root_path do %>
  Spaces
<% end %>
```

### Upgrading

Upgrading from 3.2.0 or earlier: a new migration adds unique indexes on memberships (group + user, group + invitation) and associations (group + item). Run `rails lato_spaces:install:migrations` and `rails db:migrate`: the migration removes duplicate rows before adding the indexes.

## Configuration

```ruby
# config/initializers/lato_spaces.rb
LatoSpaces.configure do |config|
  config.setgroup_redirect_path = :dashboard_path
end
```

| Option | Default | Description |
|--------|---------|-------------|
| `setgroup_redirect_path` | `nil` | Name of a host application route helper (no arguments), e.g. `:dashboard_path`. Users are redirected there after selecting a group. `nil` redirects back to the Spaces page. |
| `setgroup_auto_after_login` | `false` | Select a group automatically when the user opens the Spaces page without a selected group: the preferred group first, otherwise the first group by name. Requires `setgroup_redirect_path`. |
| `setgroup_auto_after_login_if_single` | `false` | Same as above, but only when the user belongs to exactly one group. Requires `setgroup_redirect_path`. |
| `group_icon` | `"bi bi-people-fill"` | Bootstrap Icons class shown on group cards. |
| `group_params` | `%i[name]` | Permitted group form params. |
| `membership_params` | `%i[email]` | Permitted membership form params. |
| `permit_group_creation` | `false` | Allow non-admin users to create groups. The creator becomes the first member. |
| `permit_group_management` | `false` | Allow non-admin members to manage their own groups (see [Permissions](#permissions)). |
| `permit_group_preferred` | `false` | Allow users to mark a preferred group. It is listed first and used by automatic selection. |

Automatic selection runs only when the user visits the Spaces root page (`lato_spaces.root_path`), so point Lato `session_root_path` or the post-login flow there.

Never add `lato_user_id`, `lato_invitation_id` or `lato_spaces_group_id` to `group_params` / `membership_params`: they would let members bypass invitations or move memberships between groups.

## Permissions

| Action | `lato_spaces_admin` | Member, `permit_group_management = true` | Member, default |
|--------|---------------------|------------------------------------------|-----------------|
| Select a group | Any group (also from the group page) | Own groups | Own groups |
| List all groups | Yes | No | No |
| Create groups | Yes | Only with `permit_group_creation` | Only with `permit_group_creation` |
| Rename / delete group | Any group | Own groups | No |
| Add registered users | Any group | Own groups | No |
| Invite unregistered emails | Any group | Own groups, only when `Lato.config.auth_disable_signup` is `false` | No |
| Remove members / resend invitations | Any group | Own groups, except the last registered member | No |

There are no roles inside a group yet: with `permit_group_management` every member has the same powers, including deleting the group. Enable it only when members are trusted.

Membership creation and invitation resend are rate limited (20 requests per 10 minutes per IP).

Grant admin permission from the console (with `lato_users` it is also shown as a checkbox):

```ruby
Lato::User.find_by(email: "admin@example.com").update!(lato_spaces_admin: true)
```

## Invitations

Adding a member by email:

- The email is normalized (stripped, downcased).
- Registered user: the user is added immediately. Non-admins see members by email; full names are shown to admins only.
- Existing pending `Lato::Invitation`: it is reused.
- Otherwise a `Lato::Invitation` is created and the invitation email is sent. When the invitation is accepted the membership is moved to the new user.
- A user or invitation can belong to a group only once.
- Destroying the invitation or the user destroys its memberships. Resending is limited by Lato to one email every 2 minutes.

Lato invitations bypass `auth_disable_signup`, so when signup is disabled only Spaces admins can invite unregistered emails.

## Usage

### Protecting controllers

```ruby
class ApplicationController < Lato::ApplicationController
  include LatoSpaces::Groupable
end

class ProjectsController < ApplicationController
  before_action :authenticate_session
  before_action :authenticate_group

  def index
    @projects = Project.for_lato_spaces_group(@session.get(:spaces_group_id))
  end
end
```

`LatoSpaces::Groupable` adds protected methods:

| Method | Description |
|--------|-------------|
| `authenticate_group` | Checks that the selected group (`@session.get(:spaces_group_id)`) is still accessible. Otherwise it clears the selection and redirects to `lato_spaces.root_path` (HTML) or responds `403 Forbidden` (JSON). |
| `session_group_create(group_id)` | Selects a group the user can access. Returns `false` otherwise. |
| `session_group_destroy` | Clears the selected group. |

Read `:spaces_group_id` only in controllers protected by `authenticate_group`: elsewhere it may point to a group the user no longer belongs to.

### Associating records with groups

```ruby
class Project < ApplicationRecord
  include LatoSpaces::Associable
end
```

Scopes:

- `for_lato_spaces_group(group_id)`: records of a group (`nil` returns nothing; with an array of ids a record in many groups is returned once per group, add `.distinct` if needed).
- `with_lato_spaces_groups`: records with at least one group.
- `without_lato_spaces_groups`: records without groups.

Instance methods (operations return `true`/`false` and add errors to the record on failure):

- `lato_spaces_group`, `lato_spaces_group_id`: first group of the record.
- `add_to_lato_spaces_group(group_id)`
- `remove_from_lato_spaces_group(group_id)`
- `switch_lato_spaces_group(group_id)`: moves the first association to another group.

Stricter concerns (include them after `LatoSpaces::Associable`):

- `LatoSpaces::AssociableRequired`: records need an existing `lato_spaces_group_id` on create and are associated to it. **Destroying the association destroys the record**: removing it from its group or deleting the group deletes the record.
- `LatoSpaces::AssociableUnique`: records can belong to one group only; a second `add_to_lato_spaces_group` returns `false`.

Both only affect the models that include them.

```ruby
class Project < ApplicationRecord
  include LatoSpaces::Associable
  include LatoSpaces::AssociableRequired
  include LatoSpaces::AssociableUnique
end

# Take the group from the session, never from request params.
Project.create!(name: "Project 1", lato_spaces_group_id: @session.get(:spaces_group_id))
```

Deleting a group destroys its memberships and associations, and every `AssociableRequired` record of the group.

### Customization

`rails lato_spaces:install:application` copies into the host application:

- `app/views/layouts/lato_spaces/_group-form-extra_content.html.erb`: extra group form fields.
- `app/views/layouts/lato_spaces/_membership-form-extra_content.html.erb`: extra membership form fields.
- `app/views/layouts/lato_spaces/_group-informations_content.html.erb`: group details on the group page.
- `app/models/concerns/lato_spaces_membership_application.rb`: custom relations and methods for `LatoSpaces::Membership`.

Custom form fields must also be added to `group_params` / `membership_params`. Translations are provided for `en` and `it`.

## Roadmap

- [ ] Roles inside groups (owner/member) to limit deletion and member management
- [ ] Show stats about entities on spaces show page
- [ ] Show stats about entities attachments on spaces show page

## Development

Clone repository, install dependencies, run migrations and start:

```shell
$ git clone https://github.com/Lato-org/lato_spaces
$ cd lato_spaces
$ bundle
$ rails db:migrate
$ rails db:seed
$ foreman start -f Procfile.dev
```

## Publish

```shell
$ ruby ./bin/publish.rb
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

