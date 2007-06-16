module Components
  class Component 
    
    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize
      @screen = Rubygame::Screen.get_surface
      setup_listeners()
      super()
    end

    def lost_focus
    end

    def click
    end

    def draw(destination)
      super(destination)
    end

    def handle_input(input)
    end
  end
end
