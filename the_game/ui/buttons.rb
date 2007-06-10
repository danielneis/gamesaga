module UI
module Buttons

  class Button

    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize
      super()
      setup_listeners()
    end
  end

  module Quit

    def click
      notify :quit_game
    end
  end

  module NewGame
    def click
      notify :start_game
    end
  end

  module MainMenu
    def click
      notify :main_menu
    end
  end
end
end
