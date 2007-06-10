module Menus
module Graphic

  class Main < Menus::Main

    def initialize

      @menu = UI::Menu.new(:horizontal)
      @menu.push(UI::Buttons::Graphic::NewGame.new(), UI::Buttons::Graphic::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')

      super()
    end
  end

  class Pause < Menus::Pause

    def initialize

      @menu = UI::Menu.new(:vertical)
      @menu.push(UI::Buttons::Graphic::MainMenu.new(), UI::Buttons::Graphic::Quit.new())
      @hud = UI::Hud.new(@menu, :center)

      super()
    end
  end
end
end
