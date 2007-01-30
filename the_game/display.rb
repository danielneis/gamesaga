class Display < Rubygame::SFont

  def initialize(label, initial_text, position)

    @position = position
    @label = label
    @sfont = Rubygame::SFont.new(PIX_ROOT+'term16.png')
    @text = @sfont.render(@label + ': ' + initial_text)

  end

  def update(text, destination)
    @text = @sfont.render(@label + ': ' + text)
    @text.blit(destination, @position)
  end

end
