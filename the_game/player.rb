class Player < Character

  def update(collide_group)

    collide_group.collect do |collide_sprite|
      if collide_sprite.is_a? Enemy
        if @rect.r <= collide_sprite.rect.l
          player_relative_position = :left
        elsif @rect.l <= collide_sprite.rect.r
          player_relative_position = :right
        end
      end

      if (@state == :attacking)
        collide_sprite.take_damage(10, player_relative_position)
      else 
        take_damage(10, player_relative_position)
      end
    end

    super()

  end
end
