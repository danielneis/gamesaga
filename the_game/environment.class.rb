class Environment

    attr_reader :screen, :state, :kills

    def initialize(player, enemy, rect, screen)
	@player = player
        @enemy = enemy
	@kills = 0
	@state = :started
	@rect = rect
	@main_screen = screen
        
    end

    def start
	@state = :started
    end

    def stop
	@state = :stopped
    end

    def handle_collisions

        if @player.rect.collide_rect? @enemy.rect
            if (@player.direction == :left)
                3.times {@player.move_right}
                @player.state = :still
            elsif (@player.direction == :right)
                3.times { @player.move_left }
                @player.state = :still
            end

            if (@player.state == :attacking) then
                @enemy.take_damage(10)
            else 
                @player.take_damage(10)
            end

        end
    end
end
