module States

  class State

    def initialize(state_machine)
      @@state_machine = state_machine
    end

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

      HorizontalMove.execute(performer)

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

    def self.execute(performer)

      speed = performer.speed

      if performer.horizontal_direction == :left and performer.rect.left > performer.area.left
        horizontal_speed = -speed
      elsif performer.horizontal_direction == :right and performer.rect.right < performer.area.right
        horizontal_speed = speed
      else
        horizontal_speed = nil
      end

      horizontal_speed = horizontal_speed * 5 if ( not horizontal_speed.nil?) and @@state_machine.in_state? Jump

      performer.rect.x += horizontal_speed if not horizontal_speed.nil?
    end
  end

  class Jump < State

    def enter(performer)
      @state_before_jump = @@state_machine.last_state
      @jump_stage = 0
      @jump_stages = 5
      @jump_speed = -(performer.speed * 3)
    end

    def execute(performer)

      HorizontalMove.execute(performer)

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
          @@state_machine.change_state(@state_before_jump.class)
          vertical_speed = 0 
        end
      end
      
      # move the character
      performer.rect.bottom += vertical_speed if not vertical_speed.nil?
    end
  end

  class Attack < State

    def enter(performer)
      @state_before_attack = @@state_machine.last_state
      @attack_stage = 0
      @attack_stages = 3

      performer.swap_image :attack
    end

    def execute(performer)

      if @attack_stage < @attack_stages
        @attack_stage += 1
      else
        @@state_machine.change_state(@state_before_attack.class)
      end

      #@state_before_attack.execute(performer)
    end

    def exit(performer)
      performer.swap_image :still
    end
  end
  
  class Hitted < State

    def enter(performer)
      @pow_image = Rubygame::Image.load(PIX_ROOT+'pow.png')
      @screen = Rubygame::Screen.get_surface()

      @state_before_hitted = @@state_machine.last_state

      @hit_stage = 0
      @hit_stages = 5

      @pow_image.blit(@screen, [performer.rect.x, performer.rect.y] )
    end

    def execute(performer)
      if @hit_stage < @hit_stages
        @hit_stage += 1
      else 
        @@state_machine.change_state(@state_before_hitted.class)
      end
    end
  end
end
