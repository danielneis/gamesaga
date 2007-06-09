module Menus

  class Menu

    include EventDispatcher

    def setup
      @screen = Rubygame::Screen.get_surface
      @screen.show_cursor = true

      @clock = Rubygame::Clock.new
      @queue = Rubygame::EventQueue.new
      
      setup_listeners()
    end
  end

  class Main < Menu

    def initialize

      setup()

      yield self if block_given?

      menu = UI::Menu.new(:horizontal)
      menu.push(UI::Buttons::NewGame.new(), UI::Buttons::Quit.new())
      @hud = UI::Hud.new(menu, :bottom)

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')
      @background.blit(@screen, [0,0])

      @screen.update()

      menu.each do |button|
        button.on :start_game do 
          notify :start_game
        end
        button.on :quit_game do
          throw :exit
        end
      end
    end

    def run
      loop do
        update
      end
    end

    def update

      @clock.tick()
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

      setup()

      yield self if block_given?

      menu = UI::Menu.new(:vertical)
      menu.push(UI::Buttons::MainMenu.new(), UI::Buttons::Quit.new())
      @hud = UI::Hud.new(menu, :center)

      @title = Display.new('[PAUSED]', [240,10], '', 25)
      @title.update()

      @hud.draw(@screen)

      @screen.update()

      menu.each do |button|
        button.on :quit_game do
          throw :exit
        end
        button.on :main_menu do
          notify :main_menu
        end
      end
    end

    def run
      loop do
        update
      end
    end

    def update
      @clock.tick()

      @title.update()
      @hud.draw(@screen)
      @screen.update()

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
