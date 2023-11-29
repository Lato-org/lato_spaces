# Lato Spaces
Integrate different workspaces on Lato projects.

NOTE: This project is under development.

## Installation
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

## Todo

### Manage models relations with spaces groups

- [x] Create a new model to manage the relations between spaces and groups
- [x] Create a new concern for models that must be related to spaces groups
- [x] Add hooks on concern to manage the relation on model creation/destroy
- [ ] Add method on concern to update the group of a model
- [x] Add scopes on concern to get data filtered by group

### Other features

- [ ] Show stats about entities on spaces show page
- [ ] Show stats about entities attachments on spaces show page
- [ ] Add roles management on spaces memberships