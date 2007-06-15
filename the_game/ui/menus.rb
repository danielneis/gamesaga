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
      @background.blit(@screen, [0,0]) unless @background.nil?
      @clock.tick()
      @hud.draw(@screen)
      @screen.update()
    end
  end

  class Main < Menu

    def initialize

      @menu = UI::Menu.new(:horizontal, 30)
      @menu.push(Components::Buttons::NewGame.new(),
                 Components::Buttons::Options.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')

      @menu.each do |button|
        button.on :start_game do 
          notify :start_game
        end
        button.on :quit_game do
          throw :exit
        end
        button.on :options do
          notify :options
        end
      end

      super()

    end

    def update

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

      super()

      @screen.update()
    end
  end

  class Pause < Menu

    def initialize

      @menu = UI::Menu.new(:vertical, 20)
      @menu.push(Components::Buttons::MainMenu.new(), Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :center)

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

  class Options < Menu

    def initialize

      @background = Rubygame::Surface.load_image(PIX_ROOT+'menu_background.jpg')

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(Components::Buttons::MainMenu.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @input_text = Components::InputText.new(10, [430, 10])

      @title = Display.new('[OPTIONS]', [240,10], '', 25)
      @title.update()

      @menu.each do |button|
        button.on :main_menu do
          throw :main_menu
        end
        button.on :quit_game do
          throw :exit
        end
      end

      super()

      @input_text.draw(@screen)
      @screen.update
    end

    def update

      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          @input_text.handle_input(event)
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          end
        when Rubygame::MouseDownEvent
          if event.string == 'left'
            if @hud.respond_to?('click')
              @hud.click(event.pos)
            end
          @input_text.click(event.pos)
          end
        end
      end

      @input_text.draw(@screen)
      @screen.update()
    end
  end
end
