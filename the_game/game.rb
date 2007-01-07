#!/usr/bin/env ruby
require 'rubygame'
require 'config.rb'
require 'fps.class.rb'
require 'player.class.rb'

Rubygame.init()

# Create the SDL window, event queue and fps clock
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)
queue = Rubygame::Queue.instance
clock = Rubygame::Time::Clock.new()

# Make the background
background = Rubygame::Image.load('castle.png')
background.blit(screen,[0,0])

# Create the life bar, FPS display etc.
life =  nil
fps_display = Fps_display.new(clock.fps.to_s)
fps_display.text.blit(screen, [0,0])

# Create the player character
player = Player.new()

# Create the group and put the everything needed on it
allsprites = Rubygame::Sprites::Group.new()
allsprites.push(player)

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
		    when Rubygame::K_UP
			player.set_state(:up)
		    when Rubygame::K_DOWN
			player.set_state(:down)
		    when Rubygame::K_LEFT
			player.set_state(:left)
		    when Rubygame::K_RIGHT
			player.set_state(:right)
		end
	    when Rubygame::KeyUpEvent
		case event.key
		    when Rubygame::K_UP 
			if  player.state == :up then
			    player.set_state(:still)
			end
		    when Rubygame::K_DOWN
			if  player.state == :down then
			    player.set_state(:still)
			end
		    when Rubygame::K_LEFT
			if  player.state == :left then
			    player.set_state(:still)
			end
		    when Rubygame::K_RIGHT
			if  player.state == :right then
			    player.set_state(:still)
			end
		end
	end
    end
    background.blit(screen, [0, 0])

    fps_display.text = clock.fps.to_s
    fps_display.text.blit(screen, [0,0])

    allsprites.update
    allsprites.draw(screen)
    screen.update()
end
