module Contexts

  class Options < Context

    def initialize

      2.times {$:.unshift File.join(File.dirname(__FILE__), "..")}
      config = YAML::load_file('config.yaml')

      @background = Rubygame::Surface.load_image(config['pix_root']+'menu_background.jpg')

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(Components::Buttons::MainMenu.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @inputs_menu = UI::Menu.new(:vertical, 15)
      @inputs_menu.push(Components::InputText.new(10))
      @inputs_hud = UI::Hud.new(@inputs_menu, :center)

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

      @inputs_hud.draw(@screen)
      @screen.update
    end

    def update

      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          @inputs_hud.handle_input(event)
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          end
        when Rubygame::MouseDownEvent
          if event.string == 'left'
              @hud.click(event.pos)
              @inputs_hud.click(event.pos)
          end
        end
      end

      @title.update()
      @inputs_hud.redraw(@screen)
      @screen.update()
    end
  end
end
