class Character

  include Rubygame::Sprites::Sprite
  
  # Get a metaclass for this class
  def self.metaclass; class << self; self; end; end

  # Advanced metaprogramming code for nice, clean traits
  def self.traits( *arr )
    return @traits if arr.empty?

    # 1. Set up readers for each variable
    attr_reader *arr

    # 2. Add a new class method to for each trait.
    arr.each do |a|
      metaclass.instance_eval do
        define_method( a ) do |val|
          @traits ||= {}
          @traits[a] = val
        end
      end
    end

    # 3. For each monster, the `initialize' method
    #    should use the default number for each trait.
    class_eval do
      define_method( :initialize ) do |x,y,image|
        super()

        self.class.traits.each do |k,v|
          instance_variable_set("@#{k}", v)
        end

        @still_image = Rubygame::Image.load(PIX_ROOT+image)
        @attack_image = Rubygame::Image.load(PIX_ROOT+'panda.attack.png')

        @image = @still_image
        @image.set_colorkey(@image.get_at([0, 0]))
        @rect = Rubygame::Rect.new(x, y, *@image.size)

        # @area is the area of the screen, which the player will walk across
        @area = Rubygame::Rect.new(0, 403, *[SCREEN_WIDTH, SCREEN_HEIGHT - 403])

        # to use in first call of update methods
        @prevAnim = Rubygame::Time.get_ticks()

        # to use in jump methods
        @jump_stage = 0
        @jump_stages = 5

        # some speeds
        @jump_speed = -(@speed * 6)
        @direction =  nil 
        @state = nil

      end
    end
  end
  
  # Creature attributes are read-only
  traits :life, :strength, :speed

  attr_reader :rect

  def take_damage(amount, to_side)
    @life = @life - amount
    @horizontal_direction = to_side
    @vertical_direction = :up
  end

  def walk(direction)
    if direction == :left or direction == :right
      @horizontal_direction = direction
    elsif direction == :up or direction == :down
      @vertical_direction = direction
    end
  end

  def stop_walk(direction)
    if @horizontal_direction == direction
      @horizontal_direction = nil
    elsif @vertical_direction == direction
      @vertical_direction = nil
    end
  end

  def jump()
    @vertical_direction = :up if @vertical_direction.nil?
  end

  def attack(direction = :right)
    @state = :attacking if @vertical_direction.nil?
  end

  def stop_attack(direction = :right)
    @state = :still if @state == :attacking
  end


  # to move the character on each direction
  def update()

    if !(Rubygame::Time.get_ticks - @prevAnim < 25)

      # to walk left and right
      if @horizontal_direction == :left and @rect.left > @area.left
        @horizontal_speed = -@speed
      elsif @horizontal_direction == :right and @rect.right < @area.right
        @horizontal_speed = @speed
      else
        @horizontal_direction = nil
        @horizontal_speed = 0
      end

      # to walk up and down
      if @vertical_direction == :up and @rect.bottom > @area.top
        @vertical_speed = -@speed
      elsif @vertical_direction == :down and @rect.bottom < @area.bottom
        @vertical_speed = @speed
      else
        @vertical_direction = nil
        @vertical_speed = 0
      end

      # to jump and to fall
      #if @vertical_direction == :up
      #  if @jump_stage < @jump_stages
      #    @vertical_speed = @jump_speed
      #    @jump_stage += 1
      #  else
      #    @vertical_direction = :down
      #    @jump_stage = 0
      #  end
      #elsif  @vertical_direction == :down
      #  if @rect.bottom < @ground
      #    @vertical_speed = -@jump_speed
      #  else
      #    @vertical_direction = nil
      #  end
      #else
      #  @vertical_direction = nil
      #  @vertical_speed = 0 
      #end

      # to jump far
      #@horizontal_speed = @horizontal_speed * 5 if @vertical_speed != 0

      if @state == :attacking
        if (@image != @attack_image)
          @image = @attack_image
          @image.set_colorkey(@image.get_at([0, 0]))
          @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
        end
      else 
        if @image == @attack_image
          @image = @still_image
          @image.set_colorkey(@image.get_at([0, 0]))
          @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
        end
        # move the character
        @rect.bottom = @rect.bottom + @vertical_speed
        @rect.x = @rect.x + @horizontal_speed
      end
      @prevAnim = Rubygame::Time.get_ticks
    end

  end
end
