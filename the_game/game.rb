#!/usr/bin/env ruby
require 'rubygame'
require 'config.rb'
require 'ui/hud.rb'
require 'ui/menu.rb'
require 'ui/buttons.rb'
require 'display.rb'
require 'character.rb'
require 'player.rb'
require 'enemy.rb'

# Initialize rubygame and set up screen
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)

# create the player character
player = Player.new(300, 350, 'panda.png')

#create some NPCs enemies
enemies = Rubygame::Sprites::Group.new()
enemies.push(Enemy.new(500, 350, 'panda.invert.png'),
             Enemy.new(210, 350, 'panda.invert.png') )

# Make the background
background = Rubygame::Image.load(PIX_ROOT+'background.png')
background.blit(screen,[0,0])

# Create the life bar, FPS display etc.
life_display =  Display.new('Life',player.life.to_s, [50,0])
clock = Rubygame::Time::Clock.new()
fps_display = Display.new('FPS', clock.fps.to_s, [0,0])

# To manipulate the pause menu/hud
pause = false
pause_hud = nil
pause_menu = nil

queue = Rubygame::Queue.instance

#Main Loop
loop do
  clock.tick()
  queue.get().each do |event|
    case event
    when Rubygame::QuitEvent
      exit
    when Rubygame::KeyDownEvent
      case event.key
      when Rubygame::K_ESCAPE then exit
      when Rubygame::K_RETURN then pause = !pause
      when Rubygame::K_LEFT   then player.walk :left
      when Rubygame::K_RIGHT  then player.walk :right
      when Rubygame::K_X      then player.attack()
      when Rubygame::K_UP     then player.jump()
      end
    when Rubygame::KeyUpEvent
      case event.key
      when Rubygame::K_LEFT  then player.stop_walk :left
      when Rubygame::K_RIGHT then player.stop_walk :right
      when Rubygame::K_X     then player.stop_attack()
      end
    when Rubygame::MouseDownEvent
      if event.string == 'left'
        if pause_hud.respond_to?('click')
          pause_hud.click(event.pos)
        end
      end
    end
  end
  if !pause
    pause_menu = nil ; pause_hud = nil ; pause_tick = nil
    background.blit(screen, [0, 0])

    life_display.update(player.life.to_s, screen)
    fps_display.update(clock.fps.to_s, screen)

    player.update(player.collide_group(enemies))

    enemies.update()

    player.draw(screen)
    enemies.draw(screen)

    screen.update()
  else 
    # Make the pause menu
    pause_menu = UI::Menu.new()
    pause_menu.push(UI::Buttons::Quit.new())
    pause_hud = UI::Hud.new(pause_menu, [50,50])

    Rubygame::TTF.setup()
    font = Rubygame::TTF.new('font.ttf', 25)
    pause_text = '[PAUSED]'
    prender = font.render(pause_text, true, [0,0,0])
    prender.blit(screen, [240,200])

    pause_hud.draw(screen)
    fps_display.update(clock.fps.to_s, screen)
    screen.update()
  end
end
