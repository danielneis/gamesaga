class Enemy < Character

  life 10
  strength 400
  speed 3

  def update

    super()

    notify_listeners('enemy_death') if @life <= 0
  end

end
