module UI
module Buttons
module Text

  class Button < UI::Buttons::Button

    Rubygame::TTF.setup()

    def initialize(text, font, size, color = [0,0,0])
      super()

      renderer = Rubygame::TTF.new('lib/'+font+'.ttf', size)
      @output = renderer.render(text, true, color)
      @rect = @output.make_rect
    end

    def draw(destination)
      @output.blit(destination, @rect)
    end

  end

  class MainMenu < Button

    def initialize
      super('Main Menu', 'valium', 60)
    end

    def click
      notify :main_menu
    end
  end

  class NewGame < Button
    
    def initialize
      super('New Game', 'valium', 60)
    end

    def click
      notify :start_game
    end
  end

  class Quit < Button

    def initialize
      super('Quit', 'valium', 60)
    end

    def click
      notify :quit_game
    end
  end

end
end
end
