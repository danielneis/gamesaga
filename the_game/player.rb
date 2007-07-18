require 'character'

class Player < Character

  life 20
  strength 100
  speed 3
  jump_s 7

  def update(*collidables)

    super(*collidables)

    notify :player_death if @life <= 0
  end

  def act
    items_to_catch = @collisions.select { |c| c.is_a? Item }
    if items_to_catch.empty?
      attack
    else
      catch_items(items_to_catch) 
    end
  end
end
