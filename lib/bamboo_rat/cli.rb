require 'thor'

module BambooRat
  class CLI < Thor
    desc 'diff [PATH]', 'Show changed components.'
    method_option :branch, default: 'master',
                           aliases: '-b',
                           desc: 'Compare Branch'

    method_option :format, default: 'default',
                           aliases: '-f',
                           desc: 'Response Fromat'
    def diff(path = './')
      @tree = ComponentTree.new(path)
      puts Diff.new(@tree, path, options.branch, options.format).formatted_data
    end

    desc 'ls [PATH]', 'Show components list.'
    def ls(path = './')
      @tree = ComponentTree.new(path)
      puts @tree.components.map(&:path).join("\n")
    end
  end
end
