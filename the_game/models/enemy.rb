require File.dirname(__FILE__) + '/character'

module Models
class Enemy < Character

  life 10
  strength 1
  speed 3
  jump_s 6

  def initialize(pos, name)
    super(pos, 'enemies/' + name + '/')
  end

  def update(*collidables)

    super(*collidables)

    notify(:enemy_death, self) if @life <= 0
  end
end
end
