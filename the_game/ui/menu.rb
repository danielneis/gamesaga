module UI
class Menu < Rubygame::Sprites::Group

  attr_reader :width, :height

  def initialize(orientation, margin = 10)

    @orientation = orientation
    @margin = margin
    @component_height = 0
    @component_width  = 0
    @focused = Components::Component.new
  end

  def push(*args)

    super(*args)

    args.each do |component|
      @component_height = component.rect.h if component.rect.h > @component_height
      @component_width = component.rect.w if component.rect.w > @component_width

      # special case to radiobuttons: need a group to manage them
      if component.is_a? Components::RadioButton
        @radio_groups ||= {}
        @radio_groups[component.group] ||= Components::RadioGroup.new()
        @radio_groups[component.group].add component
      end
    end

    if @orientation == :vertical
      @height = (@component_height * self.length) + ((self.length + 1) * @margin)
      @width  = @component_width + @margin * 2
    elsif @orientation == :horizontal
      @width = (@component_width * self.length) + ((self.length + 1) * @margin)
      @height  = @component_height + @margin * 2
    end
  end

  def size
    return [@width, @height]
  end

  # vamos documentar algo estranho aqui...
  # primeiro eu preciso mover o retângulo da imagem e sua posição está relacionada com a 'surface'  na qual vai ser desenhada
  # depois disso eu a desenho e parece que seu retângulo volta para a posição [0,0]
  # por ultimo eu preciso mover o retângulo novamente para cima da imagem, mas agora a sua posição está relacionada a tela
  # muito bizarro. ainda não sei por que isso acontece...
  def draw(destination, position)

    image_detour = @margin / 2
    self.collect do |component|

      if @orientation == :vertical
        component.rect.move!(@margin, @margin + image_detour)
      elsif @orientation == :horizontal
        component.rect.move!(@margin + image_detour, @margin)
      end

      component.draw(destination)
      component.rect.move!(*position)

      if @orientation == :vertical
        image_detour += @component_height + @margin
      elsif @orientation == :horizontal
        image_detour += @component_width + @margin
      end
    end
  end

  def redraw(destination)
    self.collect do |component|
      component.draw(destination)
    end
  end

  def click(position)

    clicked = nil
    self.each do |component|
      unless component.is_a? Components::RadioGroup
        if component.rect.collide_point?(*position)
          clicked = component
          component.click
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
        values[component.group] ||= ''
        values[component.group] = component.value if component.checked?
      else
        values[component.id] = component.value
      end
    end
    values
  end
end
end
