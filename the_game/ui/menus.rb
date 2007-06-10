module Menus

  class Menu

    include EventDispatcher

    def initialize
      @screen = Rubygame::Screen.get_surface
      @screen.show_cursor = true

      @clock = Rubygame::Clock.new
      @queue = Rubygame::EventQueue.new
      
      setup_listeners()

      yield self if block_given?

      @background.blit(@screen, [0,0]) unless @background.nil?
      @hud.draw(@screen)
      @screen.update()
    end

    def run
      loop do
        update
      end
    end

    def update
      @clock.tick()
      @hud.draw(@screen)
      @screen.update()
    end
  end

  class Main < Menu

    def initialize

      @menu.each do |button|
        button.on :start_game do 
          notify :start_game
        end
        button.on :quit_game do
          throw :exit
        end
      end

      super()

    end

    def update

      super()

      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
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
  end

  class Pause < Menu

    def initialize

      @title = Display.new('[PAUSED]', [240,10], '', 25)
      @title.update()

      @menu.each do |button|
        button.on :quit_game do
          throw :exit
        end
        button.on :main_menu do
          notify :main_menu
        end
      end

      super()
    end

    def update

      @title.update()

      @queue.each do |event|
        case event
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          when Rubygame::K_RETURN then throw :continue
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
  end
end
