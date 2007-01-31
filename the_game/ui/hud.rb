module UI
class Hud

  def initialize(menu, position)
    @position = position
    @menu = menu
    @hud_surface = Rubygame::Surface.new(@menu.size)
    @menu.draw(@hud_surface, @position)
  end

  def draw(destination)
    @hud_surface.blit(destination, @position)
  end

  def click(position)
    @menu.click(position)
  end

end
end
