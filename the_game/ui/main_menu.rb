module Game
def Game.MainMenu(screen, queue)

  catch(:game_start) do

    menu = UI::Menu.new(:horizontal)
    menu.push(UI::Buttons::NewGame.new(), UI::Buttons::Quit.new())
    hud = UI::Hud.new(menu, :bottom)

    background = Rubygame::Image.load(PIX_ROOT+'menu_background.jpg')
    background.blit(screen, [0,0])

    screen.show_cursor = true

    loop do
      queue.get().each do |event|
        case event
          when Rubygame::QuitEvent
            exit
          when Rubygame::KeyDownEvent
            case event.key
              when Rubygame::K_ESCAPE then exit
              when Rubygame::K_RETURN then Game::start() ; throw :game_start
            end
          when Rubygame::MouseDownEvent
            if event.string == 'left'
              if hud.respond_to?('click')
                hud.click(event.pos)
              end
            end
        end
      end

      hud.draw(screen)
      screen.update()
    end
  end
end
end
