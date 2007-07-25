require File.dirname(__FILE__) + '/../lib/automata'
require File.dirname(__FILE__) + '/../lib/eventdispatcher'

module Models
  class Model

    include Automata
    include EventDispatcher
    include Rubygame::Sprites::Sprite

    attr_reader :ground

    def initialize
      super()
      setup_listeners()
    end
  end
end
