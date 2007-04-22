class MainMenu

  def initialize

    yield self if block_given?

    @screen = Rubygame::Screen.get_surface
    @clock = Rubygame::Time::Clock.new(35)
    @queue = Rubygame::Queue.instance

    menu = UI::Menu.new(:horizontal)
    menu.push(UI::Buttons::NewGame.new(@state_machine), UI::Buttons::Quit.new(@state_machine))
    @hud = UI::Hud.new(menu, :bottom)

    @background = Rubygame::Image.load(PIX_ROOT+'menu_background.jpg')
    @background.blit(@screen, [0,0])

    @screen.show_cursor = true

    loop do
      update
    end
  end

  def update

    @clock.tick()
    @queue.get().each do |event|
      case event
      when Rubygame::QuitEvent then exit
      when Rubygame::KeyDownEvent
        case event.key
        when Rubygame::K_ESCAPE then exit
        when Rubygame::K_RETURN then notify :start_game
        end
      when Rubygame::MouseDownEvent
        if event.string == 'left'
          if @hud.respond_to?('click')
            @hud.click(event.pos)
          end
        end
      end
    end

    @hud.draw(@screen)
    @screen.update()
  end

  def on(event, &callback)
    (@listeners ||= {})[event] = callback
  end

  private
  def notify(event, *args)
    @listeners[event].call(*args) if @listeners[event].respond_to? :call
  end

end

