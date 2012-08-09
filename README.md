# Rack::Olark
Rack middleware which injects the Olark JavaScript code before the end of the body of any HTML document being sent to the client. 

## Usage

    use Rack::Olark, id: '1234-567-89-0123'

Most of the options you give Rack::Olark are passed along to Olark in the following format:

    olark.configure('key', value);

There are three special options: id, tag, and paths. id is your Olark API ID, and the middleware won't let your Rack app boot without it.

tag is a custom script tag to be used at the beginning of the Olark code. Most people should never need this, and it will default to just `<script>` (HTML5-style). 

paths decides which routes in your application will display the Olark chat box. It takes an array of routes, and you need to include the leading slash (/). If you don't give an array for paths, it is empty by default, and this will cause the Olark code to be inserted on every route. As of version 0.0.4, you can now describe routes in the paths array with a Regexp as well, and any non-Regexp entries will be handled like this:

    /^#{Regexp.escape(your_original_path_entry)}$/

Example using options:

    use Rack::Olark, id: '1234-567-89-0123',
                     tag: '<script type="text/javascript">',
                     paths: ['/', '/aboutus']

Note that in order to use custom Olark JavaScript options, you may have to revert to using hashrocket syntax.

## Acknowledgements

Code from rack/google-analytics has been used liberally and expanded/trimmed down where needed. Mucho thanks to Lee Hambley and other cool rack/google-analytics bros.

## Copyright

Copyright (C) 2012 Dan Poggi. MIT License, see LICENSE for details.
