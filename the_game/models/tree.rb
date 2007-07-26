require File.dirname(__FILE__) + '/model'

module Models
  class Tree < Model

    def initialize(position, size)

      super()
      config = Configuration.instance

      @image = Rubygame::Surface.load_image(config.pix_root + 'objects/' + 'arvore.png')
      @image.set_colorkey(@image.get_at([0,0]))
      @image = @image.zoom_to(*size)
      @rect = @image.make_rect
      @rect.move!(*position)
    end

    def ground
      (@rect.bottom)..(@rect.bottom - @rect.height / 17)
    end
  end
end
