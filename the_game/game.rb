#!/usr/bin/env ruby
require 'rubygame'
require 'config'
require 'lib/eventdispatcher'
require 'lib/automata'
require 'lib/fsm'
require 'lib/display'
require 'ui/hud'
require 'ui/menu'
require 'ui/buttons'
require 'ui/menus'
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

#pessima ideia deixar isso aqui, mas por enquanto ta valendo
def game_loop(game)
  screen = Rubygame::Screen.get_surface
  catch(:end_game) do
    screen.show_cursor = false
    loop do
      game.update()
    end
  end
end

Menus::Main.new do |mm|

  mm.on :start_game do

    game = World.new do |world|

      # first, we need a player
      world.add_player('panda.png')

      #add some NPCs enemies
      world.add_enemy(Enemy.new(400, 400, 'panda.invert.png'),
                      Enemy.new(210, 410, 'panda.invert.png'))

      #create some Items
      world.add_items(Item.new(150, 400, 'chicken.png', {:life => -50}),
                      Item.new(500, 350, 'meat.png', {:life => -137}))

      # Make the background
      world.background = (PIX_ROOT+'background.png')
    end

    game.on :pause do
      Menus::Pause.new do |pm|

        pm.on :continue do
          game_loop(game)
        end
      end
    end

    game_loop(game)
  end

  mm.on :end_game do
    exit
  end
end
