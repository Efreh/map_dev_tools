# frozen_string_literal: true

require 'sinatra/base'
require 'slim'
require 'rack'

module MapDevTools
  # Fixed versions for guaranteed compatibility
  MAPLIBRE_VERSION = '5.7.3'
  CONTOUR_VERSION = '0.1.0'
  D3_VERSION = '7'

  # Rack middleware for serving static JS files from gem
  class StaticMiddleware
    def initialize(app)
      @app = app
      @gem_public_path = File.expand_path('map_dev_tools/public', __dir__)
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.path.match?(%r{^/js/})
        serve_js_file(request.path)
      else
        @app.call(env)
      end
    end

    private

    def serve_js_file(path)
      file_path = File.join(@gem_public_path, path)

      if File.exist?(file_path) && File.file?(file_path)
        [200, { 'Content-Type' => 'application/javascript' }, [File.read(file_path)]]
      else
        [404, { 'Content-Type' => 'text/plain' }, ['File not found']]
      end
    end
  end

  # Sinatra extension for map development tools
  module Extension
    def self.registered(app)
      app.helpers Helpers
      app.use StaticMiddleware
    end
  end

  # Helper methods for map development tools
  module Helpers
    def render_map_dev_tools
      gem_views_path = File.expand_path('map_dev_tools/views', __dir__)
      original_views = settings.views
      settings.set :views, gem_views_path
      slim(:map, layout: :map_layout)
    ensure
      settings.set :views, original_views
    end

    def render_map_layout
      gem_views_path = File.expand_path('map_dev_tools/views', __dir__)
      original_views = settings.views

      settings.set :views, gem_views_path
      slim(:map_layout)
    ensure
      settings.set :views, original_views
    end

    def style_url
      params[:style_url]
    end

    def should_show_map?
      !!(params[:style] || params[:style_url] || params[:source])
    end
  end

  # Standalone Sinatra application for map development
  class App < Sinatra::Base
    register Extension

    configure do
      set :views, File.expand_path('map_dev_tools/views', __dir__)
      set :public_folder, File.expand_path('map_dev_tools/public', __dir__)
    end

    get '/js/:file' do
      serve_js_file(params[:file])
    end

    get '/map' do
      slim :map, layout: :map_layout
    end

    private

    def serve_js_file(filename)
      gem_js_path = File.expand_path("map_dev_tools/public/js/#{filename}", __dir__)
      if File.exist?(gem_js_path)
        content_type 'application/javascript'
        File.read(gem_js_path)
      else
        status 404
        'File not found'
      end
    end
  end
end

Sinatra.register MapDevTools::Extension
