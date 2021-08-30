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
2. Optionally clone the Adventure Time library and update your `mix.exs` file to reference the local copy `git clone https://github.com/FelixFortis/adventure_time`
3. Install dependencies with `mix deps.get`
4. Compile the project with `mix compile`
5. Launch the project with `mix phx.server`
6. Run the tests with `mix test`
7. Contributions should be made by pull request, covered by automated tests and include a thorough description of the changes and the reasoning behind them.
