require 'rack'
require 'rack/request'
require 'erb'

module Rack
  class Olark
    DEFAULTS = {
      tag: '<script>',
      paths: []
    }

    def initialize(app, options = {})
      unless options[:id] && options[:id].length == 16
        raise ArgumentError, 'Need a valid Olark ID!'
      end
      @app, @options = app, DEFAULTS.merge(options)
      @id, @tag, @paths = [@options.delete(:id),
                           @options.delete(:tag),
                           @options.delete(:paths)]

      if @paths.is_a?(Array)
        @paths.map! { |path| path.is_a?(Regexp) ? path : /^#{Regexp.escape(path.to_s)}$/ }
      else
        @paths = []
      end

      @option_js = "olark.identify('#{@id}');"
      @options.each do |key, val|
        val = [String, Symbol].include?(val.class) ? "'#{val.to_s}'" : val.to_s
        @option_js << "olark.configure('#{key.to_s}', #{val});"
      end
    end

    def call(env); dup._call(env); end

    def _call(env)
      @status, @headers, @response = @app.call(env)
      @request = Rack::Request.new(env)
      valid_path = @paths.select { |path| @request.path_info =~ path }.length > 0

      if html? && (@paths.empty? || valid_path)
        response = Rack::Response.new([], @status, @headers)
        @response.each { |fragment| response.write(inject(fragment)) }
        response.finish
      else
        [@status, @headers, @response]
      end
    end

    private
    def html?; @headers['Content-Type'] =~ /html/; end

    def inject(response)
      template_file = ::File.read(::File.expand_path('../templates/olark.erb', __FILE__))
      @template = ERB.new(template_file).result(binding)
      response.gsub('</body>', @template)
    end
  end
end
