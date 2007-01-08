class Fps_display < Rubygame::SFont

    attr_reader :text
    def initialize(fps)
	@sfont = Rubygame::SFont.new(PIX_ROOT+'term16.png')
	@text = @sfont.render('FPS: '+fps)
    end

    def text=(fps)
	@text = @sfont.render('FPS: '+fps)
    end

end
