$:.unshift File.join(File.dirname(__FILE__), "..")
require 'hud'
require 'menu'
require 'display'
require 'components/inputtext'
require 'components/buttons'

module Contexts

  class Context

    include EventDispatcher

    def initialize

      @screen = Rubygame::Screen.get_surface
      @screen.show_cursor = true

      @clock = Rubygame::Clock.new
      @queue = Rubygame::EventQueue.new
      
      setup_listeners()

      yield self if block_given?

      @background.blit(@screen, [0,0]) unless @background.nil?
      @hud.draw(@screen)
      @screen.update()
    end

    def run
      loop do
        update
      end
    end

    def update
      @background.blit(@screen, [0,0]) unless @background.nil?
      @clock.tick()
      @hud.draw(@screen)
      @screen.update()
    end
  end
end
