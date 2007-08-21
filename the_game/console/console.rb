require File.dirname(__FILE__) + '/buffer'

module Console
  class BaseConsole

    def initialize(buffer_size = 30)
      @command_buffer = Buffer.new buffer_size
      @command_line = nil
      @output = nil
    end

    def method_missing(method)
      puts "#{method} is an invalid command"
    end

    def handle_input
      temp = @command_line

      if (input.key == Rubygame::K_BACKSPACE)
        @command_line.chop!
        update_background
      elsif (input.key == Rubygame::K_ENTER)
        pass_intro
      elsif (@command_line.size <= @max_lenght && !input.string[/[a-z]*[A-Z]*[0-9]*\ */].empty?)
        @command_line += input.string
      end

      if (@command_line.empty?) 
        @output = Rubygame::Surface.new([0,0])
      else
        @output = @renderer.render(@command_line, true, [0,0,0]) unless (@command_line.equal? temp && @command_line.nil?)
      end
    end

    private
    def pass_intro
      parse_command_line unless @command_line.empty?
    end

    def parse_command_line
      @command_buffer.add_content(@command_line)
      actual_command = tokenize(@command_line)
      execute actual_command
      @command_line = nil
    end

    def tokenize(line)
      line.split ' '
    end
    
    def execute(command)
      method = command.first
      arguments = command.values_at(1..(a.index a.last))
      send(method, *arguments)
    end
  end
end
