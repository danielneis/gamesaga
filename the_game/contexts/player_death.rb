module Game
  def Game.player_death(screen, queue)
    
    # after player death, print a message on the screen and wait for the player to exit
    Rubygame::TTF.setup()
    font = Rubygame::TTF.new('font.ttf', 25)
    text = "DIED! press [ESC] to to return to main menu"
    prender = font.render(text, true, [0,0,0])

    loop do
      prender.blit(screen, [50, 200])
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
