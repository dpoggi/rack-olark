# Rack Olark
Rack middleware which injects the Olark JavaScript code before the end of the body of any HTML document being sent to the client. Code from rack/google-analytics has been used liberally and expanded/trimmed down where needed. Mucho thanks to Lee Hambley and other cool rack/google-analytics bros.

## Usage

    require 'rack/olark'
    use Rack::Olark, :id => '1234-567-89-0123', :options => 'like', :this => true, :orthis => 45

Options become this line of JavaScript:

    olark.configure('key', value);

Strings are quoted for you, you needn't worry about that.

## Copyright

Copyright (c) 2011 Dan Poggi. License is 2-clause BSD, see LICENSE for details.
