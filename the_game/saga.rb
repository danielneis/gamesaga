#!/usr/bin/env ruby
require 'game'

Game.new do |game|

  game.start_context = Contexts::Main

  game.pause = Contexts::Pause

  game.options = Contexts::Options

  game.set_world do
    
    World.new do |g|

      g.add_player([500,500])

      g.add_enemies([400,500], [210, 410])

      g.add_items({[150,700] => :chicken, [500, 550] => :meat, [350,700] => :chicken, [600, 550] => :meat})

      g.add_object(Models::Tree.new([250,400], [170,300]))

      g.background = (Configuration.instance.pix_root + 'background.png')
    end
  end
end.start
