# GameLibrary - Rails CRUD prototype

A minimal standalone Ruby on Rails implementation of the Game entity from `Laboration 2`. The source project is an ASP.NET game library and review application. This prototype focuses on one entity as required by the assignment.

## Features

- Create games, browse the collection, and view individual details.
- Update title, genre, and release year.
- Delete through an explicit confirmation page.
- SQLite persistence, server validation, form errors, and success messages.
- Responsive interface following the original GameLibrary green palette.
- Four optional sample games from the source project.

There are no accounts, reviews, votes, or external services in this prototype. Anyone using the local app can manage the collection.

## Run with Docker

Install/start Docker Desktop with Linux containers, then from this directory:

```sh
docker compose up --build
```

Open http://localhost:3000. Database preparation and initial seed data run automatically. The named `game_data` volume preserves data between container restarts.

Run the tests:

```sh
docker compose run --rm -e RAILS_ENV=test web bundle exec rails db:prepare test
```

Stop with `docker compose down`. Do not add `--volumes` if you want to keep saved games.

## Run with local Ruby

Requires Ruby 3.2+ and Bundler; Ruby 3.4 is used by the Dockerfile. Rails is pinned to the 8.1 minor series in the Gemfile. SQLite is embedded; no database server or Node.js build step is needed.

```sh
bundle install
bundle exec rails db:prepare
bundle exec rails server
```

Open http://localhost:3000.

On Windows, RubyInstaller with Devkit can provide Ruby. Alternatively, use Docker Desktop or a Ruby installation in WSL. Run commands inside this `WebDevIndStu` directory, not its parent folder.

```sh
bundle exec rails test
```

Tests cover the CRUD lifecycle, invalid create/update submissions, duplicate titles, field limits, confirmation behavior, empty collections, and missing records. `db:prepare` seeds a newly created database; `bundle exec rails db:seed` can restore missing sample games later without duplicating existing ones.

## Entity and source mapping

| Field | Validation | Original source |
| --- | --- | --- |
| title | Required; maximum 120 characters; unique ignoring case | `Models/Game.cs`, `Controllers/GamesController.cs` |
| genre | Required; maximum 40 characters | `Models/Game.cs` |
| release_year | Integer from 1970 through 2100 | `Models/Game.cs` |

Title and genre are trimmed before validation. A database unique index also prevents duplicate titles ignoring case. ID and timestamps are managed by Rails. The sample games mirror `Data/DbInitializer.cs`.

## Structure

- `app/models/game.rb`: entity and validation.
- `app/controllers/games_controller.rb`: CRUD actions and permitted parameters.
- `app/views/games/`: list, details, forms, and deletion confirmation.
- `config/routes.rb`: REST resources and the root collection route.
- `db/migrate/`: SQLite table and constraints.
- `test/`: model and HTTP integration tests.
- `public/stylesheets/application.css`: standalone styling; no CDN dependency.

Forms use Rails CSRF protection and standard HTTP requests with method overrides, so CRUD works without JavaScript. This is a local standalone prototype. Production requires a SECRET_KEY_BASE and a deployment-specific HTTPS configuration.

Rails conventions reference: https://guides.rubyonrails.org/getting_started.html
