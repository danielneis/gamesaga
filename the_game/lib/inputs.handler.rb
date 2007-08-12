class InputsHandler

  attr_writer :key_up, :key_down, :mouse_up, :mouse_down

  def initialize

    @key_up, @key_down, @mouse_up, @mouse_down = {}, {}, {}, {}
    @queue = Rubygame::EventQueue.new

    yield self if block_given?
  end

  def ignore=(ignore)
    @queue.ignore = ignore
  end

  def handle
      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          @key_down[:any].call(event) if @key_down.include? :any
          if @key_down.include?(event.key)
            @key_down[event.key].call if @key_down[event.key].respond_to? :call
          end
        when Rubygame::KeyUpEvent
          if @key_up.include?(event.key)
            @key_up[event.key].call if @key_up[event.key].respond_to? :call
          end
        when Rubygame::MouseDownEvent
          if @mouse_down.include?(event.string)
            @mouse_down[event.string].call(event) if @mouse_down[event.string].respond_to? :call
          end
        when Rubygame::MouseUpEvent
          if @mouse_up.include?(event.string)
            @mouse_up[event.string].call(event) if @mouse_up[event.string].respond_to? :call
          end
        end
      end
  end
end
