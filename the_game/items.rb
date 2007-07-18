class Item

  include EventDispatcher
  include Rubygame::Sprites::Sprite

  attr_reader :ground

  def initialize(x, y, image, effect)

    super()

    config = Configuration.instance

    @image = Rubygame::Surface.load_image(config.pix_root + 'items/'+image)
    @image.set_colorkey(@image.get_at([0, 0]))
    @rect = @image.make_rect
    @rect.move!(x,y)
    
    @ground = @rect.bottom

    @effect = effect

    setup_listeners()
  end

  def catched
    notify(:item_catched, self)
  end

  def each_effect
    @effect.each { |e| yield e }
  end
end
