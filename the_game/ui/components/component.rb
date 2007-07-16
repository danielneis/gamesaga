module Components
  class Component 
    
    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_reader :id, :value

    def initialize
      @screen = Rubygame::Screen.get_surface
      setup_listeners()
      super()
    end

    def get_focus
    end

    def lost_focus
    end

    def click(position)
    end

    def handle_input(input)
    end

    def move!(*pos)
      @rect.move!(*pos)
    end

    def width
      @rect.w
    end

    def height
      @rect.h
    end

    def collide_point?(*position)
      @rect.collide_point?(*position)
    end
  end
end
