class Character
    include Rubygame::Sprites::Sprite

    attr_accessor :state, :direction, :rect, :life

    def initialize(x, y, image)
	super()
	@still_image = Rubygame::Image.load(PIX_ROOT+image)
        @attack_image = Rubygame::Image.load(PIX_ROOT+'panda.attack.png')

        @image = @still_image
	@image.set_colorkey(@image.get_at([0, 0]))
	@rect = Rubygame::Rect.new(x, y, *@image.size)

	# @area is the area of the screen, which the player will walk across
	@area = Rubygame::Rect.new(0, 0, *[SCREEN_WIDTH, SCREEN_HEIGHT])

        # to use in first call of update methods
        @prevAnim = Rubygame::Time.get_ticks()

	@walk_speed = 2
        @jump_speed = -@walk_speed * 10
        @fall_speed = -@jump_speed
        @direction =  nil 
	@state = :still
        @life = 100
    end

    def take_damage(amount)
       @life = @life - amount
    end

    # to move the character on each direction
    def update()
        case @state
            when :walking
                case @direction
                    when :left
                        if !(@rect.left < @area.left)
                            self.move_left
                        end
                    when :right
                        if !(@rect.right > @area.right)
                            self.move_right
                        end
                end
            when :attack
                if (@image != @attack_image) then
                    @image = @attack_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end
            when :jumping
                if @direction == :left then
                elsif @direction == :right then
                elsif @direction ==  nil then
                    move_still_jump()
                    @state = :jumping2
                end
            when :jumping2
                if @direction == :left then
                elsif @direction == :right then
                elsif @direction ==  nil then
                    move_still_jump()
                    @state = :falling
                end
            when :falling
                if @direction == :left then
                    @state = :walking
                elsif @direction == :right then
                    @state = :walking
                elsif @direction == nil then
                    move_still_fall()
                    @state = :falling2
                end
            when :falling2
                if @direction == :left then
                    @state = :walking
                elsif @direction == :right then
                    @state = :walking
                elsif @direction == nil then
                    move_still_fall()
                    @state = :still
                end
            when :still
                if (@image == @attack_image) then
                    @image = @still_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end 
            else
        end
    end

    def move_left
        @rect.move!(-@walk_speed, 0)
    end

    def move_right
        @rect.move!(@walk_speed, 0)
    end

    def move_still_jump
        @rect.move!(0, @jump_speed)
    end

    def move_still_fall
        @rect.move!(0, @fall_speed)
    end
end
