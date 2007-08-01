module UI
class Menu < Rubygame::Sprites::Group

  include Rubygame::Sprites::UpdateGroup

  attr_reader :width, :height

  def initialize(orientation, margin = 10)

    super()

    @orientation = orientation
    @margin = margin
    @component_height = 0
    @component_width  = 0
    @focused = Components::Component.new
  end

  def push(*args)

    super(*args)

    each do |component|
      @component_height = component.height if component.height > @component_height
      @component_width = component.width if component.width > @component_width
      # special case to radiobuttons: need a group to manage them
      if component.is_a? Components::RadioButton
        @radio_groups ||= {}
        @radio_groups[component.group] ||= Components::RadioGroup.new()
        @radio_groups[component.group].add component
      end
    end

    if @orientation == :vertical
      @height = (@component_height * length) + ((length + 1) * @margin)
      @width  = @component_width + @margin * 2
    elsif @orientation == :horizontal
      @width = (@component_width * length) + ((length + 1) * @margin)
      @height  = @component_height + @margin * 2
    end
  end

  def size
    [@width, @height]
  end

  def align(position)

    image_detour = @margin / 2
    collect do |component|

      component.reset_position!

      if @orientation == :vertical
        component.move!(@margin, @margin + image_detour)
      elsif @orientation == :horizontal
        component.move!(@margin + image_detour, @margin)
      end

      component.move!(*position)

      if @orientation == :vertical
        image_detour += @component_height + @margin
      elsif @orientation == :horizontal
        image_detour += @component_width + @margin
      end
    end

    @rect = Rubygame::Rect.new(position[0], position[1], @width, @height)
  end

  def click(position)

    clicked = nil
    self.each do |component|
      unless component.is_a? Components::RadioGroup
        if component.collide_point?(*position)
          clicked = component
          component.click position
        end
      end
    end

    if clicked.nil?
      @focused.lost_focus
      @focused = Components::Component.new
    elsif (clicked != @focused)
      @focused.lost_focus
      @focused = clicked
    end
  end

  def handle_input(input)
    @focused.handle_input(input)
  end

  def values
    values = {}
    self.each do |component|
      if component.is_a? Components::RadioButton
        values[component.group] ||= nil
        values[component.group] = component.value if component.checked?
      else
        values[component.id] = component.value
      end
    end
    values
  end
end
end
