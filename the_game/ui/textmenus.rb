module Menus
module Text

  class Main < Menus::Main

    def initialize

      @menu = UI::Menu.new(:horizontal, 30)
      @menu.push(UI::Buttons::Text::NewGame.new(), UI::Buttons::Text::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')

      super()
    end
  end

  class Pause < Menus::Pause

    def initialize
      @menu = UI::Menu.new(:vertical, 20)
      @menu.push(UI::Buttons::Text::MainMenu.new(), UI::Buttons::Text::Quit.new())
      @hud = UI::Hud.new(@menu, :center)

      super()
    end
  end
end
end

