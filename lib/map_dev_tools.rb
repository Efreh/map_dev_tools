# frozen_string_literal: true

require 'sinatra/base'
require 'slim'
require 'rack'

module MapDevTools
  # Fixed versions for guaranteed compatibility
  MAPLIBRE_VERSION = '5.7.3'
  CONTOUR_VERSION = '0.1.0'
  D3_VERSION = '7'

  DEFAULT_OPTIONS = {
    style_url: nil,
    external_style_url: nil,
    basemap_tiles: [
      'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png',
      'https://b.tile.openstreetmap.org/{z}/{x}/{y}.png',
      'https://c.tile.openstreetmap.org/{z}/{x}/{y}.png'
    ],
    basemap_attribution: '© OpenStreetMap contributors',
    basemap_opacity: 0.8,
    center: [35.15, 47.41],
    zoom: 2
  }.freeze

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
      app.set :map_dev_tools_options, DEFAULT_OPTIONS
      app.use StaticMiddleware
    end
  end

  # Helper methods for map development tools
  module Helpers
    def render_map_dev_tools(options = {})
      render_with_gem_views(:map, layout: :map_layout, options: options)
    end

    def render_map_layout(options = {})
      render_with_gem_views(:map_layout, options: options)
    end

    private

    def render_with_gem_views(template, layout: nil, options: {})
      merged_options = settings.map_dev_tools_options.merge(options)
      gem_views_path = File.expand_path('map_dev_tools/views', __dir__)

      with_gem_views(gem_views_path) do
        render_template(template, layout, merged_options)
      end
    end

    def with_gem_views(gem_views_path)
      original_views = settings.views
      settings.set :views, gem_views_path
      yield
    ensure
      settings.set :views, original_views
    end

    def render_template(template, layout, options)
      if layout
        slim(template, layout: layout, locals: { options: options })
      else
        slim(template, locals: { options: options })
      end
    end

    def style_url
      external_style_url = params[:style_url]
      options_style_url = settings.map_dev_tools_options[:style_url]

      external_style_url || options_style_url
    end

    def should_show_map?
      !!(params[:style] || params[:style_url] || params[:source] || settings.map_dev_tools_options[:style_url])
    end
  end

  # Standalone Sinatra application for map development
  class App < Sinatra::Base
    register Extension

    configure do
      set :views, File.expand_path('map_dev_tools/views', __dir__)
      set :public_folder, File.expand_path('map_dev_tools/public', __dir__)
      set :map_dev_tools_options, DEFAULT_OPTIONS
    end

    get '/js/:file' do
      serve_js_file(params[:file])
    end

    get '/map' do
      options = settings.map_dev_tools_options
      slim :map, layout: :map_layout, locals: { options: options }
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
