require 'thor'

module BambooRat
  class CLI < Thor
    desc "diff [PATH]", "Show changed components."
    method_option :format, default: "json", aliases: "-f", desc: "Response Fromat"
    def diff(path)
      @tree = ComponentTree.new(path)
      puts @tree.format_data(options.format)
    end
  end
end
