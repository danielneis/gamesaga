class Game

  def initialize
    @@queue = Rubygame::Queue.instance
  end

  def self.main_menu(screen)

    catch(:game_start) do

      menu = UI::Menu.new(:horizontal)
      menu.push(UI::Buttons::NewGame.new(), UI::Buttons::Quit.new())
      hud = UI::Hud.new(menu, :bottom)

      background = Rubygame::Image.load(PIX_ROOT+'menu_background.jpg')
      background.blit(screen, [0,0])

      screen.show_cursor = true

      loop do
        @@queue.get().each do |event|
          case event
            when Rubygame::QuitEvent
              exit
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE then exit
                when Rubygame::K_RETURN then Game.start ; throw :game_start
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

  def self.start
    
    # create the player character
    @player = Player.new(300, 400, 'panda.png')

    #create some NPCs enemies
    @enemies = Rubygame::Sprites::Group.new()
    @enemies.push(#Enemy.new(400, 350, 'panda.invert.png'),
                  #Enemy.new(210, 350, 'panda.invert.png'),
                  Item.new(100, 350, 'chicken.png', {:life => 50}),
                  Item.new(500, 350, 'meat.png', {:life => 150}))

    # Make the background
    @background = Rubygame::Image.load(PIX_ROOT+'background.png')

    # Create the life bar, FPS display etc.
    @clock = Rubygame::Time::Clock.new(35)
    @fps_display = Display.new('FPS:', [0,0], @clock.fps.to_s)
    @life_display =  Display.new('Life:', [50,0], @player.life.to_s)
  end

  def self.run(screen)
    
    #Main Loop - repeat until player death
    catch(:run_game) do
      loop do
        Game.player_death(screen) if @player.life <= 0

        @clock.tick()
        @@queue.get.each do |event|
          case event
            when Rubygame::QuitEvent
              throw :end_game
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE, Rubygame::K_RETURN then Game.pause(screen, @clock)
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
              end
          end
        end

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

  def self.pause(screen, clock)

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

        @@queue.get.each do |event|
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

    screen.show_cursor = false
  end

  def self.player_death(screen)
    
    # after player death, print a message on the screen and wait for the player to exit
    title = Display.new('DIED! press [ESC] to to return to main menu', [50, 200], '', 25)
    title.update(screen)

    loop do
      screen.update()
      @@queue.get.each do |event|
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
