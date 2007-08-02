require File.dirname(__FILE__)+'/context'

module Contexts

  class Pause < Context

    def enter(performer)

      top = 30
      left = @config.screen_width / 2

      @menu = UI::Menu.new(:vertical, 20)
      @menu.push(Components::Buttons::MainMenu.new(), Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :middle)

      @menu.each do |button|
        button.on :quit_game do
          throw :exit
        end
        button.on :main_menu do
          notify :main_menu
        end
      end

      @title = Display.new('[PAUSED]', [left, top], '', 25)
    end

    def update

      @title.update()

      @queue.each do |event|
        case event
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          when Rubygame::K_RETURN then throw :continue
          end
        when Rubygame::MouseDownEvent
          if event.string == 'left'
            if @hud.respond_to?('click')
              @hud.click(event.pos)
            end
          end
        end
      end

      @hud.draw(@screen)
      @screen.update()
    end
  end
end