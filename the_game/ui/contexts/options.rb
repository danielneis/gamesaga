module Contexts

  class Options < Context

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
