require File.dirname(__FILE__)+'/component'
require File.dirname(__FILE__)+'/inputtext'
module Components

  class SensibleDisplay < InputText

    attr_reader :text

    def initialize(id, text)
      super(1, id, text)
    end

    def handle_input(input)

      unless input.string.equal? @text
        @text = input.string
        @output = @renderer.render(@text, true, [0,0,0])
        update_background
      end
    end
  end
end
