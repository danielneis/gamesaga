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
                        Components::Label.new('Fullscreen'),
                        Components::Label.new('Blabla'),
                        Components::Label.new('Tralala'))
      @labels_hud = UI::Hud.new(@labels_menu, :center, :left)

      @inputs_menu = UI::Menu.new(:vertical, 15)

      chk1 = (config.screen_width == 800)
      chk2 = (config.screen_width == 640)
      @inputs_menu.push(Components::RadioButton.new(20, 'resolution', '800x600', chk1),
                        Components::RadioButton.new(20, 'resolution', '640x480', chk2),
                        Components::InputText.new(10, 'title', config.title),
                        Components::Checkbox.new(40, 'fullscreen', config.fullscreen),
                        Components::RadioButton.new(20, 'grupo2', 'terceiro'),
                        Components::RadioButton.new(20, 'grupo2', 'quarto'))
      @inputs_hud = UI::Hud.new(@inputs_menu, :center, :right)

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(Components::Buttons::MainMenu.new(),
                 Components::Buttons::Save.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)


      @menu.each do |button|
        button.on :main_menu do
          throw :main_menu
        end
        button.on :quit_game do
          throw :exit
        end
        button.on :save do

          options = @inputs_menu.values

          if options['resolution'] == '800x600'
            config.screen_width = 800
            config.screen_height = 600
          elsif options['resolution'] == '640x480' 
            config.screen_width = 640
            config.screen_height = 480
          end

          config.title = options['title']
          config.fullscreen = options['fullscreen']

          if config.fullscreen
            fullscreen = [Rubygame::FULLSCREEN]
          else
            fullscreen = []
          end

          Rubygame::Screen.set_mode([config.screen_width, config.screen_height], 32, fullscreen)

          @screen.title = config.title

          config.save

          @background.blit(@screen, [0,0])
          @title.update()
          @hud.draw(@screen)

        end
      end

      super()

      @title = Display.new('[OPTIONS]', [240,10], '', 25)
      @title.update()

      @hud.draw(@screen)
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

      @inputs_hud.redraw(@screen)
      @labels_hud.redraw(@screen)
      @screen.update()
    end
  end
end
