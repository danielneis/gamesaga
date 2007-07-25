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

      @ground = @rect.bottom

      @col_rect = @rect.dup
      @col_rect.width /= 2.3
      @col_rect.height /= 17
      @col_rect.t = @rect.b - @col_rect.h
      @col_rect.x = @rect.x + @col_rect.w / 2
    end
  end
end
