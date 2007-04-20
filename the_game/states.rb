module States

  class State

    def enter(performer)
    end

    def execute(performer)
    end

    def exit(performer)
    end
  end

  class Walk < State

    def execute(performer)

      speed = performer.speed

      help_state = HorizontalMove.new
      help_state.execute(performer)

      if performer.vertical_direction == :up and performer.rect.bottom > performer.area.top
        vertical_speed = -speed
      elsif performer.vertical_direction == :down and performer.rect.bottom < performer.area.bottom
        vertical_speed = speed
      else
        vertical_speed = nil
      end
      
      performer.rect.bottom += vertical_speed if not vertical_speed.nil?
    end
  end

  class HorizontalMove < State

    def execute(performer)

      speed = performer.speed

      if performer.horizontal_direction == :left and performer.rect.left > performer.area.left
        horizontal_speed = -speed
      elsif performer.horizontal_direction == :right and performer.rect.right < performer.area.right
        horizontal_speed = speed
      else
        horizontal_speed = nil
      end

      horizontal_speed = horizontal_speed * 5 if ( not horizontal_speed.nil?) and performer.in_state? Jump

      performer.rect.x += horizontal_speed if not horizontal_speed.nil?
    end
  end

  class Jump < State

    def enter(performer)
      @jump_stage = 0
      @jump_stages = 5
      @jump_speed = -(performer.speed * 3)
    end

    def execute(performer)

      help_state = HorizontalMove.new
      help_state.execute(performer)

      if performer.vertical_direction == :up

        if @jump_stage < @jump_stages
          vertical_speed = @jump_speed
          @jump_stage += 1
        else
          performer.vertical_direction = :down
          @jump_stage = 0
        end

      elsif  performer.vertical_direction == :down

        if performer.rect.bottom < performer.ground
          vertical_speed = -@jump_speed
        else
          performer.stop_walk :down
          vertical_speed = nil
          performer.back_to_last_state
        end
      end
      
      # move the character
      performer.rect.bottom += vertical_speed if not vertical_speed.nil?
    end
  end

  class Attack < State

    def enter(performer)

      @attack_stage = 0
      @attack_stages = 3

      performer.swap_image :attack
    end

    def execute(performer)

      if @attack_stage < @attack_stages
        @attack_stage += 1
      else
        @attack_stage = 0
        performer.back_to_last_state
      end
    end

    def exit(performer)
      performer.swap_image :still
    end
  end
  
  class Hitted < State

    def enter(performer)

      @hit_stage = 0
      @hit_stages = 5

      @screen = Rubygame::Screen.get_surface

      @pow_image = Rubygame::Image.load(PIX_ROOT+'pow.png')
      @pow_image.blit(@screen, [performer.rect.x, performer.rect.y] )
    end

    def execute(performer)

      if @hit_stage < @hit_stages
        @hit_stage += 1
      else 
        performer.life = performer.life - performer.damage
        performer.back_to_last_state
      end
    end

    def exit(performer)
      @pow_image = nil
    end
  end

end

module States
  module Game

    class GameState < State

      def initialize()
        @screen = Rubygame::Screen.get_surface
        @clock = Rubygame::Time::Clock.new(35)
        @queue = Rubygame::Queue.instance
      end
    end

    class Run < GameState

      def enter(performer)
      end

      def execute(performer)
        @clock.tick()
        @queue.get.each do |event|
          case event
            when Rubygame::QuitEvent
              throw :end_game
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE, Rubygame::K_RETURN then performer.change_state(Pause)
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
      end

    end

    class Pause < GameState

      def enter(performer)
        @screen.show_cursor = true

        menu = UI::Menu.new(:vertical)
        menu.push(UI::Buttons::MainMenu.new(@state_machine), UI::Buttons::Quit.new(@state_machine))
        @hud = UI::Hud.new(menu, :center)

        @title = Display.new('[PAUSED]', [240,10], '', 25)
        @title.update()

        @hud.draw(@screen)

        @screen.update()
      end

      def execute(performer)

        @clock.tick()
        #@fps_display.update(@clock.fps.to_s)

        @title.update()
        @hud.draw(@screen)
        @screen.update()

        @queue.get.each do |event|
          case event
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE then throw :end_game
                when Rubygame::K_RETURN then performer.back_to_last_state()
              end
            when Rubygame::MouseDownEvent
              if event.string == 'left'
                if @hud.respond_to?('click')
                  @hud.click(event.pos)
                end
              end
          end
        end
      end

      def exit(performer)
        @screen.show_cursor = false
      end
    end

    class PlayerDeath < GameState

      def enter(performer)
        # after player death, print a message on the screen and wait for the player to exit
        title = Display.new('DIED! press [ESC] to to return to main menu', [50, 200], '', 25)
        title.update()
      end

      def execute(performer)

        @screen.update()

        @queue.get.each do |event|
          case event
            when Rubygame::QuitEvent
              throw :end_game
            when Rubygame::KeyDownEvent
              case event.key
              when Rubygame::K_ESCAPE then performer.change_state(MainMenu)
              end
          end
        end
      end
    end
  end
end
