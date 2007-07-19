require File.dirname(__FILE__)+'/context'

module Contexts

  class Options < Context

    def initialize

      super()
      yield self if block_given?

      config = Configuration.instance


      @labels_menu = UI::Menu.new(:vertical, 15)
      @labels_menu.push(Components::Label.new('Resolution'),
                        Components::Label.new('Titulo'),
                        Components::Label.new('Fullscreen'),
                        Components::Label.new('16 bits'),
                        Components::Label.new('32 bits'),
                        Components::Label.new('Default bits'))
      @labels_hud = UI::Hud.new(@labels_menu, :middle, :left)

      @inputs_menu = UI::Menu.new(:vertical, 15)

      if config.screen_width == 640
        resolution_selected = 0
      elsif config.screen_width == 800
        resolution_selected =  1
      elsif config.screen_width == 1024
        resolution_selected =  2
      end

      @inputs_menu.push(Components::SelectList.new('resolution', ['640x480', '800x600', '1024x768'], resolution_selected, 150),
                        Components::InputText.new(10, 'title', config.title),
                        Components::Checkbox.new(30, 'fullscreen', config.fullscreen),
                        Components::RadioButton.new(15, 'color_depth', 16,
                                                   config.color_depth == 16),
                        Components::RadioButton.new(15, 'color_depth', 32,
                                                   config.color_depth == 32),
                        Components::RadioButton.new(15, 'color_depth', 0,
                                                   config.color_depth == 0))

      @inputs_hud = UI::Hud.new(@inputs_menu, :middle, :right)

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(Components::Buttons::MainMenu.new(),
                 Components::Buttons::Save.new(),
                 Components::Buttons::Quit.new())
      @buttons_hud = UI::Hud.new(@menu, :bottom)


      @menu.each do |button|
        button.on :main_menu do
          throw :main_menu
        end
        button.on :quit_game do
          throw :exit
        end
        button.on :save do

          options = @inputs_menu.values

          if options['resolution'] == '1024x768'
            config.screen_width = 1024
            config.screen_height = 768
            @background = @background.zoom_to(1024, 768, true)
          elsif options['resolution'] == '800x600'
            config.screen_width = 800
            config.screen_height = 600
            @background = @background.zoom_to(800, 600, true)
          elsif options['resolution'] == '640x480' 
            config.screen_width = 640
            config.screen_height = 480
            @background = @background.zoom_to(640, 480, true)
          end

          config.title = options['title']
          config.fullscreen = options['fullscreen']
          config.color_depth = options['color_depth']

          if config.fullscreen
            fullscreen = [Rubygame::FULLSCREEN]
          else
            fullscreen = []
          end

          Rubygame::Screen.set_mode([config.screen_width, config.screen_height], config.color_depth, fullscreen)

          @screen.title = config.title

          config.save

          @background.blit(@screen, [0,0])
          @title.update
          @labels_hud.align
          @inputs_hud.align
          @buttons_hud.align
        end
      end

      @title = Display.new('[OPTIONS]', [240,10], '', 25)
      @title.update()

      @background = Rubygame::Surface.load_image(config.pix_root + 'menu_background.jpg').zoom_to(config.screen_width, config.screen_height, true)
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
              @buttons_hud.click(event.pos)
              @inputs_hud.click(event.pos)
          end
        end
      end

      @background.blit(@screen, [0,0])
      @inputs_hud.draw(@screen)
      @labels_hud.draw(@screen)
      @buttons_hud.draw(@screen)
      @screen.update()
    end
  end
end
