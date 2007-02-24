class Display < Rubygame::SFont

  Rubygame::TTF.setup()

  def initialize(label, position, text = '', size = 12)
    @position = position
    @label = label
    @size = size
    @destination = Rubygame::Screen.get_surface()

    @font = Rubygame::TTF.new('font.ttf', @size)
    @render = @font.render(@label + text, true, [0,0,0])
  end

  def update(text = '')
    @render = @font.render(@label + text, true, [0,0,0])
    @render.blit(@destination, @position)
  end

end
