require File.dirname(__FILE__)+'/component'
module Components
  class SelectList < Component

    def initialize(id, options, selected = 0, width = 50)

      config = Configuration.instance

      @id = id
      @options = options
      @selected = selected

      Rubygame::TTF.setup()
      @renderer = Rubygame::TTF.new(config.font_root + 'default.ttf', 25)

      @background = Rubygame::Surface.new([width, @renderer.height])
      @background.fill([255,255,255])

      @output = @renderer.render(@options[@selected], true, [0,0,0])

      @rect = @background.make_rect

      @up = Rubygame::Surface.new([10, 10])
      @up.fill([128,128,128])
      @up.draw_polygon_s([[0,10],
                          [10,10],
                          [5,0],
                          [0,10]], [0,0,0])
      @up_rect = @up.make_rect

      @down = Rubygame::Surface.new([10, 10])
      @down.fill([128,128,128])
      @down.draw_polygon_s([[0,0],
                            [10,0],
                            [5,10],
                            [0,0]], [0,0,0])
      @down_rect = @up.make_rect

      super()
    end

    def draw(destination)
      @output.blit(@background, [0,0])
      @up.blit(@background, [@rect.w - @up_rect.w, 0])
      @down.blit(@background, [@rect.w - @down_rect.w, @rect.h - @down_rect.h])
      @background.blit(@screen, @rect.topleft)
    end

    def move!(*pos)
      @rect.move!(*pos)
      @up_rect.move!(@rect.r - @up_rect.l - @up_rect.w, pos[1])
      @down_rect.move!(@rect.r - @down_rect.l - @up_rect.w, @rect.b - @down_rect.b)
    end

    def click(position)

      if @up_rect.collide_point?(*position)
        @selected -= 1 unless @selected == 0
        update_output
      elsif @down_rect.collide_point?(*position)
        @selected += 1 unless @selected == @options.size
        update_output
      end
    end

    def update_output
        @background.fill([255,255,255])
        @output = @renderer.render(@options[@selected], true, [0,0,0])
    end

    def value
      @options[@selected]
    end
  end
end
