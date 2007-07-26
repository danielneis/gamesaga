require File.dirname(__FILE__) + '/../lib/automata'
require File.dirname(__FILE__) + '/../lib/eventdispatcher'

module Models
  class Model

    include Automata
    include EventDispatcher
    include Rubygame::Sprites::Sprite

    def initialize
      super()
      setup_listeners()
    end

    def ground
      (@rect.top)..(@rect.bottom)
    end
  end
end
