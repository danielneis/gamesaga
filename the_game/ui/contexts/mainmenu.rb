module Contexts

  class Main < Context

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
end
