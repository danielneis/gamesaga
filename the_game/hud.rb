class Hud

  def initialize(menu, size)
    @menu = menu
    @hud_surface = Rubygame::Surface.new(size)
    @menu.draw(@hud_surface)
  end

  def draw(destination)
    @hud_surface.blit(destination, [0,0])
  end
end
