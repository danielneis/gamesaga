#!/usr/bin/env ruby
require 'rubygame'
require 'config.rb'
require 'ui/hud.rb'
require 'ui/menu.rb'
require 'ui/buttons.rb'
require 'display.rb'
require 'environment.rb'
require 'character.rb'
require 'player.rb'
require 'enemy.rb'

# Initialize rubygame and set up screen
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)

player = Player.new(400, 350, 'panda.png')
enemy = Enemy.new(200, 350, 'panda.invert.png')
env = Environment.new(player, enemy, screen.make_rect, screen)

# Make the pause menu
menu = UI::Menu.new()
menu.push(UI::Buttons::Quit.new())
hud = UI::Hud.new(menu, [50,50])
pause = false

# Make the background
background = Rubygame::Image.load(PIX_ROOT+'background.png')
background.blit(screen,[0,0])

# Create the life bar, FPS display etc.
life_display =  Display.new('Life',player.life.to_s, [50,0])
clock = Rubygame::Time::Clock.new()
fps_display = Display.new('FPS', clock.fps.to_s, [0,0])


# Create the group and put the everything needed on it
allsprites = Rubygame::Sprites::Group.new()
allsprites.push(player, enemy)

queue = Rubygame::Queue.instance

#Main Loop
while env.state == :started do
  clock.tick()
  queue.get().each do |event|
    case event
    when Rubygame::QuitEvent
      exit
    when Rubygame::KeyDownEvent
      case event.key
      when Rubygame::K_ESCAPE
        exit
      when Rubygame::K_RETURN
        pause = !pause
        player.horizontal_direction = nil
        player.vertical_direction = nil
        player.state = nil
      when Rubygame::K_LEFT
        player.horizontal_direction = :left
      when Rubygame::K_RIGHT
        player.horizontal_direction = :right
      when Rubygame::K_X
        player.state = :attacking if player.vertical_direction.nil?
      when Rubygame::K_UP
        player.vertical_direction = :up if player.vertical_direction.nil?
      end
    when Rubygame::KeyUpEvent
      case event.key
      when Rubygame::K_LEFT
        player.horizontal_direction = nil if player.horizontal_direction == :left
      when Rubygame::K_RIGHT
        player.horizontal_direction = nil if player.horizontal_direction == :right
      when Rubygame::K_X
        player.state = :still if player.state == :attacking and player.vertical_direction.nil?
      end
    when Rubygame::MouseDownEvent
      hud.click(event.pos) if event.string == 'left'
    end
  end
  if !pause
    background.blit(screen, [0, 0])

    life_display.update(player.life.to_s, screen)
    fps_display.update(clock.fps.to_s, screen)

    allsprites.update()
    allsprites.draw(screen)
    env.update
    screen.update()
  else 
    Rubygame::TTF.setup()
    font = Rubygame::TTF.new('font.ttf', 25)
    pause_text = '[PAUSED]'
    prender = font.render(pause_text, true, [0,0,0])
    prender.blit(screen, [240,200])

    hud.draw(screen)
    screen.update()
  end
end
