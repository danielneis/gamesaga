require File.dirname(__FILE__)+'/component'
module Components
  class Checkbox < Component

    def initialize(side, id = "cb", checked = false)

      @id = id
      @checked = !checked

      @screen = Rubygame::Screen.get_surface
      @background = Rubygame::Surface.new([side, side])
      @rect = @background.make_rect
      @background.fill([255,255,255])

      @s_point = [@rect.x, @rect.y]
      @v_point = [@rect.r / 2.5, @rect.b]
      @e_point = [@rect.r, @rect.y]

      click

      super()
    end

    def draw(destination)
      @background.blit(@screen, @rect.topleft)
    end

    def click

      if (@checked)
        @background.fill([255,255,255])
        @checked = false
      else
        @background.draw_line(@s_point, @v_point, [0,0,0])
        @background.draw_line(@v_point, @e_point, [0,0,0])
        @checked = true
      end

    end

    def value
      @checked
    end
  end
end
