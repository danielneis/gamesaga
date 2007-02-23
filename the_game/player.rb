class Player < Character

  life 2000
  strength 100
  speed 3

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
        if (@state == :attack)
          collide_sprite.take_damage(@strength, enemy_relative_position)
        else 
          take_damage(collide_sprite.strength, player_relative_position)
        end

      elsif collide_sprite.is_a? Item
        method = collide_sprite.effect.keys.first
        new_value = collide_sprite.effect.values.first
        old_value = self.send(method)
        self.send(method.to_s+'=', old_value + new_value)
      end
    end

  end

end
