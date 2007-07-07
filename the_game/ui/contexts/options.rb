require File.dirname(__FILE__)+'/context'

module Contexts

  class Options < Context

    def initialize

      config = Configuration.instance

      @background = Rubygame::Surface.load_image(config.pix_root + 'menu_background.jpg')

      @labels_menu = UI::Menu.new(:vertical, 15)
      @labels_menu.push(Components::Label.new('800x600'),
                        Components::Label.new('640x480'),
                        Components::Label.new('Titulo'),
                        Components::Label.new('Dificil'),
                        Components::Label.new('Blabla'),
                        Components::Label.new('Tralala'))
      @labels_hud = UI::Hud.new(@labels_menu, :center, :left)

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(Components::Buttons::MainMenu.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @inputs_menu = UI::Menu.new(:vertical, 15)
      @inputs_menu.push(Components::RadioButton.new(20, 'grupo1'),
                        Components::RadioButton.new(20, 'grupo1'),
                        Components::InputText.new(10),
                        Components::Checkbox.new(40),
                        Components::RadioButton.new(20, 'grupo2'),
                        Components::RadioButton.new(20, 'grupo2'))
      @inputs_hud = UI::Hud.new(@inputs_menu, :center, :right)

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
      @labels_hud.draw(@screen)
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
      @labels_hud.redraw(@screen)
      @screen.update()
    end
  end
end
