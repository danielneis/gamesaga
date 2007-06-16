require 'rubygame/sfont'
class Display < Rubygame::SFont

  Rubygame::TTF.setup()

  def initialize(label, position, text = '', size = 12, font = 'default')

    $:.unshift File.join(File.dirname(__FILE__), "..")
    config = YAML::load_file('config.yaml')

    @font = font
    @position = position
    @label = label
    @size = size
    @destination = Rubygame::Screen.get_surface()

    @renderer = Rubygame::TTF.new(config['font_root']+@font+'.ttf', @size)
    @output = @renderer.render(@label + text, true, [0,0,0])
  end

  def update(text = '')
    @output = @renderer.render(@label + text, true, [0,0,0])
    @output.blit(@destination, @position)
  end

end
