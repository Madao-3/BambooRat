module BambooRat
  class ComponentTree
    attr_reader :ruby_components, :js, :components
  
    def initialize(path)
      @path = path
      @branch = branch
      @ruby_components = Set.new
      @js_components = Set.new
      @components = map_components
      self
    end
    
    def map_components
      folders = Dir[File.join(@path, "/*/*")].select do |entry|
        File.directory? entry
      end
      folders.each do |path|
        @ruby_components << RubyComponent.new(path) if RubyComponent.ruby?(path)
        @js_components << JSComponent.new(path) if JSComponent.js?(path)
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

  def Component
    def initialize(path)
      @path = path
    end

    def name
      raise NotImplementedError
    end
  end

  class RubyComponent
    def name
      'Ruby'
    end

    def self.gem_path(path)
      path + '/Gemfile'
    end

    def self.ruby?(path)
      File.exist?(gem_path(path))
    end
  end

  class JSComponent
    def name
      'JS'
    end

    def self.package_path(path)
      path + '/package.json'
    end

    def self.js?(path)
      File.exist?(package_path(path))
    end
  end
end
