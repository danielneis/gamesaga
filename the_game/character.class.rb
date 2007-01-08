class Character
    include Rubygame::Sprites::Sprite

    attr_accessor :state, :rect, :life

    def initialize(x, y, image)
	super()
	@image = Rubygame::Image.load(PIX_ROOT+image)
	@image.set_colorkey(@image.get_at([0, 0]))
	@rect = Rubygame::Rect.new(x, y, *@image.size)

	# @area is the area of the screen, which the player will walk across
	@area = Rubygame::Rect.new(0, 0, *[SCREEN_WIDTH, SCREEN_HEIGHT])

	@speed = 2
	@state = :still
        @life = 100
    end

    def take_damage(amount)
       @life = @life - amount
       puts @life
    end

    # to move the character on each direction
    def update()
	case @state
	    when :left
		if !(@rect.left < @area.left)
                    self.move_left
		end
	    when :right
		if !(@rect.right > @area.right)
                    self.move_right
		end
	end
    end

    def move_left
        @rect.move!(-@speed, 0)
    end

    def move_right
        @rect.move!(@speed, 0)
    end
end
