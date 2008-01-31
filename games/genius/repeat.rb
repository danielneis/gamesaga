
require 'circle'

ih = InputsHandler.new do |ih|
  ih.ignore = [Rubygame::MouseMotionEvent]

  ih.mouse_down = {'left' => lambda do end}
end

red_green = Circle.new([255,0,0], [0,255,0])
red_green.draw(screen)

catch :exit do
  loop do
    ih.handle
    screen.update
  end
end


Rubygame.quit
