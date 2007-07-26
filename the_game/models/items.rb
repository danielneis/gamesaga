require File.dirname(__FILE__) + '/model'

module Models
  class Item < Model

    def initialize(pos, image, effect)

      super()

      config = Configuration.instance

      @image = Rubygame::Surface.load_image(config.pix_root + 'items/' + image + '.png')
      @image.set_colorkey(@image.get_at([0, 0]))
      @rect = @image.make_rect
      @rect.move!(*pos)
      
      @effect = effect
    end

    def catched
      notify(:item_catched, self)
    end

    def each_effect
      @effect.each { |e| yield e }
    end
  end

  class Chicken < Item

    def initialize(pos)
      super(pos, 'chicken', {:life => 50})
    end
  end

  class Meat <Item

    def initialize(pos)
      super(pos, 'meat', {:life => 50})
    end
  end
end
