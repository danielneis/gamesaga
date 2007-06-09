module UI
module Buttons

  class Button

    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize(image)
      super()
      @image = Rubygame::Surface.load_image(image)
      @rect = @image.make_rect

      setup_listeners()
    end

    def click
    end
  end

  class Quit < Button

    def initialize
      super(PIX_ROOT+'menu/quit.png')
    end

    def click
      notify :quit_game
    end
  end

  class NewGame < Button

    def initialize
      super(PIX_ROOT+'menu/newgame.png')
    end

    def click
      notify :start_game
    end
  end

  class MainMenu < Button

    def initialize
      super(PIX_ROOT+'menu/mainmenu.png')
    end

    def click
      notify :main_menu
    end
  end
end
end
