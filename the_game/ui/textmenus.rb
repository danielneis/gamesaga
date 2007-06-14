module Menus
module Text

  class Main < Menus::Main

    def initialize

      @menu = UI::Menu.new(:horizontal, 30)
      @menu.push(UI::Buttons::Text::NewGame.new(),
                 UI::Buttons::Text::Options.new(),
                 UI::Buttons::Text::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')

      super()
    end

    def update
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

  class Options < Menus::Options

    def initialize

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(UI::Buttons::Text::MainMenu.new(),
                 UI::Buttons::Text::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')

      @input_text = Components::InputText.new(10, [500, 10])
      super()
    end
  end
end
end
