module UI
module Buttons

  class Button

    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize(image, state_machine)
      super()
      @image = Rubygame::Image.load(image)
      @rect = Rubygame::Rect.new(0,0,*@image.size)

      @state_machine = state_machine
    end

    def click
    end

  end

  class Quit < Button

    def initialize(state_machine)
      super(PIX_ROOT+'menu/quit.png', state_machine)
    end

    def click
      throw :end_game
    end
  end

  class NewGame < Button

    def initialize(state_machine)
      super(PIX_ROOT+'menu/newgame.png', state_machine)
    end

    def click
      @state_machine.change_state(States::Game::Run)
    end
  end

  class MainMenu < Button

    def initialize(state_machine)
      super(PIX_ROOT+'menu/mainmenu.png', state_machine)
    end

    def click
      @state_machine.change_state(States::Game::MainMenu)
      #throw :run_game
    end
  end
end
end
