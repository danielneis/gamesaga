#!/usr/bin/env ruby
require 'rubygems'
require_gem 'rubygame', '2.0.1'
require 'rubygame/sfont'

require 'config/config.rb'
require 'lib/eventdispatcher'
require 'lib/automata'
require 'lib/fsm'
require 'ui/contexts/mainmenu'
require 'ui/contexts/options'
require 'ui/contexts/pause'
require 'world'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
config = Configuration.instance
screen = Rubygame::Screen.new([config.screen_width, config.screen_height])
screen.title = config.title

Rubygame::Clock.new do |clock|
  clock.target_framerate = 35
end

catch(:exit) do 
  Contexts::Main.new do |mm|

    mm.on :options do
      catch :main_menu do
        Contexts::Options.new.run
      end
    end

    mm.on :start_game do

      World.new do |g|

        # first, we need a player
        g.add_player(Player.new(300, 400, 'panda.png'))

        #add some NPCs enemies
        g.add_enemy(Enemy.new(400, 400, 'panda.invert.png'),
                    Enemy.new(210, 410, 'panda.invert.png'))

        #create some Items
        g.add_items(Item.new(150, 400, 'chicken.png', {:life => 50}),
                    Item.new(500, 350, 'meat.png', {:life => 137}))

        # Make the background
        g.background = (config.pix_root + 'background.png')

        # Listen for to create the pause menu
        g.on :pause do
          catch :continue do
            Contexts::Pause.new.run
          end
        end

      end.run # game
    end # start game
  end.run # main menu
end

Rubygame::quit
