# AdventureTimeOnline

## Overview

An Elixir/Phoenix application for playing the [AdventureTime](https://github.com/FelixFortis/adventure_time) game in the browser.

## Usage

You will need access to the [AdventureTime](https://github.com/FelixFortis/adventure_time) library. You can update your `mix.exs` file with either the local path to it on your machine, or the github URL. Both are provided, and you can just comment out the one you prefer.

Once you have done that, you can do the normal `mix deps.get` and then `mix phx.server`. From their, head to `http://localhost:4000` in your browser (or in multiple incognito browsers to try out the multiplayer functionality).

## Contributing

1. Clone the project to your development machine
2. Install dependencies with `mix deps.get`
3. Run the tests with `mix test`
