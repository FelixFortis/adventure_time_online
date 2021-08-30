# Adventure Time Online

## Overview

An Elixir/Phoenix application for playing the [AdventureTime](https://github.com/FelixFortis/adventure_time) game in the browser.

## Demo

A demo can be found at https://adventure-time-online.herokuapp.com/

## Usage

Adventure Time Online relies on the [Adventure Time](https://github.com/FelixFortis/adventure_time) library. The github release of this library is referenced in your `mix.exs` already, and `mix deps.get` will just work. If you wish to work on it locally, just clone the repo and then switch to the commented out line in `mix.exs` to use a local path to the library instead.

With that out of the way, you can do the normal `mix deps.get` and then `mix phx.server`. From there, head to `http://localhost:4000` in your browser (or in multiple incognito browsers to try out the multiplayer functionality).

## Contributing

1. Clone the project to your development machine `git clone https://github.com/FelixFortis/adventure_time_online`
2. Optionally clone the Adventure Time library and update your `mix.exs` file to reference the local copy `git clone https://github.com/FelixFortis/adventure_time`.
3. Install dependencies with `mix deps.get`.
4. Compile the project with `mix compile`.
5. Launch the project with `mix phx.server`.
6. Run the tests with `mix test`.
7. Contributions should be made by pull request, covered by automated tests and include a thorough description of the changes and the reasoning behind them.

## Deployment

This project is setup to be deployed to Heroku, so if you wish to deploy it elsewhere, you may need to make changes to the config.

Create your heroku app with the latest [Elixir](https://elements.heroku.com/buildpacks/hashnuke/heroku-buildpack-elixir) and [Phoenix](https://github.com/gjaldon/heroku-buildpack-phoenix-static) build packs and add the git remote to your app.

Your Heroku app will need a `SECRET_KEY_BASE` environment variable `heroku config:set SECRET_KEY_BASE=my_super_secret_key_base`.

Then it's just a matter of the usual `git push heroku master`.

## Releases

For deploying via Elixir releases, please see the [official documentation](https://hexdocs.pm/phoenix/releases.html) for help.
