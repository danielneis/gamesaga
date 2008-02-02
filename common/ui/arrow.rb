class Arrow
  include Rubygame::Sprites::Sprite

  def  initialize start_point, jump_size, positions

    super()
    @image = Rubygame::Surface.load_image('arrow.png')
    @rect = @image.make_rect
    @rect.move! *start_point
    @jump_size = jump_size
    @positions = positions
    @current_position = 1
  end

  def next
    if @current_position < @positions
      @rect.move!(0, @jump_size)
      @current_position += 1
    end
  end

  def previous
    if @current_position > 1
      @rect.move!(0, -@jump_size)
      @current_position -= 1
    end
  end
end
