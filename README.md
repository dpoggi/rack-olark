# Rack::Olark

Middleware which inserts Olark JavaScript embed code before </body> in HTML served by Rack.

## Usage

In `config.ru`, or wherever else you mount middleware:

    use Rack::Olark, id: '1234-567-89-0123'

All non-special options given to Rack::Olark are passed through as JavaScript in the following manner:

    olark.configure('key', value);

There are two special options: `id` and `paths`.

`id` is your Olark Site-ID, and the middleware won't allow your app to boot without it.

`paths` decides which of your routes will display the Olark chat box. It accepts an array of routes, with the leading slash (`/`) included. `paths` defaults to empty array (`[]`), causing Olark to be embedded for every route. As of version 0.0.4, routes in `paths` can also be described with a Regexp. Non-Regexp `paths` entries will be handled using:

    /^#{Regexp.escape('/my/path')}$/

Example of usage with options:

    use Rack::Olark, {
      :id                          => '1234-567-89-0123',
      :paths                       => ['/', '/aboutus'],
      'features.attention_grabber' => true,
    }

Note that in order to use custom Olark JavaScript options, you may have to revert to hashrocket syntax, as they tend to contain characters Ruby doesn't like in symbols.

## Acknowledgements

Originally based on code from [rack-google-analytics](https://github.com/kangguru/rack-google-analytics). Never would've gotten started without them!

## Copyright

Copyright (C) 2011 Dan Poggi. MIT License, see LICENSE for details.
