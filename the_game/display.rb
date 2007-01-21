class Display < Rubygame::SFont

    attr_reader :text
    def initialize(label, initial_text)
        @label = label
	@sfont = Rubygame::SFont.new(PIX_ROOT+'term16.png')
	@text = @sfont.render(@label + ': ' + initial_text)
    end

    def text=(text)
	@text = @sfont.render(@label + ': ' + text)
    end

end
