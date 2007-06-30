require File.dirname(__FILE__)+'/component'
module Components
  class RadioButton < Component

    def initialize(radius)

      @background = Rubygame::Surface.new([radius * 2, radius * 2])
      @rect = @background.make_rect
      @center = @rect.center
      @radius = radius
      @little_radius = @radius / 1.3
      @background.fill([111,111,111])
      @background.set_colorkey(@background.get_at([0, 0]))
      lost_focus

      super()
    end

    def draw(destination)
      @background.blit(destination, @center)
    end

    def lost_focus
      @background.draw_circle_s(@center, @radius , [255,255,255])
    end

    def click
      @background.fill([0,0,0], [0, 0, @radius, @radius])
    end
  end
end
