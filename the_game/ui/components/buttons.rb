require File.dirname(__FILE__)+'/component'

module Components
module Buttons

  class Button < Component

    def initialize(label = {}, bg_image = '')

      config = Configuration.instance

      if (label.is_a?(Hash) && !label.empty?)

        Rubygame::TTF.setup()
        renderer = Rubygame::TTF.new(config.font_root + label[:font] +'.ttf', label[:size])
        @image = renderer.render(label[:text], true, label[:fg_color], label[:bg_color])
        @rect = @image.make_rect
      end

      if (!bg_image.empty?)

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

    def click(position)
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

    def click(position)
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

    def click(position)
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

    def click(position)
      notify :options
    end
  end

  class Save < Button
    def initialize
      super({:text => 'Save',
             :font => 'default',
             :size => 20,
             :fg_color => [255,255,255],
             :bg_color => [0,0,0]})
    end

    def click(position)
      notify :save
    end
  end
end
end
