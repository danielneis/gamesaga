class Player

    include Rubygame::Sprites::Sprite

    attr_accessor :state

    def initialize(x,y)
	super()
	@image = Rubygame::Image.load("panda.png")
	@image.set_colorkey(@image.get_at([0, 0]))
	@rect = Rubygame::Rect.new(x, y, *@image.size)
	# @area is the area of the screen, which the player will walk across
	@area = Rubygame::Rect.new(0, 0, *[SCREEN_WIDTH, SCREEN_HEIGHT])

	@speed = 2
	@state = :still
    end

    def set_state(s)
	@state = s
    end

    # to move the character on each direction
    def update()
	case @state
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
