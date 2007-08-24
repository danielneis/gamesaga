require File.dirname(__FILE__) + '/console'
require File.dirname(__FILE__) + '/visual.buffer'

module Console
  class TextConsole < BaseConsole

    attr_reader :rect

    def initialize(lines = 5, buffer_size = 10, mark = '$ ')

      super()

      @lines = lines

      config = Configuration.instance

      @screen = Rubygame::Screen.get_surface

      Rubygame::TTF.setup()
      @renderer = Rubygame::TTF.new(config.font_root + 'default.ttf', 25)
      @mark = @renderer.render(mark, true, [0,0,0])

      @background = Rubygame::Surface.new([config.screen_width, @lines * @renderer.height])
      @background_color = [255,255,255]

      @rect = @background.make_rect
      @current_line = 0

      update_background

      @command_buffer = VisualBuffer.new buffer_size, @background.width, @lines

      @ih = InputsHandler.new do |ih|
        ih.ignore = [Rubygame::MouseMotionEvent, Rubygame::MouseDownEvent, Rubygame::MouseUpEvent]

        ih.key_down = {Rubygame::K_ESCAPE    => lambda do throw :close_console end,
                       Rubygame::K_BACKSPACE => lambda do handle_backspace end,
                       Rubygame::K_RETURN    => lambda do handle_return end,
                       :any                  => lambda do |event| handle_generic_input event end}
      end

    end

    def update
      @ih.handle
    end

    def draw(destination)
      @mark.blit(@background, [0, top]) 
      if (@command_line.empty?) 
        @output = nil
      else
        @output = @renderer.render(@command_line, true, [0,0,0]) unless (@command_line.equal?(@command_buffer.last) && @command_line.empty?)
        @output.blit(@background, [@mark.width,top])
      end

      unless @command_buffer.empty?
        buffer_output = @command_buffer.draw
        buffer_output.blit(@background, [0, buffer_top])
      end
      @background.blit(@screen, [0,0])
    end

    private 
    def handle_generic_input(input)
      @command_line

      if !input.string[/[a-z]*[A-Z]*[0-9]*\ */].empty?
        @command_line += input.string
      end
    end

    def handle_backspace
      @command_line.chop!
      update_background(:current)
    end

    def handle_return
      pass_intro
      if @current_line < @lines - 1
        @current_line += 1
      end
      update_background(:all)
      @output = nil
    end

    def update_background(line = :all)
      if line == :all
        @background.fill(@background_color)
      else
        @background.fill(@background_color, [0, top, @rect.w, @renderer.height])
      end
    end

    def top
      @current_line * @renderer.height
    end

    def buffer_top
      top - (@command_buffer.size_used * @renderer.height)
    end
  end
end
