# MapDevTools

A Ruby gem providing development tools for MapLibre GL JS styles with advanced filtering, terrain visualization, and performance monitoring capabilities. Designed for seamless integration into Sinatra applications.

[![Ruby](https://img.shields.io/badge/ruby-2.7+-red.svg)](https://ruby-lang.org)
[![Sinatra](https://img.shields.io/badge/sinatra-web_framework-lightgrey.svg)](http://sinatrarb.com/)
[![MapLibre](https://img.shields.io/badge/maplibre-gl_js-blue.svg)](https://maplibre.org/)
[![Русский](https://img.shields.io/badge/русский-документация-orange.svg)](docs/README_RU.md)

## Key Features

- **Advanced Layer Filtering**: Metadata-driven layer filtering with support for complex filter expressions
- **Terrain Visualization**: Full terrain support with elevation profiles and contour line generation
- **Performance Monitoring**: Real-time FPS, memory usage, and tile loading metrics
- **Interactive Debugging**: Hover and click modes for feature inspection
- **Sinatra Integration**: Seamless integration as Sinatra extension with helper methods
- **Static Asset Serving**: Built-in middleware for serving JavaScript modules without conflicts

## Architecture Overview

The gem consists of several integrated components:

### Core Components

- **[Main Module](lib/map_dev_tools.rb)** - Core gem functionality including Sinatra extension, Rack middleware, helper methods, and standalone application
- **[Slim Templates](lib/map_dev_tools/views/)** - HTML templates for map interface
- **[JavaScript Modules](lib/map_dev_tools/public/js/)** - Client-side filtering and terrain logic

### Data Flow

1. **Sinatra Integration** → Register extension → Configure options → Use helpers
2. **Asset Serving** → StaticMiddleware intercepts `/js/*` requests → Serves from gem
3. **Map Rendering** → Helper methods render Slim templates → Include external dependencies
4. **Client Interaction** → JavaScript modules handle filtering and terrain features

## Quick Start

### Installation

Add to your Gemfile:

```ruby
gem 'map_dev_tools'
```

Then run:

```bash
bundle install
```

### Basic Integration

```ruby
require 'map_dev_tools'

class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  # Configure map options
  set :map_dev_tools_options, {
    style_url: 'https://your-style-url.com/style.json',
    center: [35.15, 47.41],
    zoom: 2
  }
  
  get '/map' do
    render_map_dev_tools
  end
end
```

### Standalone Development Server

The gem includes a complete Sinatra application for testing and development:

```ruby
require 'map_dev_tools'

# Run standalone development server
MapDevTools::App.run!
```

This starts a complete web server with:
- Map interface at `http://localhost:4567/map`
- JavaScript assets served from `/js/*`
- All gem functionality available out of the box

**How to use with a style:**
- Pass style URL as parameter: `http://localhost:4567/map?style_url=https://example.com/style.json`
- Or configure default style in options:
```ruby
MapDevTools::App.set :map_dev_tools_options, {
  style_url: 'https://example.com/style.json'
}
```

**Without a style:**
- Shows only basemap tiles (OpenStreetMap)
- Useful for testing basic functionality
- No custom layers or styling

**Use cases:**
- Quick testing of gem functionality
- Development and debugging
- Demonstrating capabilities

## Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `style_url` | `nil` | Default MapLibre style URL to load |
| `external_style_url` | `nil` | External style URL parameter |
| `center` | `[35.15, 47.41]` | Initial map center coordinates |
| `zoom` | `2` | Initial zoom level |
| `basemap_tiles` | OpenStreetMap tiles | Basemap tile URLs array |
| `basemap_attribution` | `'© OpenStreetMap contributors'` | Basemap attribution text |
| `basemap_opacity` | `0.8` | Basemap layer opacity |

**Note:** Library versions (MapLibre GL JS 5.7.3, MapLibre Contour 0.1.0, D3.js 7)

## API Reference

### Sinatra Extension

```ruby
# Register the extension
register MapDevTools::Extension

# Configure options
set :map_dev_tools_options, {
  style_url: 'https://example.com/style.json',
  center: [0, 0],
  zoom: 5
}
```

### Helper Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `render_map_dev_tools(options = {})` | Render complete map development interface | `options` - Hash of configuration overrides |
| `render_map_layout(options = {})` | Render map layout only | `options` - Hash of configuration overrides |
| `style_url` | Get current style URL from params or options | None |
| `should_show_map?` | Check if map should be displayed | None |

### Standalone Application

```ruby
# Available routes
GET /map          # Main map development interface
GET /js/:file     # JavaScript asset serving
```

## Style Metadata Support

The gem supports advanced filtering through style metadata:

```json
{
  "metadata": {
    "filters": {
      "buildings": [
        {
          "id": "residential",
          "filter": ["==", ["get", "type"], "residential"]
        },
        {
          "id": "commercial", 
          "filter": ["==", ["get", "type"], "commercial"]
        }
      ]
    },
    "locale": {
      "en": {
        "buildings": "Buildings",
        "residential": "Residential",
        "commercial": "Commercial"
      }
    }
  }
}
```

## Terrain Support

For terrain visualization, add terrain configuration to your style:

```json
{
  "terrain": {
    "source": "terrain-source"
  },
  "sources": {
    "terrain-source": {
      "type": "raster-dem",
      "tiles": ["https://your-terrain-tiles/{z}/{x}/{y}.png"],
      "encoding": "terrarium"
    }
  }
}
```

## Performance Monitoring

The gem includes real-time performance monitoring:

- **FPS and Frame Time**: Real-time rendering performance
- **Memory Usage**: JavaScript heap memory monitoring
- **Tile Loading**: Active tile count and loading status
- **Layer Management**: Active layer count and visibility
- **Zoom Level**: Current map zoom level
- **Terrain Status**: Terrain data availability

## File Structure

```
lib/
├── map_dev_tools.rb              # Main gem module and Sinatra integration
└── map_dev_tools/
    ├── version.rb                # Gem version
    ├── views/                    # Slim templates
    │   ├── map.slim             # Main map interface
    │   └── map_layout.slim      # HTML layout
    └── public/js/               # JavaScript modules
        ├── filters.js           # Layer filtering logic
        └── contour.js           # Terrain and contour features
```

## Development

### Prerequisites

- Ruby 2.7+
- Sinatra 2.1+
- Slim 4.1+
- Rack 2.0+

### Setup

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run RuboCop
bundle exec rubocop

# Build gem
gem build map_dev_tools.gemspec
```

### Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/map_dev_tools_spec.rb
```

## Integration Examples

### Basic Map Integration

```ruby
class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  get '/map' do
    render_map_dev_tools({
      style_url: 'https://api.maptiler.com/maps/streets/style.json?key=YOUR_KEY'
    })
  end
end
```

### Custom Configuration

```ruby
class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  configure do
    set :map_dev_tools_options, {
      center: [37.6173, 55.7558],  # Moscow coordinates
      zoom: 10,
      basemap_tiles: [
        'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
      ],
      basemap_attribution: '© OpenStreetMap contributors'
    }
  end
  
  get '/map' do
    render_map_dev_tools
  end
end
```

### Multiple Map Routes

```ruby
class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  get '/map' do
    render_map_dev_tools({
      style_url: params[:style_url]
    })
  end
  
  get '/terrain' do
    render_map_dev_tools({
      style_url: 'https://example.com/terrain-style.json'
    })
  end
end
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.