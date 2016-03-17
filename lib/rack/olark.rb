require 'erb'
require 'json'
require 'rack'
require 'rack/request'

module Rack
  class Olark
    TEMPLATE_PATH = ::File.expand_path(
      ::File.join('..', 'templates', 'olark.erb'),
      __FILE__
    )

    def initialize(app, options = {})
      @app = app

      # Validity check on Site-ID
      site_id = (options.delete(:id) || '').gsub(/[^0-9-]/, '')
      unless site_id.length == 16
        raise ArgumentError, 'rack-olark requires a valid Olark Site-ID!'
      end

      # Deprecation warnings
      deprecation_warning('format') if options.delete(:format)
      deprecation_warning('tag') if options.delete(:tag)

      # Is it a Regexp? No? Then escape it, and make it a Regexp.
      @paths = (options.delete(:paths) || []).map do |path|
        path.is_a?(Regexp) ? path : /^#{Regexp.escape(path.to_s)}$/
      end
      # Let's please not call Array#empty? on every request.
      @inject_all = @paths.empty?

      js = options.map { |k, v| olarkify(k, v) }.join
      @html = ERB.new(::File.read(TEMPLATE_PATH)).result(binding)
    end

    def call(env)
      status, headers, body = @app.call(env)
      request = Rack::Request.new(env)

      if html?(headers) && (@inject_all || should_inject?(request))
        response = Rack::Response.new([], status, headers)
        body.each do |fragment|
          response.write(fragment.gsub('</body>', @html))
        end
        response.finish
      else
        [status, headers, body]
      end
    end

    private
    def olarkify(key, val)
      "olark.configure(#{key.to_s.to_json}, #{val.to_json});"
    end

    def deprecation_warning(option)
      STDOUT.puts("Rack::Olark: The '#{option}' option is deprecated and no longer functions! See README.md for details.")
    end

    def html?(headers)
      (Rack::Utils::HeaderHash.new(headers)['Content-Type'] || '').include?('html')
    end

    def should_inject?(request)
      @paths.select { |p| request.path_info =~ p }.length > 0
    end
  end
end
