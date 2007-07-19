require 'rubygame/sfont'
class Display < Rubygame::SFont

  Rubygame::TTF.setup()

  attr_reader :rect

  def initialize(label, position, text = '', size = 22, font = 'default')

    config = Configuration.instance

    @font = font
    @position = position
    @label = label
    @size = size
    @destination = Rubygame::Screen.get_surface()

    @renderer = Rubygame::TTF.new(config.font_root + @font + '.ttf', @size)
    @output = @renderer.render(@label + text, true, [0,0,0])

    @rect = @output.make_rect
    @rect.w += 300
    @rect.move!(*position)
  end

  def update(text = '')
    @output = @renderer.render(@label + text, true, [0,0,0])
    @output.blit(@destination, @position)
  end

end
