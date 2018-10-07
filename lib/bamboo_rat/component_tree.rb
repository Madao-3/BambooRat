module BambooRat
  class ComponentTree
    def initialize(path)
      @ruby_components = Set.new
      @js_components = Set.new
      @components = map_components

      self
    end

    def map_components
      folders = Dir['*/*'].select do |entry|
        File.directory? entry
      end
      folders.each do |path|
        @ruby_components << path if RubyComponent.ruby?(path)
        @js_components << path if JSComponent.js?(path)
      end
      @ruby_components + @js_components
    end

    def formated_data(format)
      {
        components: @components,
        ruby_components: @ruby_components,
        js_components: @js_components
      }
    end
  end

  class RubyComponent
    def initialize(path)
      @path = path
    end

    def self.gem_path(path)
      path + '/Gemfile'
    end

    def self.ruby?(path)
      File.exist?(gem_path(path))
    end
  end

  class JSComponent
    def initialize(path)
      @path = path
    end

    def self.package_path(path)
      path + '/package.json'
    end

    def self.js?(path)
      File.exist?(package_path(path))
    end
  end
end
