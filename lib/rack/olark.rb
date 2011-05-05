require 'rack'
require 'rack/request'
require 'haml'

module Rack
  class Olark
    Defaults = {:format => :html5, :paths => []}

    def initialize(app, options = {})
      raise ArgumentError, "Need a valid Olark ID!" unless options[:id] and options[:id].length.eql? 16
      @app, @options = app, Defaults.merge(options)
      @id, @format, @paths = [@options.delete(:id), @options.delete(:format), @options.delete(:paths)]
      @paths = @paths.class.eql?(Array) ? @paths.map {|path| path.class.eql?(Regexp) ? path : /^#{Regexp.escape(path.to_s)}$/} : []
      @option_js = "olark.identify('#{@id}');"
      @options.each do |key, val|
        @option_js << "olark.configure('#{key.to_s}', #{[String, Symbol].include? val.class ? "'#{val.to_s}'" : val.to_s});"
      end
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      @status, @headers, @response = @app.call env
      @request = Rack::Request.new env
      return [@status, @headers, @response] unless html? and (@paths.empty? or @paths.select {|path| @request.path_info =~ path}.length > 0)
      response = Rack::Response.new [], @status, @headers
      @response.each {|fragment| response.write inject(fragment)}
      response.finish
    end

    private

    def html?
      @headers['Content-Type'] =~ /html/
    end

    def inject(response)
      @template = Haml::Engine.new(::File.read(::File.expand_path('../templates/olark.haml', __FILE__)), {:format => @format}).render self
      response.gsub '</body>', @template
    end
  end
end
