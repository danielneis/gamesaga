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

      @visual_buffer = VisualBuffer.new buffer_size, @background.width, @lines

      @ih = InputsHandler.new do |ih|
        ih.ignore = [Rubygame::MouseMotionEvent, Rubygame::MouseDownEvent, Rubygame::MouseUpEvent]

        ih.key_down = {Rubygame::K_ESCAPE    => lambda do throw :close_console end,
                       Rubygame::K_BACKSPACE => lambda do handle_backspace end,
                       Rubygame::K_RETURN    => lambda do handle_return end,
                       Rubygame::K_UP        => lambda do handle_up_arrow end,
                       Rubygame::K_DOWN      => lambda do handle_down_arrow end,
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
        @output = @renderer.render(@command_line, true, [0,0,0]) unless (@command_line.equal?(@visual_buffer.last) && @command_line.empty?)
        @output.blit(@background, [@mark.width,top])
      end

      unless @visual_buffer.empty?
        buffer_output = @visual_buffer.draw
        buffer_output.blit(@background, [0, visual_buffer_top])
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

      @visual_buffer.add @command_line
      begin
        pass_intro
      rescue NoMethodError => boom
        @visual_buffer.add boom.message
      ensure
        @command_line = ''
      end

      if @current_line < @lines - 1
        @current_line += 1
      end

      update_background(:all)
      @output = nil
    end

    def handle_up_arrow
      @command_line = @history_buffer.previous
      update_background(:current)
    end

    def handle_down_arrow
      @command_line = @history_buffer.next
      update_background(:current)
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

    def visual_buffer_top
      top - (@visual_buffer.size_used * @renderer.height)
    end
  end
end
