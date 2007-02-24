class Character

  include Rubygame::Sprites::Sprite
  
  # Get a metaclass for this class
  def self.metaclass; class << self; self; end; end

  # Advanced metaprogramming code for nice, clean traits
  def self.traits( *arr )
    return @traits if arr.empty?

    # 1. Set up readers for each variable
    attr_accessor *arr

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

        @screen = Rubygame::Screen.get_surface

        @still_image = Rubygame::Image.load(PIX_ROOT+image)
        @attack_image = Rubygame::Image.load(PIX_ROOT+'panda.attack.png')

        @image = @still_image
        @image.set_colorkey(@image.get_at([0, 0]))
        @rect = Rubygame::Rect.new(x, y, *@image.size)

        # @area is the area of the screen, which the player will walk across
        @area = Rubygame::Rect.new(0, 403, *[SCREEN_WIDTH, SCREEN_HEIGHT - 403])

        # to use in first call of update methods
        @prevAnim = Rubygame::Time.get_ticks()

        @current_state = AI::States::State.new()
        @last_state = @current_state
      end
    end
  end
  
  # Creature attributes are read-only
  traits :life, :strength, :speed

  attr_reader :current_state, :last_state, :ground, :area, :image, :still_image, :attack_image
  attr_accessor :rect, :vertical_direction, :horizontal_direction

  def take_damage(amount, to_side)
    if not @current_state.is_a? AI::States::Hitted
      @life = @life - amount
      change_state(AI::States::Hitted.new())
    end
  end

  def walk(direction)
    if not @current_state.is_a? AI::States::Jump
      if direction == :left or direction == :right
        @horizontal_direction = direction
        change_state(AI::States::Walk.new(@speed))
      elsif direction == :up or direction == :down
        @vertical_direction = direction
        change_state(AI::States::Walk.new(@speed))
      end
    end
  end

  def stop_walk(direction)
    if not @current_state.is_a? AI::States::Jump
      if @horizontal_direction == direction
        @horizontal_direction = nil
      elsif @vertical_direction == direction
        @vertical_direction = nil
      end
    end
  end

  def jump()
    if not @current_state.is_a? AI::States::Jump
      @vertical_direction = :up
      @ground = @rect.bottom
      change_state(AI::States::Jump.new(@speed, @current_state))
    end
  end

  def attack(direction = :right)
    change_state(AI::States::Attack.new(self))
  end

  def change_state(new_state)

    @current_state.exit(self)

    @last_state = @current_state
    @current_state = new_state

    @current_state.enter(self)
  end


  # to move the character on each direction
  def update()

    if !(Rubygame::Time.get_ticks - @prevAnim < 25)

      @current_state.execute(self)

      @prevAnim = Rubygame::Time.get_ticks

    end

  end
end
