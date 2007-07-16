require File.dirname(__FILE__)+'/component'
module Components
  class RadioButton < Component

    attr_reader :group

    def initialize(radius, group, value, checked = false)

      @radius = radius
      @group = group
      @value = value

      @background = Rubygame::Surface.new([radius * 2.1 , radius * 2.1])

      @background.fill([111,111,111])
      @background.set_colorkey(@background.get_at([0, 0]))

      @rect = @background.make_rect
      @center = @rect.center

      @little_radius = @radius / 1.3

      @background.draw_circle_s(@center, @radius , [255,255,255])

      @checked = checked
      check if @checked

      super()
    end

    def draw(destination)
      @background.blit(@screen, @rect.topleft)
    end

    def uncheck
      @checked = false
      @background.draw_circle_s(@center, @radius , [255,255,255])
    end

    def click(position)
      check
      notify(:clicked, self)
    end

    def check
      @checked = true
      @background.draw_circle_s(@center, @little_radius, [0,0,0])
    end

    def checked?
      @checked
    end
  end
end
