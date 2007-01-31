module UI
class Menu < Rubygame::Sprites::Group

  attr_reader :size
  def initialize
    @margin = 10
    @button_height = 0
    @button_width  = 0
  end

  def push(*args)
    super(*args)
    self.each do |button|
      @button_height = button.rect.h if button.rect.h > @button_height
      @button_width = button.rect.w if button.rect.w > @button_width

      @height = (@button_height * self.length) + (self.length +  @margin * 2)
      @width  = (@button_width + @margin * 2)
    end
  end

  def size
    return [@width, @height]
  end

  # vamos documentar algo estranho aqui...
  # primeiro eu preciso mover o retângulo da imagem e sua posição está relacionada com a 'surface'  na qual vai ser desenhada
  # depois disso eu a desenho e parece que seu retângulo volta para a posição [0,0]
  # por ultimo eu preciso mover o retângulo novamente para cima da imagem, mas agora a sua posição está relacionada a tela
  # muito bizarro. ainda não sei por que isso acontece...
  def draw(destination, position)

    pos = position.clone
    image_detour = 0
    self.collect do |button|
      button.rect.move!(@margin, @margin + image_detour)
      button.draw( destination )
      button.rect.move!(pos[0], pos[1])
      image_detour += @button_height + @margin
    end

  end

  #def click ( selection, pointer, position)
  def click(position)
    self.each do |button|
      #button.click(selection, pointer) if button.rect.collide_point? position
      button.click() if button.rect.collide_point?(position[0], position[1])
    end
  end

end
end
