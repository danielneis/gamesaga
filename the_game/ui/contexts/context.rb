require File.dirname(__FILE__)+'/../hud'
require File.dirname(__FILE__)+'/../menu'
require File.dirname(__FILE__)+'/../display'
require File.dirname(__FILE__)+'/../components/inputtext'
require File.dirname(__FILE__)+'/../components/buttons'
require File.dirname(__FILE__)+'/../components/radiobutton'
require File.dirname(__FILE__)+'/../components/radiogroup'
require File.dirname(__FILE__)+'/../components/checkbox'
require File.dirname(__FILE__)+'/../components/label'
require File.dirname(__FILE__)+'/../components/selectlist'
require File.dirname(__FILE__)+'/../components/sensible.display'

module Contexts

  class Context

    include EventDispatcher

    def initialize

      @screen = Rubygame::Screen.get_surface
      @screen.show_cursor = true

      @clock = Rubygame::Clock.new
      @queue = Rubygame::EventQueue.new
      
      setup_listeners()
    end

    def run
      loop do
        update
      end
    end

    def update
    end
  end
end
