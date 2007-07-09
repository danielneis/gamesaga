require 'lib/states'
require 'character'

class Character

  include EventDispatcher
  include Automata
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

        config = Configuration.instance

        self.class.traits.each do |k,v|
          instance_variable_set("@#{k}", v)
        end

        @still_image = Rubygame::Surface.load_image(config.pix_root + image)
        @still_image.set_colorkey(@still_image.get_at([0,0]))

        @attack_image = Rubygame::Surface.load_image(config.pix_root + 'panda.attack.png')
        @attack_image.set_colorkey(@attack_image.get_at([0,0]))
        
        if config.screen_width == 800
          @still_image = @still_image.zoom(1.4, true)
          @attack_image = @attack_image.zoom(1.4, true)
        end

        @image = @still_image
        @rect = @image.make_rect
        @rect.move!(x,y)

        update_ground

        # @area is the area of the screen, which the player will walk across
        @area = Rubygame::Rect.new(0, 403, *[config.screen_width, config.screen_height - 403])

        @state_machine = FiniteStateMachine.new(self)

        setup_listeners()
      end
    end
  end
  
  # Creature attributes are read-only
  traits :life, :strength, :speed

  attr_reader :rect, :ground, :area, :horizontal_direction, :damage
  attr_accessor :vertical_direction

  def take_damage(amount, to_side)
    @damage = amount
    change_state(States::Hitted) unless in_state? States::Hitted
  end

  def walk(direction)

    if (not in_state? States::Jump)
      if (direction == :left or direction == :right)
        @horizontal_direction = direction
      elsif (direction == :up or direction == :down)
        @vertical_direction = direction
      end
      change_state(States::Walk)
    end
  end

  def stop_walk(direction)
    if in_state?(States::Jump)
      set_next_state(States::Stop) if @horizontal_direction == direction
    else
      @horizontal_direction = nil if @horizontal_direction == direction
    end
    @vertical_direction = nil if @vertical_direction == direction
  end

  def stop
    @horizontal_direction = nil
    @vertical_direction = nil
  end

  def jump
    if not in_state? States::Jump
      @vertical_direction = :up
      update_ground
      change_state(States::Jump)
    end
  end

  def attack(direction = :right)
    change_state(States::Attack) if not in_state? States::Jump
  end

  def move(x = 0, y = 0)
    @rect.bottom += y
    @rect.x += x
  end

  def update_ground
    @ground = @rect.bottom
  end

  def swap_image(image)

    if image == :attack

      @image = @attack_image
      @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)

    elsif image == :still

      @image = @still_image
      @rect = Rubygame::Rect.new(@rect.x, @rect.y, *@image.size)
    end
  end

  def update
    @state_machine.update()
  end
end
