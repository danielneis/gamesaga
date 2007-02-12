module UI
class Menu < Rubygame::Sprites::Group

  attr_reader :size
  def initialize(orientation)
    @orientation = orientation
    @margin = 10
    @button_height = 0
    @button_width  = 0
  end

  def push(*args)
    super(*args)
    self.each do |button|
      @button_height = button.rect.h if button.rect.h > @button_height
      @button_width = button.rect.w if button.rect.w > @button_width

      if @orientation == :vertical
        @height = (@button_height * self.length) + ((self.length + 1) * @margin)
        @width  = @button_width + @margin * 2
      elsif @orientation == :horizontal
        @width = (@button_width * self.length) + ((self.length + 1) * @margin)
        @height  = @button_height + @margin * 2
      end
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

    image_detour = 0
    self.collect do |button|
      if @orientation == :vertical
        button.rect.move!(@margin, @margin + image_detour)
      elsif @orientation == :horizontal
        button.rect.move!(@margin + image_detour, @margin)
      end
      button.draw( destination )
      button.rect.move!(position[0], position[1])
      if @orientation == :vertical
        image_detour += @button_height + @margin
      elsif @orientation == :horizontal
        image_detour += @button_width + @margin
      end
    end

  end

  def click(position)
    self.each do |button|
      button.click() if button.rect.collide_point?(position)
    end
  end

end
end
