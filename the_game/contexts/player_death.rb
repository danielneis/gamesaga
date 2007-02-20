module Game
  def Game.player_death(screen, queue)
    
    # after player death, print a message on the screen and wait for the player to exit
    title = Display.new('DIED! press [ESC] to to return to main menu', [50, 200], '', 25)
    title.update(screen)

    loop do
      screen.update()
      queue.get().each do |event|
        case event
          when Rubygame::QuitEvent
            throw :end_game
          when Rubygame::KeyDownEvent
            case event.key
            when Rubygame::K_ESCAPE then throw :run_game
            end
        end
      end
    end
  end
end
