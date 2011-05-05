# Rack Olark
Rack middleware which injects the Olark JavaScript code before the end of the body of any HTML document being sent to the client. 

## Usage

    require 'rack/olark'
    use Rack::Olark, :id => '1234-567-89-0123', :format => :html5, :paths => ['/', '/aboutus'], :option => :value

Rack::Olark has three special options, and the rest are passed along to Olark like this (strings are quoted for you):

    olark.configure('key', value);

The three special options are :id, :format, and :paths. :id is your Olark API ID, and the middleware won't let your Rack app boot without it.

Format is my justification for using Haml in this project - this option is passed directly to Haml::Engine, and determines the form of the script tags that are inserted into your pages. Choices are :html4, :xhtml, and :html5, with a default of :html5.

Paths decides which routes in your application will display the Olark chat box. It takes an array of routes, and you need to include the leading slash (/). Example:

    require 'rack/olark'
    use Rack::Olark, :id => '1234-567-89-0123', :format => :xhtml, :paths => ['/', '/aboutus']

## Acknowledgements

Code from rack/google-analytics has been used liberally and expanded/trimmed down where needed. Mucho thanks to Lee Hambley and other cool rack/google-analytics bros.

## Copyright

Copyright (c) 2011 Dan Poggi. License is 2-clause BSD, see LICENSE for details.
