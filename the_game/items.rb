class Item

  include Observable
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
    
    # from observable class...
    @listeners = []
  end

  def update
    notify_listeners('item_catched') if @catched
  end

end
