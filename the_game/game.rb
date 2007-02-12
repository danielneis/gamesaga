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
require 'contexts/main_menu'
require 'contexts/main'
require 'contexts/pause'
require 'contexts/player_death'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)
queue = Rubygame::Queue.instance

catch(:end_game) do
  loop do
    Game::MainMenu(screen, queue)

    Game::run(screen, queue)
  end
end
