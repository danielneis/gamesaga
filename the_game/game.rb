#!/usr/bin/env ruby
require 'rubygame'
require 'config.rb'
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

# Make the background
background = Rubygame::Image.load(PIX_ROOT+'background.png')
background.blit(screen,[0,0])

# Create the life bar, FPS display etc.
life_display =  Display.new('Life',player.life.to_s)
clock = Rubygame::Time::Clock.new()
fps_display = Display.new('FPS', clock.fps.to_s)
fps_display.text.blit(screen, [0,0])
        
# Create the group and put the everything needed on it
allsprites = Rubygame::Sprites::Group.new()
allsprites.push(player, enemy)

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
		    when Rubygame::K_ESCAPE
			exit
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
	end
    end
    background.blit(screen, [0, 0])

    life_display.text = player.life.to_s
    life_display.text.blit(screen, [50, 0])

    fps_display.text = clock.fps.to_s
    fps_display.text.blit(screen, [0,0])

    allsprites.update
    allsprites.draw(screen)
    env.handle_collisions
    screen.update()
end
