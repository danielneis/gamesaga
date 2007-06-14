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
    include UI::Buttons::MainMenu

    def initialize
      super('Main Menu', 'valium', 40)
    end
  end

  class NewGame < Button
    include UI::Buttons::NewGame
    
    def initialize
      super('New Game', 'valium', 40)
    end

  end

  class Quit < Button
    include UI::Buttons::Quit

    def initialize
      super('Quit', 'valium', 40)
    end
  end

  class Options < Button
    include UI::Buttons::Options

    def initialize
      super('Options', 'valium', 40)
    end
  end
end
end
end
