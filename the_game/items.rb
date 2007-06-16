class Item

  include EventDispatcher
  include Rubygame::Sprites::Sprite

  attr_reader :effect, :rect
  attr_accessor :catched

  def initialize(x, y, image, effect)

    super()

    config = YAML::load_file('config.yaml')

    @image = Rubygame::Surface.load_image(config['pix_root']+'items/'+image)
    @image.set_colorkey(@image.get_at([0, 0]))
    @rect = @image.make_rect
    @rect.move!(x,y)

    @effect = effect

    @catched = false
    
    setup_listeners()
  end

  def update
    notify(:item_catched, self) if @catched
  end

end
