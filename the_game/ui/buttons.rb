module UI
module Buttons

  class Button

    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize(image)
      super()
      @image = Rubygame::Image.load(image)
      @rect = Rubygame::Rect.new(0,0,*@image.size)
    end

    def click
    end

  end

  class Quit < Button

    def initialize
      super(PIX_ROOT+'menu/quit.png')
    end

    def click
      throw :end_game
    end
  end

  class NewGame < Button

    def initialize()
      super(PIX_ROOT+'menu/newgame.png')
    end

    def click
      Game::start()
      throw :game_start
    end
  end

  class MainMenu < Button

    def initialize()
      super(PIX_ROOT+'menu/mainmenu.png')
    end

    def click
      throw :run_game
    end
  end
end
end
