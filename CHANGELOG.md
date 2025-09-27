# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-09-27

### Added
- **Extracted MapLibre development tools** from existing tiles-proxy-cache project
- **Sinatra extension** for easy integration into existing applications
- **StaticMiddleware** for serving gem assets (JS files) without conflicts
- **Helper methods** for rendering map development interface
- **Standalone application** for testing and development purposes

### Extracted Features
- **Advanced layer filtering** with metadata support (from `filters.js`)
- **Terrain visualization** and elevation profiles (from `contour.js`)
- **Performance monitoring** and metrics display
- **Interactive style debugging** tools
- **Contour line generation** for terrain data using MapLibre Contour
- **Hover and click modes** for feature inspection
- **MapLibre GL JS integration** with version 5.7.3

### Refactored Components
- **Slim templates** (`map.slim`, `map_layout.slim`) adapted for gem structure
- **JavaScript modules** (`filters.js`, `contour.js`) preserved with original functionality
- **View rendering** with dynamic path resolution for gem integration
- **Configuration system** with sensible defaults for MapLibre development

### Technical Implementation
- **Ruby >= 2.7.0** support with modern gem structure
- **Sinatra 2.1+** compatibility and extension system
- **Rack middleware** for asset serving without path conflicts
- **Comprehensive test suite** with RSpec for all components
- **Clean gem structure** optimized for integration use cases

### Migration Notes
This gem extracts the MapLibre development tools that were previously embedded in the tiles-proxy-cache project, making them reusable across different Sinatra applications. The original functionality has been preserved while adding proper gem structure and integration capabilities.
