module UI
module Buttons
  class Quit

    include Rubygame::Sprites::Sprite
    attr_accessor :rect

    def initialize(image = PIX_ROOT+'menu/quit.png')
      super()
      @image = Rubygame::Image.load(image)
      @rect = Rubygame::Rect.new(0,0,*@image.size)
    end

    #def click(selection, pointer)
    def click()
      exit
    end
  end
end
end
