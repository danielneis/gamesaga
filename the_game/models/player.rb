require File.dirname(__FILE__) + '/character'

module Models
class Player < Character

  life 20
  strength 100
  speed 3
  jump_s 2

  def initialize(pos, image)
    super(pos, image)

    height = @rect.h / 3
    width = @rect.w / 1.75
    x = @rect.x + width / 2
    y = @rect.b - height
  end

  def update(*collidables)

    super(*collidables)

    notify :player_death if @life <= 0
  end

  def act
    unless in_state? States::Jump
      items_to_catch = collisions.select { |c| c.is_a? Item }
      if items_to_catch.empty?
        attack
      else
        catch_items(items_to_catch) 
      end
    end
  end
end
end
