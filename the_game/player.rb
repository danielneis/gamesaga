class Player < Character

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
      end

      if (@state == :attacking)
        collide_sprite.take_damage(10, enemy_relative_position)
      else 
        take_damage(10, player_relative_position)
      end
    end
  end
end
