#!/usr/bin/env ruby
require 'rubygame'
require 'config'
require 'ui/hud'
require 'ui/menu'
require 'ui/buttons'
require 'display'
require 'character'
require 'player'
require 'enemy'
require 'items'
require 'main'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)
queue = Rubygame::Queue.instance
Game.new()

catch(:end_game) do

  loop do
    Game.main_menu(screen)

    Game.run(screen)
  end
end
