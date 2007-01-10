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
        @jump_stage = 0
        @jump_stages = 10

	@walk_speed = 2
        @jump_speed = -@walk_speed * 5
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

        if !(Rubygame::Time.get_ticks - @prevAnim < 25) then
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
            when :attacking
                if (@image != @attack_image) then
                    @image = @attack_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end
            when :jumping
                if @jump_stage < @jump_stages then
                    if @direction == :left then
                    elsif @direction == :right then
                    elsif @direction ==  nil then
                        move_still_jump()
                    end
                    @jump_stage = @jump_stage + 1
                else 
                    @state = :falling
                    @jump_stage = 0
                end
            when :falling
                if @jump_stage < @jump_stages then
                    if @direction == :left then
                        @state = :walking
                    elsif @direction == :right then
                        @state = :walking
                    elsif @direction == nil then
                        move_still_fall()
                    end
                    @jump_stage = @jump_stage + 1
                else
                    @state = :still
                    @jump_stage = 0
                end
            when :still
                if (@image == @attack_image) then
                    @image = @still_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end 
            else
        end
        @prevAnim = Rubygame::Time.get_ticks
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
