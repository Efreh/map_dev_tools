# frozen_string_literal: true

require_relative 'lib/map_dev_tools/version'

Gem::Specification.new do |spec|
  spec.name = 'map_dev_tools'
  spec.version = MapDevTools::VERSION
  spec.authors = ['Alexander Ludov']
  spec.email = ['efraam@gmail.com']

  spec.summary = 'Development tools for MapLibre GL JS styles with advanced filtering and terrain features'
  spec.description = 'A Ruby gem providing development tools for MapLibre GL JS styles, ' \
    'including advanced layer filtering, terrain visualization, ' \
    'elevation profiles, and performance monitoring.'
  spec.homepage = 'https://github.com/Efreh/map_dev_tools'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Efreh/map_dev_tools'
  spec.metadata['changelog_uri'] = 'https://github.com/Efreh/map_dev_tools/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore])
    end
  end
  spec.bindir = 'exe'
  spec.executables = []
  spec.require_paths = ['lib']

  # Dependencies
  spec.add_dependency 'rack', '>= 2.0', '< 4.0'
  spec.add_dependency 'sinatra', '>= 2.1', '< 5.0'
  spec.add_dependency 'slim', '>= 4.1', '< 6.0'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rack-test', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.0'
end
