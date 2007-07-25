require File.dirname(__FILE__) + '/character'

module Models
class Enemy < Character

  life 500
  strength 400
  speed 3
  jump_s 15

  def update(*collidables)

    super(*collidables)

    notify(:enemy_death, self) if @life <= 0
  end
end
end
