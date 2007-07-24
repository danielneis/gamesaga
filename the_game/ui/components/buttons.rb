require File.dirname(__FILE__)+'/component'

module Components
module Buttons

  class ConstructionError < StandardError; end

  class Button < Component

    def initialize

      super()
      @background = nil

      yield self if block_given?

      raise ConstructionError, "You must use text= and/or bg_image= methods on initialization block" if @background.nil?

      @rect = @background.make_rect
    end

    def draw(destination)
      @background.blit(@screen, @rect.topleft)
    end

    def text=(text)

        config = Configuration.instance

        raise ArgumentError, "Text must be an Hash" unless text.is_a? Hash

        Rubygame::TTF.setup()
        renderer = Rubygame::TTF.new(config.font_root + text[:font] +'.ttf', text[:size])
        @output = renderer.render(text[:text], true, text[:fg_color], text[:bg_color])

        @background = Rubygame::Surface.new([@output.w, @output.h])

        @output.blit(@background, [0,0])
    end

    def bg_image=(image_name, bg_color = [123,123,123])

      config = Configuration.instance

      @image = Rubygame::Surface.load_image(config.pix_root + 'buttons/' + image_name + '.png')
      @image.set_colorkey(@image.get_at([0,0]))
      @image = @image.zoom_to(config.screen_width / 8, config.screen_width / 8)

      @background = Rubygame::Surface.new([@image.w, @image.h])
      @background.fill bg_color
      @background.set_colorkey(@background.get_at([0,0]))

      @image.blit(@background, [0,0])
    end
  end

  class Quit < Button

    def initialize
      super { |b| b.bg_image = 'sair' }
    end

    def click(position)
      notify :quit_game
    end
  end

  class NewGame < Button

    def initialize
      super { |b| b.bg_image = 'jogar' }
    end

    def click(position)
      notify :start_game
    end
  end

  class Instructions < Button

    def initialize
      super { |b| b.bg_image = 'instrucoes' }
    end

    def click(position)
      notify :show_instructions
    end
  end

  class MainMenu < Button

    def initialize
      super { |b| b.text = {:text => 'Main Menu', :font => 'default',
                            :size => 20, :fg_color => [255,255,255],
                            :bg_color => [0,0,0]} }
   end

    def click(position)
      notify :main_menu
    end
  end

  class Options < Button

    def initialize
      super { |b| b.text = {:text => 'Options', :font => 'default',
                            :size => 20, :fg_color => [255,255,255],
                            :bg_color => [0,0,0]} }
    end

    def click(position)
      notify :options
    end
  end

  class Save < Button
    def initialize
      super { |b| b.text = {:text => 'Save', :font => 'default',
                            :size => 20, :fg_color => [255,255,255],
                            :bg_color => [0,0,0]} }
    end

    def click(position)
      notify :save
    end
  end
end
end
