class Character

    include Rubygame::Sprites::Sprite

    attr_accessor :state, :horizontal_direction, :vertical_direction, :rect
    attr_reader :life

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

        # to use in jump methods
        @jump_stage = 0
        @jump_stages = 5
        @ground = @rect.bottom

        # some speeds
	@walk_speed = 3
        @jump_speed = -@walk_speed * 6
        @direction =  nil 
        @state = nil
        @life = 100

    end

    def take_damage(amount, relative_position)

        @life = @life - amount
        @horizontal_direction = relative_position
        @vertical_direction = :up

    end

    # to move the character on each direction
    def update()

        if !(Rubygame::Time.get_ticks - @prevAnim < 25) then
            
            # to walk left and right
            if @horizontal_direction == :left and @rect.left > @area.left then
                @horizontal_speed = -@walk_speed
            elsif @horizontal_direction == :right and @rect.right < @area.right then
                @horizontal_speed = @walk_speed
            else
                @horizontal_direction = nil
                @horizontal_speed = 0
            end

            # to jump and to fall
            if @vertical_direction == :up then
                if @jump_stage < @jump_stages then
                    @vertical_speed = @jump_speed
                    @jump_stage = @jump_stage + 1
                else
                   @vertical_direction = :down
                   @jump_stage = 0
                end
            elsif  @vertical_direction == :down then
                if @rect.bottom < @ground then
                    @vertical_speed = -@jump_speed
                else
                    @vertical_direction = nil
                end
            else
                @vertical_direction = nil
                @vertical_speed = 0 
            end

            # to jump far
            if @vertical_speed != 0 then
                @horizontal_speed = @horizontal_speed * 5
            end

            if @state == :attacking then
                if (@image != @attack_image) then
                    @image = @attack_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end
            else 
                if @image == @attack_image then
                    @image = @still_image
                    @image.set_colorkey(@image.get_at([0, 0]))
                    @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
                end
                # move the character
                @rect.bottom = @rect.bottom + @vertical_speed
                if @rect.bottom > @ground then
                    @rect.bottom = @ground
                end
                @rect.x = @rect.x + @horizontal_speed
            end
            @prevAnim = Rubygame::Time.get_ticks
        end
    end
end
