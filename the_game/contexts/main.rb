module Game
  def Game.start
    
    # create the player character
    @player = Player.new(300, 400, 'panda.png')

    #create some NPCs enemies
    @enemies = Rubygame::Sprites::Group.new()
    @enemies.push(Enemy.new(400, 350, 'panda.invert.png'),
                  Enemy.new(210, 350, 'panda.invert.png'),
                  Item.new(100, 350, 'chicken.png', {:health => 50}),
                  Item.new(500, 350, 'meat.png', {:health => 150}))

    # Make the background
    @background = Rubygame::Image.load(PIX_ROOT+'background.png')

    # Create the life bar, FPS display etc.
    @clock = Rubygame::Time::Clock.new(35)
    @fps_display = Display.new('FPS:', [0,0], @clock.fps.to_s)
    @life_display =  Display.new('Life:', [50,0], @player.life.to_s)
  end

  def Game.run(screen, queue)
    #Main Loop - repeat until player death
    catch(:run_game) do
      loop do
        Game.player_death(screen, queue) if @player.life <= 0

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
                when Rubygame::K_UP     then @player.walk :up
                when Rubygame::K_DOWN   then @player.walk :down
                when Rubygame::K_S      then @player.attack
                when Rubygame::K_D      then @player.jump
              end
            when Rubygame::KeyUpEvent
              case event.key
                when Rubygame::K_LEFT  then @player.stop_walk :left
                when Rubygame::K_RIGHT then @player.stop_walk :right
                when Rubygame::K_UP    then @player.stop_walk :up
                when Rubygame::K_DOWN  then @player.stop_walk :down
                when Rubygame::K_S     then @player.stop_attack
              end
          end
        end

        screen.show_cursor = false
        @background.blit(screen, [0, 0])

        @life_display.update(screen, @player.life.to_s)
        @fps_display.update(screen, @clock.fps.to_s)

        @player.update(@player.collide_group(@enemies))
        @enemies.update()

        @player.draw(screen)
        @enemies.draw(screen)

        screen.update()
      end
    end
  end
end
