require File.dirname(__FILE__) + '/buffer'
require File.dirname(__FILE__) + '/../lib/state.rb'
require File.dirname(__FILE__) + '/../lib/eventdispatcher'

module Console
  class BaseConsole < States::State

    include EventDispatcher

    def initialize(buffer_size = 30)
      @command_buffer = Buffer.new buffer_size
      @command_line = ''
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
      actual_command = tokenize(@command_line)
      execute actual_command
      @command_line = ''
    end

    def tokenize(line)
      line.split ' '
    end
    
    def execute(command)
      method = command.first
      arguments = command.values_at(1..(command.index command.last))
      send(method, *arguments)
    end
  end
end
