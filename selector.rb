#!/usr/bin/env ruby
require 'rubygame'
require 'rubygame/sfont'
require 'common/ui/display'
require 'common/inputs.handler'

class GameSelector

  def self.run title = 'Choose your game'

    Rubygame.init()

    screen = Rubygame::Screen.new([800, 600])
    screen.title = title

    top = 30
    left = 350

    Dir['games/*'].each do |game|
      Display.new(:text => game,
                  :position => [left, top]).draw(screen)
      top += 30
    end

    ih = InputsHandler.new do |ih|
      ih.ignore = [Rubygame::MouseMotionEvent]

      ih.key_down = {Rubygame::K_ESCAPE => lambda do throw :exit end}
    end

    begin
      catch :exit do
        loop do
          screen.update
          ih.handle
        end
      end
    ensure
      Rubygame::quit
    end

  end
end

GameSelector.run "The Game Saga"
