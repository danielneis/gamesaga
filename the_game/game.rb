#!/usr/bin/env ruby
require 'rubygame'
require 'config'
require 'ui/hud'
require 'ui/menu'
require 'ui/buttons'
require 'ui/main_menu'
require 'display'
require 'character'
require 'player'
require 'enemy'
require 'items'
require 'main'
require 'pause'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)
queue = Rubygame::Queue.instance

catch(:end_game) do
  death_loop = 0
  loop do
    Game::MainMenu(screen, queue)

    Game::run(screen, queue)

    # after player death, print a message on the screen and wait for the player to exit
    if $player_death
      if death_loop < 1
        Rubygame::TTF.setup()
        font = Rubygame::TTF.new('font.ttf', 25)
        text = "DIED! press [ESC] to to return to main menu"
        prender = font.render(text, true, [0,0,0])
        death_loop += 1
      end
      loop do
        prender.blit(screen, [50, 200])
        screen.update()
        queue.get().each do |event|
          case event
            when Rubygame::QuitEvent
              throw :end_game
            when Rubygame::KeyDownEvent
              case event.key
                when Rubygame::K_ESCAPE then $player_death = false; break
              end
            break if !$player_death
          end
          break if !$player_death
        end
        break if !$player_death
      end
    end
  end
end
