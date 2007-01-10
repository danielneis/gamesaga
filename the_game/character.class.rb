class Character
    include Rubygame::Sprites::Sprite

    attr_accessor :state, :last_state, :rect, :life

    def initialize(x, y, image)
	super()
	@still_image = Rubygame::Image.load(PIX_ROOT+image)
        @attack_image = Rubygame::Image.load(PIX_ROOT+'panda.attack.png')

        @image = @still_image
	@image.set_colorkey(@image.get_at([0, 0]))
	@rect = Rubygame::Rect.new(x, y, *@image.size)

	# @area is the area of the screen, which the player will walk across
	@area = Rubygame::Rect.new(0, 0, *[SCREEN_WIDTH, SCREEN_HEIGHT])

	@speed = 2
        @last_state = nil
	@state = :still
        @life = 100
    end

    def take_damage(amount)
       @life = @life - amount
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
            when :attack
                if (@image != @attack_image) then
                    @image = @attack_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end
            when :up
                if @last_state == :left or @last_state == :right then
                    puts 'state = '+@state.to_s+' last = andando'
                elsif @last_state == :still then
                    puts 'state = '+@state.to_s+' last = parado'
                end
                @state = @last_state
            when :still
                if (@image == @attack_image) then
                    @image = @still_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end 
            else
	end
        @last_state = @state
    end

    def move_left
        @rect.move!(-@speed, 0)
    end

    def move_right
        @rect.move!(@speed, 0)
    end
end
