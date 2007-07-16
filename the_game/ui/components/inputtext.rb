require File.dirname(__FILE__)+'/component'
module Components

  class InputText < Component

    attr_reader :text

    def initialize(max_lenght = 10, id = "it", text = '')

      @id = id
      config = Configuration.instance

      Rubygame::TTF.setup()

      @max_lenght = max_lenght;

      @renderer = Rubygame::TTF.new(config.font_root + 'default.ttf', 25)

      @background = Rubygame::Surface.new([150, @renderer.height])
      @background_color = [255,255,255]
      update_background

      @text = text
      @output = nil
      if @text == ''
        @output = nil
      else
        @output = @renderer.render(@text, true, [0,0,0])
      end
      @rect = @background.make_rect

      super()
    end

    def handle_input(input)

      temp = @text

      if (input.key == Rubygame::K_BACKSPACE)
        @text.chop!
        update_background
      elsif (@text.size <= @max_lenght && !input.string[/[a-z]*[A-Z]*[0-9]*\ */].empty?)
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
      @background.blit(@screen, @rect.topleft)
    end

    def click(position)
      @background_color = [100,50,37]
      update_background
    end

    def lost_focus
      @background_color = [255,255,255]
      update_background
    end

    def value
      @text
    end

    private
    def update_background
      @background.fill(@background_color)
    end
  end
end
