require File.dirname(__FILE__) + '/buffer'
require File.dirname(__FILE__) + '/../lib/state.rb'
require File.dirname(__FILE__) + '/../lib/eventdispatcher'

module Console
  class BaseConsole < States::State

    include EventDispatcher

    def initialize(buffer_size = 30)
      @history_buffer = Buffer.new buffer_size
      @command_line = ''
      setup_listeners

      @commands = {:help => lambda do help end}
      yield @commands
    end

    private
    def pass_intro
      parse_command_line unless @command_line.empty?
    end

    def parse_command_line
      @history_buffer.add @command_line
      command, parameters = tokenize(@command_line)
      @command_line = ''
      execute(command, parameters)
    end

    def tokenize(line)
      line = line.split ' '
      return line.first.to_sym, [line.values_at(1..(line.index line.last))]
    end

    def execute(command, parameters)
      if @commands.has_key? command
        if @commands[command].respond_to? :call
          @commands[command].call(*parameters)
        elsif self.respond_to? command
          send(command, *parameters)
        end
      else
        raise NoMethodError, "<#{command}> is an invalid command"
      end
    end

    def help
      c = @commands.keys
      c.inspect.gsub ':', ''
    end
  end
end
