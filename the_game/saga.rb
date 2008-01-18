#!/usr/bin/env ruby
require 'game'

Game.new "Saga" do

  start_at Contexts::Main

  pause_is Contexts::Pause

  options_is Contexts::Options

  world do World.new do

    add_player([650,300], :player1)

    add_enemies([400,440] => :enemy1, [110, 440] => :enemy2)

    add_items({[150,700] => :chicken, [500, 550] => :meat, [350,700] => :chicken, [600, 550] => :meat})

    add_object(Models::Tree.new([250,370], [170,300]))

    use_background (Configuration.instance.pix_root + 'background.png')
  end
  end
end.start
