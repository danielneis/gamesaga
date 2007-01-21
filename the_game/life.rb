class Life_display < Rubygame::SFont

    attr_reader :text
    def initialize(life)
	@sfont = Rubygame::SFont.new(PIX_ROOT+'term16.png')
	@text = @sfont.render('Life: '+life)
    end

    def text=(life)
	@text = @sfont.render('Life: '+life)
    end

end

