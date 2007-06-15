module Components

  class Component 
    
    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize
      setup_listeners()
      super()
    end

    def lost_focus
    end

    def click
    end

    def draw(destination)
      super(destination)
    end
  end

  class InputText < Component

    attr_reader :text

    def initialize(max_lenght = 10, position = [0,0])

      Rubygame::TTF.setup()

      @max_lenght = max_lenght;
      @position = position

      @renderer = Rubygame::TTF.new(FONT_ROOT+'default.ttf', 25)

      @background = Rubygame::Surface.new([150, @renderer.height])
      @background.fill([255,255,255])

      @queue = Rubygame::EventQueue.new
      @text = ''
      @output = nil
      @rect = @background.make_rect
      @rect.move!(*position)

      super()
    end

    def handle_input(input)

      temp = @text

      if (input.key == Rubygame::K_BACKSPACE)
        @text.chop!
        clear_background
      elsif (@text.size <= @max_lenght && 
             ((input.key >= Rubygame::K_0   && input.key <= Rubygame::K_9 )  || # numbers
             (input.key >= Rubygame::K_KP0 && input.key <= Rubygame::K_KP9) || # numbers from keypad
             (input.key >= Rubygame::K_A   && input.key <= Rubygame::K_Z)))     # letters
          @text += input.string
      end

      if (@text.empty?) 
        @output = Rubygame::Surface.new([0,0])
      else
        @output = @renderer.render(@text, true, [0,0,0]) unless (@text.equal? temp && @text.nil?)
      end
    end

    def draw(destination)
      if @output.respond_to? 'blit'
        @output.blit(@background, [0,0])
      end
      @background.blit(destination, @position)
    end

    def click(position)
      if @rect.collide_point?(*position)
        @background.fill([100,50,37])
      end
    end

    def lost_focus
      clear_background
    end

    private
    def clear_background
      @background.fill([255,255,255])
    end
  end
end
