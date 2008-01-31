require 'rubygame/sfont'
class Display < Rubygame::SFont

  Rubygame::TTF.setup()

  attr_reader :rect

  def initialize options = {}
    defaults = {
      :position => [0,0],
      :text => 'Example Text',
      :size => 22,
      :font => 'default',
      :color => Rubygame::Color[:white]
    }

    @options = defaults.merge(options)

    @renderer = Rubygame::TTF.new('common/fonts/' + @options[:font] + '.ttf', @options[:size])
    @output = @renderer.render(@options[:text], true, @options[:color])

    @rect = @output.make_rect
    @rect.move!(*@options[:position])
  end

  def update(text)
    @output = @renderer.render(text, true, @options[:color])
  end

  def draw(destination)
    @output.blit(destination, @options[:position])
  end
end
