require File.dirname(__FILE__) + '/buffer'

module Console
  class VisualBuffer < Buffer

    def initialize(size, width, lines)
      super(size)

      @lines = lines

      config = Configuration.instance

      Rubygame::TTF.setup()
      @renderer = Rubygame::TTF.new(config.font_root + 'default.ttf', 25)

      @background = Rubygame::Surface.new([width, size_used * @lines])
    end

    def draw

      bg_height = size_used * @renderer.height
      @background = Rubygame::Surface.new([@background.width, bg_height])
      @background.fill([255,255,255])

      top = bg_height - @renderer.height
      @buffer.reverse[0..(@lines -1)].each do |line|

        current_line = @renderer.render(line, true, [0,0,0])
        current_line.blit(@background, [0, top])

        top -= @renderer.height
      end

      @background
    end
  end
end
