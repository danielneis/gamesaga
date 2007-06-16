require File.dirname(__FILE__)+'/component'

module Components
module Buttons

  class Button < Component

    def initialize(label = {}, bg_image = '')

      2.times {$:.unshift File.join(File.dirname(__FILE__), "..")}
      config = YAML::load_file('config.yaml')

      if (label.is_a?(Hash) && !label.empty?)

        Rubygame::TTF.setup()
        renderer = Rubygame::TTF.new(config['font_root'] + label[:font] +'.ttf', label[:size])
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
