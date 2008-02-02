#!/usr/bin/env ruby
require 'rubygame'
require 'common/ui/display'
require 'common/inputs.handler'
require 'common/ui/arrow'

class GameSelector

  def self.run title = 'Choose your game'

    Rubygame.init()

    screen = Rubygame::Screen.new([800, 600])
    screen.title = title

    top = 30
    left = 350
    available_games = 0
    dirty_rects = []

    Dir['games/*'].each do |game|
      dirty_rects.push Display.new(:text => game,
                                   :position => [left, top]).draw(screen)
      top += 30
      available_games += 1
    end

    arrow = Arrow.new [280, 22], 30, available_games

    ih = InputsHandler.new do |ih|
      ih.ignore = [Rubygame::MouseMotionEvent]

      ih.key_down = {Rubygame::K_ESCAPE => lambda do throw :exit end,
                     Rubygame::K_DOWN => lambda do arrow.next end,
                     Rubygame::K_UP => lambda do arrow.previous end, }
    end

    begin
      catch :exit do
        bg = Rubygame::Surface.new(arrow.rect.size)
        loop do
          ih.handle

          arrow.undraw(screen, bg)

          dirty_rects.push arrow.draw(screen)

          screen.update_rects(dirty_rects)

          dirty_rects.clear
        end
      end
    ensure
      Rubygame::quit
    end

  end
end

GameSelector.run "The Game Saga"

