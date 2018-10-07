require 'thor'

module BambooRat
  class CLI < Thor
    desc 'diff [PATH]', 'Show changed components.'
    method_option :format, default: 'json',
                           aliases: '-f',
                           desc: 'Response Fromat'
    def diff(path)
      puts Diff.new(path, options.format).formatted_data
    end
  end
end
