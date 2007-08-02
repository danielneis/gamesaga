require File.dirname(__FILE__)+'/../lib/state.rb'
require File.dirname(__FILE__)+'/../lib/inputs.handler.rb'
require File.dirname(__FILE__)+'/../ui/hud'
require File.dirname(__FILE__)+'/../ui/menu'
require File.dirname(__FILE__)+'/../ui/display'
require File.dirname(__FILE__)+'/../ui/components/inputtext'
require File.dirname(__FILE__)+'/../ui/components/buttons'
require File.dirname(__FILE__)+'/../ui/components/radiobutton'
require File.dirname(__FILE__)+'/../ui/components/radiogroup'
require File.dirname(__FILE__)+'/../ui/components/checkbox'
require File.dirname(__FILE__)+'/../ui/components/label'
require File.dirname(__FILE__)+'/../ui/components/selectlist'
require File.dirname(__FILE__)+'/../ui/components/sensible.display'

module Contexts

  class Context < States::State

    def initialize

      yield self if block_given?

      @screen = Rubygame::Screen.get_surface
      @config = Configuration.instance
    end

    def exit(performer)
      @screen.show_cursor = false
    end
  end
end
