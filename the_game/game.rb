#!/usr/bin/env ruby
require 'rubygame'
require 'config'
require 'observable'
require 'ui/hud'
require 'ui/menu'
require 'ui/buttons'
require 'ui/mainmenu'
require 'automata'
require 'display'
require 'fsm'
require 'states'
require 'character'
require 'player'
require 'enemy'
require 'items'
require 'world'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)

MainMenu.new do |mm|

  mm.on :start_game do

    game = World.new do |world|
      
      # first, we need a player
      world.add_player('panda.png')

      #add some NPCs enemies
      world.add_enemy(Enemy.new(400, 350, 'panda.invert.png'),
                      Enemy.new(210, 350, 'panda.invert.png'))

      #create some Items
      world.add_items(Item.new(150, 350, 'chicken.png', {:life => 50}),
                Item.new(500, 350, 'meat.png', {:life => 137}))

      # Make the background
      world.background = (PIX_ROOT+'background.png')
    end

    catch(:end_game) do
      loop do
        game.update()
      end
    end
  end

  mm.on :end_game do
    exit
  end
end
