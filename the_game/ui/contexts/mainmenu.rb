require File.dirname(__FILE__)+'/context'

module Contexts

  class Main < Context

    def initialize

      config = Configuration.instance

      @menu = UI::Menu.new(:horizontal, 30)
      @menu.push(Components::Buttons::NewGame.new(),
                 Components::Buttons::Options.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @background = Rubygame::Surface.load_image(config.pix_root + 'menu_background.jpg').zoom_to(config.screen_width, config.screen_height, true)

      @menu.each do |button|
        button.on :start_game do 
          notify :start_game
        end
        button.on :quit_game do
          throw :exit
        end
        button.on :options do
          notify :options
        end
      end

      super()

    end

    def update

      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          when Rubygame::K_RETURN then notify :start_game
          when Rubygame::K_O      then notify :options
          end
        when Rubygame::MouseDownEvent
          @hud.click(event.pos) if event.string == 'left'
        end
      end

      @background.blit(@screen, [0,0]) unless @background.nil?
      @hud.draw(@screen)

      @screen.update()
    end
  end
end
