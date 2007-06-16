require 'character'

class Player < Character

  life 20
  strength 100
  speed 3

  def update(*group)

    super()

    group.flatten!

    handle_collisions(collide_group(group))

    notify :player_death if @life <= 0
  end

  def handle_collisions(collide_group)

    collide_group.collect do |collide_sprite|
      if collide_sprite.is_a? Enemy

        if @rect.centerx < collide_sprite.rect.centerx
          player_relative_position = :left
          enemy_relative_position = :right
        elsif @rect.centerx > collide_sprite.rect.centerx
          player_relative_position = :right
          enemy_relative_position = :left
        end

        collide_sprite.take_damage(@strength, enemy_relative_position) if @state_machine.in_state? States::Attack

      elsif collide_sprite.is_a? Item

        collide_sprite.effect.collect do |method, new_value|
          old_value = self.send(method)
          self.send(method.to_s+'=', old_value + new_value)

          collide_sprite.catched = true
        end

      end
    end
  end
end
