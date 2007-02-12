module Game
  def Game.start
    # create the player character
    @player = Player.new(300, 350, 'panda.png')

    #create some NPCs enemies
    @enemies = Rubygame::Sprites::Group.new()
    @enemies.push(Enemy.new(500, 350, 'panda.invert.png'),
                 Enemy.new(210, 350, 'panda.invert.png') )

    # create a chicken, to recover live
    #@chicken = Item.new(100, 350, 'chicken.png', {:health => 50} )

    # Make the background
    @background = Rubygame::Image.load(PIX_ROOT+'background.png')

    # Create the life bar, FPS display etc.
    @life_display =  Display.new('Life',@player.life.to_s, [50,0])
    @clock = Rubygame::Time::Clock.new(35)
    @fps_display = Display.new('FPS', @clock.fps.to_s, [0,0])

    # To manipulate the pause menu/hud
    @pause = false
    @pause_hud = nil
    @pause_menu = nil

    # to create just one time de pause menu, title etc.
    @pause_loop = 0
  end

  def Game.run(screen, queue)
    #Main Loop - repeat until player death
    catch(:run_game) do
      loop do
        Game.player_death(screen, queue) if @player.life < 0

        @clock.tick()
        queue.get().each do |event|
          case event
            when Rubygame::QuitEvent
              throw :end_game
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE, Rubygame::K_RETURN then Game::pause(screen, queue, @clock)
                when Rubygame::K_LEFT   then @player.walk :left
                when Rubygame::K_RIGHT  then @player.walk :right
                when Rubygame::K_X      then @player.attack()
                when Rubygame::K_UP     then @player.jump()
              end
            when Rubygame::KeyUpEvent
              case event.key
                when Rubygame::K_LEFT  then @player.stop_walk :left
                when Rubygame::K_RIGHT then @player.stop_walk :right
                when Rubygame::K_X     then @player.stop_attack()
              end
          end
        end

        screen.show_cursor = false
        @background.blit(screen, [0, 0])

        @life_display.update(@player.life.to_s, screen)
        @fps_display.update(@clock.fps.to_s, screen)

        @player.update(@player.collide_group(@enemies))
        @enemies.update()

        @player.draw(screen)
        @enemies.draw(screen)

        screen.update()

      end
      #enemies.push(chicken) if Rubygame::Time.get_ticks > 500 and Rubygame::Time.get_ticks < 510
    end
  end
end
