class Circle

  include Rubygame::Sprites::Sprite

  def initialize(*colors)
    super()
    @colors = colors
    @image = Rubygame::Surface.new([60,60])
    @image.draw_circle_s([30,30], 15, @colors[0])
    @rect = @image.make_rect
  end

  def click(pos)
    @image.draw_circle_s([30,30], 15, @colors[1])
  end
end
