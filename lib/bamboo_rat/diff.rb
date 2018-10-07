module BambooRat
  class Diff
    def initialize(path, branch = 'master')
      @path = path
      @branch = branch
      @tree = ComponentTree.new(path)
      @diff_components = diff_components
      self
    end

    def formatted_data
      {
        js_components: @tree.js_components,
        ruby_components: @tree.ruby_components,
        diff: @diff_components,
        components: @tree.components
      }
    end

    def diff_components
      files = `git diff #{@branch} --name-only`.split /\n/
      component_hash = {
        js: Set.new,
        ruby: Set.new
      }
      files.each do |file|
        @tree.components.each do |component|
          reg = Regexp.new "^#{component}"
          component_hash[component.name == 'Ruby' ? :ruby : :js] << component if reg.match("#{@path}#{file}")
        end
      end
    end
  end
end