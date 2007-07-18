require 'character'

class Player < Character

  life 20
  strength 100
  speed 3
  jump_s 7

  def update(*collidables)

    super(*collidables)

    notify :player_death if @life <= 0

    handle_collisions
  end

  private
  def handle_collisions

    @collisions.collect do |collide_sprite|
      if collide_sprite.is_a? Item

        collide_sprite.effect.collect do |method, new_value|
          old_value = self.send(method)
          self.send(method.to_s+'=', old_value + new_value)

          collide_sprite.catched = true
        end

      end
    end
  end
end
