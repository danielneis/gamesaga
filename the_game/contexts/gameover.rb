require File.dirname(__FILE__)+'/context'

module Contexts

  class GameOver < Context

    def enter

      title = Display.new('Game Over!! ESC to exit, M to main menu, <Enter> to restart', [50, 200], '', 25)
      title.update()

      @ih = InputsHandler.new do |ih|
        ih.ignore = [Rubygame::MouseMotionEvent, Rubygame::MouseDownEvent, Rubygame::MouseUpEvent]

        ih.key_down = {Rubygame::K_ESCAPE  => lambda do throw :exit end,
          Rubygame::K_RETURN  => lambda do @performer.start_game end,
          Rubygame::K_M       => lambda do @performer.back_to_start end}
      end

      @screen.update()
    end

    def execute
      @ih.handle
    end
  end
end
