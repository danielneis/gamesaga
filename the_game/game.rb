#!/usr/bin/env ruby
require 'rubygems'
require_gem 'rubygame', '2.0.0'
require 'config'
require 'rubygame/sfont'
require 'lib/eventdispatcher'
require 'lib/automata'
require 'lib/fsm'
require 'lib/display'
require 'ui/components/inputtext'
require 'ui/components/buttons'
require 'ui/hud'
require 'ui/menu'
require 'ui/menus'
require 'states'
require 'character'
require 'player'
require 'enemy'
require 'items'
require 'world'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
screen = Rubygame::Screen.new(SCREEN_SIZE)
screen.title = TITLE

Rubygame::Clock.new do |clock|
  clock.target_framerate = 35
end

catch(:exit) do 
  Menus::Main.new do |mm|

    mm.on :options do
      catch :main_menu do
        Menus::Options.new.run
      end
    end

    mm.on :start_game do

      game = World.new do |g|

        # first, we need a player
        g.add_player('panda.png')

        #add some NPCs enemies
        g.add_enemy(Enemy.new(400, 400, 'panda.invert.png'),
                        Enemy.new(210, 410, 'panda.invert.png'))

        #create some Items
        g.add_items(Item.new(150, 400, 'chicken.png', {:life => -50}),
                        Item.new(500, 350, 'meat.png', {:life => -137}))

        # Make the background
        g.background = (PIX_ROOT+'background.png')
        
        # Listen for to create the pause menu
        g.on :pause do
          catch :continue do
            Menus::Pause.new.run
          end
        end

      end.run # game
    end # start game
  end.run # main menu
end

Rubygame::quit
