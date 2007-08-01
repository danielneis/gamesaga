require File.dirname(__FILE__)+'/../../lib/state.rb'
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

  class Context < States::State

    def initialize

      yield self if block_given?

      @queue = Rubygame::EventQueue.new
      @screen = Rubygame::Screen.get_surface
      @config = Configuration.instance
    end
  end
end
