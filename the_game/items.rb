class Item

  include EventDispatcher
  include Rubygame::Sprites::Sprite

  attr_reader :effect, :rect
  attr_accessor :catched

  def initialize(x, y, image, effect)

    super()

    @image = Rubygame::Image.load(PIX_ROOT+'items/'+image)
    @image.set_colorkey(@image.get_at([0, 0]))
    @rect = Rubygame::Rect.new(x, y, *@image.size)

    @effect = effect

    @catched = false
    
    setup_listeners()
  end

  def update
    notify(:item_catched, self) if @catched
  end

end
