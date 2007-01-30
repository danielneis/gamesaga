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

  def handle_collisions

    if @player.rect.collide_rect? @enemy.rect

      if @player.rect.r <= @enemy.rect.l
        player_relative_position = :left
      elsif @player.rect.l <= @enemy.rect.r
        player_relative_position = :right
      end

      if (@player.state == :attacking)
        @enemy.take_damage(10, player_relative_position)
      else 
        @player.take_damage(10, player_relative_position)
      end
    end

  end

  def update
    handle_collisions
  end

end
