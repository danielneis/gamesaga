require File.dirname(__FILE__)+'/context'

module Contexts

  class ControllerConfig < Context

    def initialize(performer)

      super(performer)

      config = Configuration.instance

      @labels_menu = UI::Menu.new(:vertical, 15)
      @labels_menu.push(Components::Label.new('Para cima'),
                        Components::Label.new('Para baixo'),
                        Components::Label.new('Esquerda'),
                        Components::Label.new('Direita'),
                        Components::Label.new('Ataque'),
                        Components::Label.new('Pulo'))

      @labels_hud = UI::Hud.new(@labels_menu, :middle, :left)

      @values_menu = UI::Menu.new(:vertical, 15)
      @values_menu.push(Components::SensibleDisplay.new('up', "UP"))

      @values_hud = UI::Hud.new(@values_menu, :middle, :right)

      @title = Display.new('[Controller Configuration]', [240,10], '', 25)

      @background = Rubygame::Surface.load_image(config.pix_root + 'menu_background.jpg').zoom_to(config.screen_width, config.screen_height, true)
    end

    def update

      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          end
        when Rubygame::MouseDownEvent
          if event.string == 'left'
              @values_hud.click(event.pos)
          end
        end
      end

      @background.blit(@screen, [0,0])
      @title.update
    end
  end
end
