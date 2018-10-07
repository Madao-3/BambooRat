require 'json'

module BambooRat
  class Diff
    def initialize(tree, path, branch, format)
      @tree = tree
      @path = path
      @branch = branch
      @format = format
      @diff_components = diff_components
      self
    end

    def formatted_data
      return { diff: @diff_components }.to_json if @format == 'simple'
      return @diff_components[:js].join(',') if @format == 'js'
      return @diff_components[:ruby].join(',' if @format == 'ruby'
      {
        js_components: @tree.js_components.map(&:path),
        ruby_components: @tree.ruby_components.map(&:path),
        diff: @diff_components,
        components: @tree.components.map(&:path)
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
          reg = Regexp.new "^#{component.path}"
          key = component.name == 'Ruby' ? :ruby : :js
          component_hash[key] << component.path if reg.match("#{@path}#{file}")
        end
      end
      component_hash[:js] = component_hash[:js].to_a
      component_hash[:ruby] = component_hash[:ruby].to_a
      component_hash
    end
  end
end
