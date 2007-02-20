module Game
  def Game.pause(screen, queue , clock)

    screen.show_cursor = true

    pause_menu = UI::Menu.new(:vertical)
    pause_menu.push( UI::Buttons::MainMenu.new, UI::Buttons::Quit.new )
    pause_hud = UI::Hud.new(pause_menu, :center)

    title = Display.new('[PAUSED]', [240,10], '', 25)
    title.update(screen)

    pause_hud.draw(screen)
    catch(:pause_game) do
      loop do
        @clock.tick()
        @fps_display.update(screen, @clock.fps.to_s)
        screen.update()
        queue.get().each do |event|
          case event
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE then throw :end_game
                when Rubygame::K_RETURN then
                  pause_menu, pause_menu, pause_tick = nil
                  throw :pause_game
              end
            when Rubygame::MouseDownEvent
              if event.string == 'left'
                if pause_hud.respond_to?('click')
                  pause_hud.click(event.pos)
                end
              end
          end
        end
      end
    end
  end
end
