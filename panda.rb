#!/usr/bin/env ruby
require 'rubygame'
require 'player.rb'

Rubygame.init()

# Global constants
SCREEN_WIDTH = 500
SCREEN_HEIGHT = 350

queue = Rubygame::Queue.instance

# Create the SDL window
size = [640, 480]
screen = Rubygame::Screen.set_mode(size)
screen.set_caption("teste do Rubygame")

# Create the player character
player = Player.new(300,150)

# Create the grou and put the pandas on it
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
			    player.state = :up
			when Rubygame::K_DOWN
			    player.state = :down
			when Rubygame::K_LEFT
			    player.state = :left
			when Rubygame::K_RIGHT
			    player.state = :right
		    end
		when Rubygame::KeyUpEvent
		    case event.key
			when Rubygame::K_UP, Rubygame::K_DOWN, Rubygame::K_LEFT, Rubygame::K_RIGHT
			    player.state = :still
		    end
	    end
	end
	background.blit(screen, [0, 0])
	allsprites.update
	allsprites.draw(screen)
	screen.update()
    end
end    
