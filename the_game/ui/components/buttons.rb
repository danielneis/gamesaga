require File.dirname(__FILE__)+'/component'

module Components
module Buttons

  class Button < Component

    def initialize(label = {}, bg_image = '')

      super()

      config = Configuration.instance

      if (!bg_image.empty?)

        @image = Rubygame::Surface.load_image(PIX_ROOT+bg_image+'.png')
        @background = Rubygame::Surface.new([@image.w, @image.h])
        @image.blit(@background, [0,0])
      end

      if (label.is_a?(Hash) && !label.empty?)


        Rubygame::TTF.setup()
        renderer = Rubygame::TTF.new(config.font_root + label[:font] +'.ttf', label[:size])
        @output = renderer.render(label[:text], true, label[:fg_color], label[:bg_color])

        @background ||= Rubygame::Surface.new([@output.w, @output.h])

        @output.blit(@background, [0,0])
      end

      @rect = @background.make_rect
    end

    def draw(destination)
      @background.blit(@screen, @rect.topleft)
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
