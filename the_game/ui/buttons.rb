module UI
module Buttons

  class Button

    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_accessor :rect

    def initialize(label = {}, bg_image = '')

      raise "Missing text and background image" if label.empty? and bg_image.empty?

      setup_listeners()

      if (label.is_a? Hash)

        Rubygame::TTF.setup()
        renderer = Rubygame::TTF.new(FONT_ROOT + label[:font] +'.ttf', label[:size])
        @image = renderer.render(label[:text], true, label[:fg_color], label[:bg_color])
        @rect = @image.make_rect
      end

      if (!bg_image.empty?)

        puts 'wuala'
        @text = image unless @image.nil?
        @image = Rubygame::Surface.load_image(PIX_ROOT+bg_image+'.png')
        @rect = @image.make_rect
        @text.blit(@image, [0,0])
      end

      super()
    end
  end

  class Quit < Button

    def initialize
      super({:text =>'Quit',
             :font => 'default',
             :size => 20,
             :fg_color => [255,255,255],
             :bg_color => [0,0,0]})
    end

    def click
      notify :quit_game
    end
  end

  class NewGame < Button

    def initialize
      super({:text => 'New Game',
             :font => 'default',
             :font => 'default',
             :size => 20,
             :fg_color => [255,255,255],
             :bg_color => [0,0,0]})
    end

    def click
      notify :start_game
    end
  end

  class MainMenu < Button

    def initialize
      super({:text => 'Main Menu',
             :font => 'default',
             :size => 20,
             :fg_color => [255,255,255],
             :bg_color => [0,0,0]})
    end

    def click
      notify :main_menu
    end
  end

  class Options < Button

    def initialize
      super({:text => 'Options',
             :font => 'default',
             :size => 20,
             :fg_color => [255,255,255],
             :bg_color => [0,0,0]})
    end

    def click
      notify :options
    end
  end
end
end
