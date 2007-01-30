class Menu < Rubygame::Sprites::Group

  def initialize( position )
    @position = position
    @button_width = 30
    @button_height = 30
  end

  #draw in a layout form
  #buttons will be sprites from the buttonloader...
  #destination is the location on the HUD to draw to... I think there is a redundancy
  #here, good thing I am doing documentation.
  def draw( destination )
    loc = @position.clone
    c = 1
    self.each do |sprite|
      puts sprite
      sprite.rect.x = loc[0]
      sprite.rect.y = loc[1]
      sprite.draw( destination )
      loc[0] += (@button_width + 10)
      if ( c % 5 == 0 )
        loc[0] = @pos[0]
        loc[1] += (@button_height + 10)
      end
      ++c
    end
  end

  def click ( selection, pointer, position)
    self.each_value do |button|
      return button.click(selection, pointer) if button.rect.collide_point? position
    end
  end

end
