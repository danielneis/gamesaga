require 'character'

class Enemy < Character

  life 20
  strength 400
  speed 3
  jump_s 15

  def update

    super()

    notify(:enemy_death, self) if @life <= 0
  end

end
