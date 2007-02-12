class Player < Character

  life 2000
  strength 100
  speed 3

  def take_damage(amount, to_side)
    super(amount, to_side)
    if @life < 0
      $player_death = true
      throw :run_game
    end
  end

  def update(collide_group)

    super()

    collide_group.collect do |collide_sprite|

      if collide_sprite.is_a? Enemy
        if @rect.centerx < collide_sprite.rect.centerx
          player_relative_position = :left
          enemy_relative_position = :right
        elsif @rect.centerx > collide_sprite.rect.centerx
          player_relative_position = :right
          enemy_relative_position = :left
        end
        if (@state == :attacking)
          collide_sprite.take_damage(@strength, enemy_relative_position)
        else 
          take_damage(collide_sprite.strength, player_relative_position)
        end

      elsif collide_sprite.is_a? Item
      end
    end
  end
end
