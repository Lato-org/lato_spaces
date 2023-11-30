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
- [x] Add method on concern to update the group of a model
- [x] Add scopes on concern to get data filtered by group

### Other features

- [ ] Show stats about entities on spaces show page
- [ ] Show stats about entities attachments on spaces show page
- [ ] Add roles management on spaces memberships

### Tests

- [ ] Add tests for model concerns

## Development

Clone repository, install dependencies, run migrations and start:

```shell
$ git clone https://github.com/Lato-GAM/lato_spaces
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

