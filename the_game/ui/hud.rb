module UI
class Hud

  def initialize(menu, vertical_align = :bottom, horizontal_align = :center)

    config = Configuration.instance

    @menu = menu
    @hud_surface = Rubygame::Surface.new(@menu.size)
    @hud_surface.set_alpha(255)
    @hud_surface.fill([123,123,123])
    @hud_surface.set_colorkey(@hud_surface.get_at([0,0]))

    @position = Array.new

    if horizontal_align == :left 
      @position[0] = 0
    elsif horizontal_align == :center
      @position[0] = (config.screen_width - @menu.width) / 2
    elsif horizontal_align == :right
      @position[0] = config.screen_width - @menu.width
    end

    if vertical_align == :middle
      @position[1] = (config.screen_height - @menu.height) / 2
    elsif vertical_align == :bottom
      @position[1] = config.screen_height - @menu.height
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
