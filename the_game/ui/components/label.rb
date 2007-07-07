require File.dirname(__FILE__)+'/component'
module Components

  class Label < Component

    def initialize(text)

      config = Configuration.instance

      Rubygame::TTF.setup()

      @renderer = Rubygame::TTF.new(config.font_root + 'default.ttf', 25)

      @background = Rubygame::Surface.new([150, @renderer.height])

      @background.fill([111,111,111])
      @background.set_colorkey(@background.get_at([0,0]))

      @rect = @background.make_rect

      @output = @renderer.render(text, true, [0,0,0])
      @output.blit(@background, [0,0])

      super()
    end

    def draw(destination)
      @background.blit(@screen, @rect.topleft)
    end
  end
end
