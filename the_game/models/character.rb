require File.dirname(__FILE__) + '/../lib/fsm'
require File.dirname(__FILE__) + '/model'
require 'lib/states'

module Models
class Character < Model

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
      define_method( :initialize ) do |pos, image|
        super()

        config = Configuration.instance

        self.class.traits.each do |k,v|
          instance_variable_set("@#{k}", v)
        end

        @still_image = Rubygame::Surface.load_image(config.pix_root + image)
        @still_image.set_colorkey(@still_image.get_at([0,0]))

        @attack_image = Rubygame::Surface.load_image(config.pix_root + 'panda.attack.png')
        @attack_image.set_colorkey(@attack_image.get_at([0,0]))
        
        @image = @still_image
        @rect = @image.make_rect
        @rect.move!(*pos)

        # @area is the area of the screen, which the player will walk across
        @area = Rubygame::Rect.new(0, config.screen_height / 2, *[config.screen_width, config.screen_height / 2])

        @state_machine = FiniteStateMachine.new(self)

        @x_speed = 0
        @y_speed = 0
      end
    end
  end

  
  # Creature attributes are read-only
  traits :life, :strength, :speed, :jump_s

  attr_reader :damage, :items_to_catch
  attr_accessor :x_speed, :y_speed

  def take_damage(amount, to_side)
    @damage = amount
    change_state(States::Hitted) unless in_state? States::Hitted
  end

  def walk(direction)

    unless in_state? States::Jump
      case direction
      when :left then @x_speed = -@speed
      when :right then @x_speed = @speed
      when :up then @y_speed = -@speed
      when :down then @y_speed = @speed
      end
      change_state(States::Walk)
    end
  end

  def stop_walk(direction)

    if in_state? States::Jump
      case direction
      when :left
        set_next_state(States::Stop) if @x_speed < 0
      when :right
        set_next_state(States::Stop) if @x_speed > 0
      when :up
        set_next_state(States::Stop) if @y_speed < 0
      when :down
        set_next_state(States::Stop) if @y_speed > 0
      end
    else
      case direction
      when :left
        @x_speed = 0 if @x_speed < 0
      when :right
        @x_speed = 0 if @x_speed > 0
      when :up
        @y_speed = 0 if @y_speed < 0
      when :down
        @y_speed = 0 if @y_speed > 0
      end
    end
  end

  def jump
    change_state(States::Jump) unless in_state? States::Jump
  end

  def move
    @rect.move!(@x_speed, @y_speed)

    @ground = @rect.bottom unless in_state? States::Jump
  end

  def undo_move
    @rect.move!(-@x_speed, -@y_speed)
  end

  def should_walk
    ((@rect.x + @x_speed > @area.x) &&
     (@rect.r + @x_speed < @area.r) &&
     (@rect.y + @y_speed > @area.y) &&
     (@rect.b + @y_speed < @area.b))
  end

  def attack
    change_state(States::Attack) if not in_state? States::Jump
  end

  def catch_items(items)
    @items_to_catch = items
    change_state(States::Catch)
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

  def update(*collidables)
    @collidables = collidables.flatten!
    @state_machine.update()
  end

  def collisions
    collide_group(@collidables).reject { |c| !c.ground.intersects?(ground) }
  end

  def ground
    (@rect.cy)..(@rect.bottom)
  end
end
end
