module Game
  def Game.pause(screen, queue , clock)
    screen.show_cursor = true
  # Make the pause menu
    @pause_menu = UI::Menu.new(:vertical)
    @pause_menu.push( UI::Buttons::MainMenu.new(),
                     UI::Buttons::Quit.new())
    @pause_hud = UI::Hud.new(@pause_menu, :center)

    Rubygame::TTF.setup()
    font = Rubygame::TTF.new('font.ttf', 25)
    pause_text = '[PAUSED]'
    prender = font.render(pause_text, true, [0,0,0])
    prender.blit(screen, [240,10])

    @pause_hud.draw(screen)
    catch(:pause_game) do
      loop do
        @fps_display.update(clock.fps.to_s, screen)
        screen.update()
        queue.get().each do |event|
          case event
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE then throw :end_game
                when Rubygame::K_RETURN then @pause_menu = nil ; @pause_hud = nil ; @pause_tick = nil; @pause_loop = 0; throw :pause_game
              end
            when Rubygame::MouseDownEvent
              if event.string == 'left'
                if @pause_hud.respond_to?('click')
                  @pause_hud.click(event.pos)
                end
              end
          end
        end
      end
    end
  end
end
