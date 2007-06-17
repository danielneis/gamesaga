module States

  class State

    def enter(performer)
    end

    def execute(performer)
    end

    def exit(performer)
    end
  end

  class Stop < State

    def enter(performer)
      performer.stop if performer.respond_to? 'stop'
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
      performer.update_ground
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
          if (performer.has_next_state?)
            performer.go_to_next_state
          else
            performer.back_to_last_state
          end
        end
      end
      
      # move the character
      performer.rect.bottom += vertical_speed if not vertical_speed.nil?
    end

    def exit(performer)
      if performer.has_next_state? and performer.next_state == States::State
        performer.stop_walk(performer.horizontal_direction)
      end
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

      config = YAML::load_file('config.yaml')

      @hit_stage = 0
      @hit_stages = 5

      @screen = Rubygame::Screen.get_surface

      @pow_image = Rubygame::Surface.load_image(config['pix_root']+'pow.png')
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
