require File.dirname(__FILE__) + '/character'

module Models
class Player < Character

  life 5
  strength 1
  speed 3
  jump_s 2

  attr_reader :lives

  def initialize(pos, image)
    super(pos, 'player/' + image + '.png')

    @lives = 2
  end

  def revive
    @life = 5
  end

  def update(*collidables)

    super(*collidables)

    if @life <= 0
      @lives -= 1
      notify :player_death 
    end
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
