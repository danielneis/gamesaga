require File.dirname(__FILE__) + '/buffer'
require File.dirname(__FILE__) + '/../lib/state.rb'
require File.dirname(__FILE__) + '/../lib/eventdispatcher'

module Console
  class BaseConsole < States::State

    include EventDispatcher

    def initialize(buffer_size = 30, commands = {})
      @command_buffer = Buffer.new buffer_size
      @command_line = ''
      @commands = commands
      setup_listeners
    end

    def method_missing(*method)
      puts "<#{method.first}> is an invalid command"
    end

    private
    def pass_intro
      parse_command_line unless @command_line.empty?
    end

    def parse_command_line
      @command_buffer.add_content(@command_line)
      command, parameters = tokenize(@command_line)
      execute(command, parameters)

      
      @command_line = ''
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
        puts "<#{command}> is an invalid command"
      end
    end
  end
end
