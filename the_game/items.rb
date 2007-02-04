class Item

  include Rubygame::Sprites::Sprite

  attr_reader :effect, :rect

  def initialize(x, y, image, effect)
    super()
    @effect = effect
    @image = Rubygame::Image.load(PIX_ROOT+'items/'+image)
    @image.set_colorkey(@image.get_at([0, 0]))
    @rect = Rubygame::Rect.new(x, y, *@image.size)
  end

  def update
  end

end
