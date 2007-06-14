module Components

  class InputText

    attr_reader :text

    def initialize(max_lenght = 10, position = [0,0])

      Rubygame::TTF.setup()

      @max_lenght = max_lenght;
      @position = position

      @renderer = Rubygame::TTF.new(FONT_ROOT+'default.ttf', 15)

      @background = Rubygame::Surface.new([150, @renderer.height])
      @background.fill([255,255,255])

      @queue = Rubygame::EventQueue.new
      @text = ''
      @output = nil
    end

    def handle_input(input)

      temp = @text

      if (input.key == Rubygame::K_BACKSPACE)
        @text.chop!
        clear_background
      elsif (@text.size <= @max_lenght && 
             (input.key >= Rubygame::K_0   && input.key <= Rubygame::K_9 )  || # numbers
             (input.key >= Rubygame::K_KP0 && input.key <= Rubygame::K_KP9) || # numbers from keypad
             (input.key >= Rubygame::K_A   && input.key <= Rubygame::K_Z))     # letters
          @text += input.string
      end

      if (@text.empty?) 
        @output = Rubygame::Surface.new([0,0])
      else
        @output = @renderer.render(@text, true, [0,0,0]) unless (@text.equal? temp && @text.nil?)
      end
    end

    def show_text(destination)
      if @output.respond_to? 'blit'
        @output.blit(@background, [0,0])
      end
      @background.blit(destination, @position)
    end

    private
    def clear_background
      @background.fill([255,255,255])
    end
  end
end
