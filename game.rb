#!/usr/bin/env ruby
require 'rubygame'
require 'config.rb'
require 'player.class.rb'

Rubygame.init()

queue = Rubygame::Queue.instance

# Create the SDL window
size = [SCREEN_WIDTH, SCREEN_HEIGHT]
screen = Rubygame::Screen.set_mode(size)
screen.set_caption("Joguinho...")

# Create the player character
player = Player.new()

# Create the group and put the characters on it
allsprites = Rubygame::Sprites::Group.new()
allsprites.push(player)

# Make the background
background = Rubygame::Image.load('castle.png')
background.blit(screen,[0,0])

catch(:rubygame_quit)    do
    loop do
	queue.get().each do |event|
	    case event
		when Rubygame::QuitEvent
		    throw :rubygame_quit
		when Rubygame::KeyDownEvent
		    case event.key
			when Rubygame::K_ESCAPE
			    throw :rubygame_quit 
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
			when Rubygame::K_UP, Rubygame::K_DOWN, Rubygame::K_LEFT, Rubygame::K_RIGHT
			    player.set_state(:still)
		    end
	    end
	end
	background.blit(screen, [0, 0])
	allsprites.update
	allsprites.draw(screen)
	screen.update()
    end
end    
