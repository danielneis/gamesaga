class Player

    include Rubygame::Sprites::Sprite

    def initialize(x,y)
	super()
	@image = Rubygame::Image.load("samples/panda.png")
	@image.set_colorkey(@image.get_at([0,0]))
	@rect = Rubygame::Rect.new(x,y,*@image.size)
	# @area is the area of the screen, which the player will walk across
	screen = Rubygame::Screen.get_surface
	@area = Rubygame::Rect.new(0,0,*screen.size)

	@speed = 1
	@state = :still
    end

    def state=(s)
	@state = s
    end

    # to move the character on each direction
    def update()
	case @state
	    when :up
		if !(@rect.top < @area.top)
		     @rect.move!(0,-@speed)
		end
	    when :down
		if !(@rect.bottom > @area.bottom)
		     @rect.move!(0,@speed)
		end
	    when :left
		if !(@rect.left < @area.left)
		     @rect.move!(-@speed, 0)
		end
	    when :right
		if !(@rect.right > @area.right)
		     @rect.move!(@speed, 0)
		end
	end
    end
end
