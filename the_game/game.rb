#!/usr/bin/env ruby
require 'rubygame'
require 'rubygame/sfont'

require 'config/config.rb'
require 'ui/contexts/mainmenu'
require 'ui/contexts/options'
require 'ui/contexts/pause'
require 'ui/contexts/controller.config'
require 'world'

Rubygame.init()
config = Configuration.instance

options = []
options.push(Rubygame::FULLSCREEN) if config.fullscreen

screen = Rubygame::Screen.new([config.screen_width, config.screen_height], config.color_depth, options)
screen.title = config.title

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
        g.add_player([500,500])

        #add some NPCs enemies
        g.add_enemies([400,500], [210, 410])

        #create some Items
        g.add_items({[150,700] => :chicken, [500, 550] => :meat})

        #add some objects to make things more fun
        g.add_object(Models::Tree.new([250,400], [170,300]))

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
