#!/usr/bin/env ruby
require 'rubygame'
require 'config.rb'
require 'life.class.rb'
require 'fps.class.rb'
require 'environment.class.rb'
require 'character.class.rb'
require 'player.class.rb'
require 'enemy.class.rb'

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
life_display =  Life_display.new(player.life.to_s)
clock = Rubygame::Time::Clock.new()
fps_display = Fps_display.new(clock.fps.to_s)
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
                        if player.state != :jumping and player.state != :falling then
                            player.direction = :left
                            player.state = :walking
                        end
		    when Rubygame::K_RIGHT
                        if player.state != :jumping and player.state != :falling then
                            player.direction = :right
                            player.state = :walking
                        end
                    when Rubygame::K_X
                        if player.state != :jumping and player.state != :falling then
                            player.state = :attacking
                        end
                    when Rubygame::K_UP
                        if player.state != :jumping and player.state != :falling then
                            player.state = :jumping
                        end
		end
	    when Rubygame::KeyUpEvent
		case event.key
		    when Rubygame::K_LEFT
			if  player.direction == :left and player.state != :jumping and player.state != :falling then
                            player.direction = nil 
			    player.state = :still
			end
		    when Rubygame::K_RIGHT
			if  player.direction == :right and player.state != :jumping and player.state != :falling then
                            player.direction = nil
			    player.state = :still
			end
                    when Rubygame::K_X
                        if player.state == :attacking and player.state != :jumping and player.state != :falling then
                            player.state = :still
                        end
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
