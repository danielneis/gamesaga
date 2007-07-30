require File.dirname(__FILE__) + '/model'

module Models
  class Piece < Model

    def initialize(pos, size, image)

      super()

      config = Configuration.instance
      @image = Rubygame::Surface.load_image(config.pix_root + 'objects/' + image + '.png')

      @image.set_colorkey(@image.get_at([0,0]))
      @image = @image.zoom_to(*size)
      @rect = @image.make_rect
      @rect.move!(*pos)
    end
  end

  class Tree < Piece

    def initialize(pos, size)
      super(pos, size, 'arvore')

      @col_rect = @rect.dup
      @col_rect.w = @rect.w / 2.5
      @col_rect.x = @rect.x + @col_rect.w / 2
    end

    def ground
      (@col_rect.b - @col_rect.h / 17)..(@col_rect.bottom)
    end
  end
end
