require File.dirname(__FILE__)+'/context'

module Contexts

  class ControllerConfig < Context

    def enter

      @ih = InputsHandler.new do |ih|
        ih.ignore = [Rubygame::MouseMotionEvent]
        ih.key_down = {Rubygame::K_ESCAPE  => lambda do throw :exit end,
                       :any                => lambda do |event| @values_hud.handle_input(event) end}
        ih.mouse_down = {'left' => lambda do |event| @values_hud.click(event.pos); @buttons_hud.click(event.pos) end}
      end

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
      @values_menu.push(Components::SensibleDisplay.new('up', "UP"),
                        Components::SensibleDisplay.new('down', "DOWN"),
                        Components::SensibleDisplay.new('left', "ESUERDA"),
                        Components::SensibleDisplay.new('right', "DIREITA"),
                        Components::SensibleDisplay.new('action', "S"),
                        Components::SensibleDisplay.new('jump', "D"))

      @values_hud = UI::Hud.new(@values_menu, :middle, :right)

      @menu = UI::Menu.new(:horizontal, 20)
      @menu.push(Components::Buttons::MainMenu.new(),
                 Components::Buttons::Save.new(),
                 Components::Buttons::Options.new(),
                 Components::Buttons::Quit.new())
      @buttons_hud = UI::Hud.new(@menu, :bottom)

      @menu.each do |button|
        button.on :main_menu do @performer.back_to_start end
        button.on :options   do @performer.change_to_options end
        button.on :quit_game do throw :exit end
        button.on :save      do save_controllers end
      end

      @title = Display.new('[Controller Configuration]', [240,10], '', 25)

      @background = Rubygame::Surface.load_image(config.pix_root + 'menu_background.jpg').zoom_to(config.screen_width, config.screen_height, true)

      @background.blit(@screen, [0,0])
      @screen.show_cursor = true
    end

    def execute

      @ih.handle

      @background.blit(@screen, [0,0])
      @labels_hud.draw(@screen)
      @values_hud.draw(@screen)
      @buttons_hud.draw(@screen)
      @title.update
      @screen.update()
    end

    private
    def save_controllers
    end
  end
end
