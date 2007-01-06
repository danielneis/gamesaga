#!/usr/bin/env ruby
require 'rubygame'
Rubygame.init()


Rubygame.init()

queue = Rubygame::Queue.instance

# Create the SDL window
size = [640, 480]
screen = Rubygame::Screen.set_mode(size)
screen.set_caption("teste do Rubygame")

class Panda

    include Rubygame::Sprites::Sprite

    def initialize(x,y)
	super()
	@pandapic = Rubygame::Image.load("samples/panda.png")
	@pandapic.set_colorkey(@pandapic.get_at([0,0]))
	@rect = Rubygame::Rect.new(x,y,*@pandapic.size)
	@image = @pandapic
	# @area is the area of the screen, which the panda will walk across
	screen = Rubygame::Screen.get_surface
	@area = Rubygame::Rect.new(0,0,*screen.size)

	@speed = 10

    end

    def walk(direction)
	
	case direction
	    when 'left'
		if !(@rect.left < @area.left)
		     @rect.move!(-@speed, 0)
		end
	    when 'right'
		if !(@rect.right > @area.right)
		     @rect.move!(@speed, 0)
		end
	    when 'up'
		if !(@rect.top < @area.top)
		     @rect.move!(0,-@speed)
		end
	    when 'down'
		if !(@rect.bottom > @area.bottom)
		     @rect.move!(0,@speed)
		end
	end
    end

    def update(direction)
	walk(direction)
    end

    private :walk

end


# Create the very cute panda objects!
panda = Panda.new(300,150)

# Create the grou and put the pandas on it
allsprites = Rubygame::Sprites::Group.new()
allsprites.push(panda)

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
			    allsprites.update('up')
			when Rubygame::K_DOWN
			    allsprites.update('down')
			when Rubygame::K_LEFT
			    allsprites.update('left')
			when Rubygame::K_RIGHT
			    allsprites.update('right')
		    end
	    end
	end
	background.blit(screen, [0, 0])
	allsprites.draw(screen)
	screen.update()
    end
end    
