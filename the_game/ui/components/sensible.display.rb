require File.dirname(__FILE__)+'/component'
module Components

  class SensibleDisplay < Component

    attr_reader :text

    def initialize(id, text)
      super()

      @id = id
      @text = text

      Rubygame::TTF.setup()

      config = Configuration.instance
      @renderer = Rubygame::TTF.new(config.font_root + 'default.ttf', 25)

      @background = Rubygame::Surface.new([150, @renderer.height])
      @background_color = [255,255,255]
      update_background

      @output = @renderer.render(@text, true, [0,0,0])

      @rect = @background.make_rect
    end

    def draw(destination)
      @output.blit(@background, [0,0])
      @background.blit(@screen, @rect.topleft)
    end

    def click(position)
      notify :sensible_display_clicked, self
    end

    private
    def update_background
      @background.fill(@background_color)
    end

  end
end
