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

        if @player.rect.collide_rect? @enemy.rect then
            if @player.rect.r <= @enemy.rect.l then
                @player_relative_position = :left
            elsif @player.rect.l <= @enemy.rect.r then
                @player_relative_position = :right
            end

            if (@player.state == :attacking) then
                @enemy.take_damage(10, @player_relative_position)
            else 
                @player.take_damage(10, @player_relative_position)
            end
        end
    end
end
