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
      performer.x_speed = 0
      performer.y_speed = 0
    end
  end

  class Walk < State

    def execute(performer)
      performer.move if performer.should_walk
    end
  end

  class Jump < State

    def enter(performer)
      performer.y_speed = -performer.jump_s
      performer.move
      @time_span = 1
      @initial_ground = performer.ground
    end

    def execute(performer)

      if performer.rect.bottom <= @initial_ground
        performer.y_speed += 0.01 * @time_span
        performer.move
        @time_span += 1
      else
        performer.rect.bottom = @initial_ground
        performer.y_speed = 0
        if (performer.has_next_state?)
          performer.go_to_next_state
        else
          performer.back_to_last_state
        end
      end
    end
  end

  class Attack < State

    def enter(performer)

      @attack_stage = 0
      @attack_stages = 3

      performer.swap_image :attack

      performer.collisions.each do |colision|

        if colision.respond_to? :take_damage
          if performer.rect.centerx < colision.rect.centerx
            attacker_relative_position = :left
            hitted_relative_position = :right
          elsif performer.rect.centerx > colision.rect.centerx
            attacker_relative_position = :right
            enemy_relative_position = :left
          end

          colision.take_damage(performer.strength, enemy_relative_position)
        end
      end
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

      config = Configuration.instance

      @hit_stage = 0
      @hit_stages = 5

      @screen = Rubygame::Screen.get_surface

      @pow_image = Rubygame::Surface.load_image(config.pix_root + 'pow.png')
      @pow_image.blit(@screen, [performer.rect.x, performer.rect.y] )

      performer.life -= performer.damage
    end

    def execute(performer)

      if @hit_stage < @hit_stages
        @hit_stage += 1
      else 
        performer.back_to_last_state
      end
    end

    def exit(performer)
      @pow_image = nil
    end
  end

  class Catch < State

    def enter(performer)

      performer.items_to_catch.each do |item|
        item.each_effect do |method, new_value|

          old_value = performer.send(method)
          performer.send(method.to_s+'=', old_value + new_value)

          item.catched
        end
      end
    end
  end
end
