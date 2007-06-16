module UI
class Hud

  def initialize(menu, vertical_align)
    @menu = menu
    @hud_surface = Rubygame::Surface.new(@menu.size)
    @hud_surface.set_alpha(255)
    @hud_surface.fill([123,123,123])
    @hud_surface.set_colorkey(@hud_surface.get_at([0,0]))

    @position = Array.new
    @position[0] = ((SCREEN_WIDTH - @menu.width) / 2)

    if vertical_align == :center
      @position[1] = ((SCREEN_HEIGHT - @menu.height) / 2)
    elsif vertical_align == :bottom
      @position[1] = SCREEN_HEIGHT - @menu.height
    elsif vertical_align == :top
      @position[1] = 0
    end

    @menu.draw(@hud_surface, @position)
  end

  def draw(destination)
    @hud_surface.blit(destination, @position)
  end

  def redraw(destination)
    @menu.redraw(@hud_surface)
  end

  def click(position)
    @menu.click(position)
  end

  def handle_input(input)
    @menu.handle_input(input)
  end

end
end
