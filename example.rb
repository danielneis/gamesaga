#!/usr/bin/env ruby
require 'rubygame'
Rubygame.init()

size = [640, 480]
speed = 10
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
	# @area is the area of the screen, which the panda will walk across
	@area = Rubygame::Rect.new(0,0,[640,480])

	@xvel = 9 # called self.move in the pygame example
    end

    def walk(x,y)
	newpos = @rect.move(x,y)
	# If the panda starts to walk off the screen
	
	#if (@rect.left < @area.left) or (@rect.right > @area.right)
	#    @xvel = -@xvel		# reverse direction of movement
	#    newpos = @rect.move(@xvel,0) # recalculate with changed velocity
	#    @image = Rubygame::Transform.flip(@image, true, false) # flip x
	#end
	@rect = newpos
    end

    def update(x,y)
	walk(x,y)
    end

    private :walk

end

class PandaGroup < Rubygame::Sprites::Group
	include Rubygame::Sprites::UpdateGroup
end

# Create the SDL window
screen = Rubygame::Screen.set_mode(size)
screen.set_caption("teste do Rubygame")

# Create the very cute panda objects!
panda1 = Panda.new(300,150)

# Create the grou and put the pandas on it
pandas = PandaGroup.new
pandas.push(panda1)

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
			when Rubygame::K_UP
			    pandas.update(0,-speed)
			when Rubygame::K_DOWN
			    pandas.update(0,speed)
			when Rubygame::K_LEFT
			    pandas.update(-speed,0)
			when Rubygame::K_RIGHT
			    pandas.update(speed,0)
		    end
	    end
	end
	background.blit(screen, [0, 0])
	pandas.draw(screen)
	screen.update()
    end
end    
