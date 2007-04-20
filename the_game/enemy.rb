class Enemy < Character

  life 20
  strength 400
  speed 3

  def update

    super()

    notify(:enemy_death, self) if @life <= 0
  end

end
