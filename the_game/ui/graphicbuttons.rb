module UI
module Buttons
module Graphic

  class Button < UI::Buttons::Button

    def initialize(image)
      super()
      @image = Rubygame::Surface.load_image(image)
      @rect = @image.make_rect
    end
  end

  class Quit < Button

    include UI::Buttons::Quit

    def initialize
      super(PIX_ROOT+'menu/quit.png')
    end
  end

  class NewGame < Button

    include UI::Buttons::NewGame

    def initialize
      super(PIX_ROOT+'menu/newgame.png')
    end
  end

  class MainMenu < Button

    include UI::Buttons::MainMenu

    def initialize
      super(PIX_ROOT+'menu/mainmenu.png')
    end
  end
end
end
end
