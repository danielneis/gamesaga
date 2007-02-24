module AI
  module States

    class State

      def initialize
      end

      def enter(performer)
      end

      def execute(performer)
      end

      def exit(performer)
        if performer.image == performer.attack_image
          performer.image = performer.still_image
          performer.image.set_colorkey(performer.image.get_at([0, 0]))
          performer.rect = Rubygame::Rect.new(performer.rect.x, performer.rect.y, *performer.image.size)
        end
      end
    end

    class Walk < State

      def initialize(speed)
        @speed = speed
      end

      def execute(performer)

        HorizontalMove.execute(performer)

        if performer.vertical_direction == :up and performer.rect.bottom > performer.area.top
          vertical_speed = -@speed
        elsif performer.vertical_direction == :down and performer.rect.bottom < performer.area.bottom
          vertical_speed = @speed
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

        horizontal_speed = horizontal_speed * 5 if ( not horizontal_speed.nil?) and performer.current_state.is_a? Jump

        performer.rect.x += horizontal_speed if not horizontal_speed.nil?
      end
    end

    class Jump < State

      def initialize(speed, state_before_jump)
        @state_before_jump = state_before_jump
        @jump_stage = 0
        @jump_stages = 5
        @speed = speed
        @jump_speed = -(speed * 3)
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
            performer.vertical_direction = nil
            performer.change_state(@state_before_jump)
            vertical_speed = 0 
          end
        end
        
        # move the character
        performer.rect.bottom += vertical_speed if not vertical_speed.nil?
      end
    end

    class Attack < State

      def initialize(performer)
        @state_before_attack = performer.current_state
        @attack_stage = 0
        @attack_stages = 3
      end

      def execute(performer)

        @state_before_attack.execute(performer)

        if @attack_stage < @attack_stages
          if performer.image != performer.attack_image
            performer.image = performer.attack_image
            performer.image.set_colorkey(performer.image.get_at([0, 0]))
            performer.rect = Rubygame::Rect.new(performer.rect.x, performer.rect.y, *performer.image.size)
          end
          @attack_stage += 1
        else
          performer.change_state(@state_before_attack)
        end
      end
    end
  end
end
