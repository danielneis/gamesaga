module Menus
  class Main

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

      @screen.update()

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

  class Pause

    def initialize
      @screen.show_cursor = true

      menu = UI::Menu.new(:vertical)
      menu.push(UI::Buttons::MainMenu.new(@state_machine), UI::Buttons::Quit.new(@state_machine))
      @hud = UI::Hud.new(menu, :center)

      @title = Display.new('[PAUSED]', [240,10], '', 25)
      @title.update()

      @hud.draw(@screen)

      @screen.show_cursor = true

      @screen.update()

      loop do
        update
      end
    end

    def update
      @clock.tick()
      #@fps_display.update(@clock.fps.to_s)

      @title.update()
      @hud.draw(@screen)
      @screen.update()

      @queue.get.each do |event|
        case event
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :end_game
          when Rubygame::K_RETURN then performer.back_to_last_state()
          end
        when Rubygame::MouseDownEvent
          if event.string == 'left'
            if @hud.respond_to?('click')
              @hud.click(event.pos)
            end
          end
        end
      end
    end

    def on(event, &callback)
      (@listeners ||= {})[event] = callback
    end

    private
    def notify(event, *args)
      @listeners[event].call(*args) if @listeners[event].respond_to? :call
    end
  end
end
