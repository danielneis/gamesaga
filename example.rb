#!/usr/bin/env ruby
require 'rubygame'
Rubygame.init()

size = [640, 480]
speed = [2, 2]
black = 0, 0, 0

Rubygame.init()

queue = Rubygame::Queue.instance

class Panda

    include Rubygame::Sprites::Sprite

    @@pandapic = Rubygame::Image.load("samples/panda.png")
    @@pandapic.set_colorkey(@@pandapic.get_at([0,0]))

    def initialize(x,y)
	super()
	@image = @@pandapic
	@rect = Rubygame::Rect.new(x,y,*@@pandapic.size)
    end

end

class PandaGroup < Rubygame::Sprites::Group
	include Rubygame::Sprites::UpdateGroup
end

# Create the SDL window
screen = Rubygame::Screen.set_mode(size)
screen.set_caption("teste do Rubygame")

# Create the very cute panda objects!
panda1 = Panda.new(10,10)
panda2 = Panda.new(50,50)
panda3 = Panda.new(100,100)

# Create the grou and put the pandas on it
pandas = PandaGroup.new
pandas.push(panda1,panda2,panda3)

# Make the background surface
background = Rubygame::Surface.new(screen.size)

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
		    end
	    end
	end
	pandas.undraw(screen,background)
	pandas.draw(screen)
	screen.update()
    end
end    
