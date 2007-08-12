require File.dirname(__FILE__)+'/context'

module Contexts

  class Pause < Context

    def enter

      @ih = InputsHandler.new do |ih|
        ih.ignore = [Rubygame::MouseMotionEvent]

        ih.key_down = {Rubygame::K_ESCAPE => lambda do throw :exit end,
                       Rubygame::K_RETURN => lambda do @performer.resume_game end}

        ih.mouse_down = {'left' => lambda do |event| @hud.click(event.pos) end}
      end

      top = 30
      left = @config.screen_width / 2

      @menu = UI::Menu.new(:vertical, 20)
      @menu.push(Components::Buttons::MainMenu.new(), Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :middle)

      @menu.each do |button|
        button.on :quit_game do throw :exit end
        button.on :main_menu do @performer.back_to_start end
      end

      @screen.show_cursor = true

      @title = Display.new('[PAUSED]', [left, top], '', 25)

      @title.update()
      @hud.draw(@screen)
      @screen.update()
    end

    def execute
      @ih.handle
    end
  end
end
