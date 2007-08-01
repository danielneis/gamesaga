require 'rubygame'
require 'rubygame/sfont'

require 'config/config.rb'
require 'lib/automata'
require 'ui/contexts/mainmenu'
require 'ui/contexts/options'
require 'ui/contexts/pause'
require 'ui/contexts/controller.config'
require 'world'

class ConstructionError < StandardError; end

class Game

  include Automata
  attr_writer :start_context, :pause, :options
  
  def initialize

    Rubygame.init()

    @start_context = nil
    @world = nil
    @options = nil

    config = Configuration.instance

    options = []
    options.push(Rubygame::FULLSCREEN) if config.fullscreen

    screen = Rubygame::Screen.new([config.screen_width, config.screen_height], config.color_depth, options)
    screen.title = config.title

    yield self if block_given?

    raise ConstructionError, 'You should set start_context' if @start_context.nil?
  end
  
  def start

    @state_machine = FiniteStateMachine.new(self)
    @state_machine.change_state(@start_context)

    catch :exit do
      loop do
        @state_machine.update
      end
    end

    Rubygame::quit
  end

  def back_to_start
    @state_machine.change_state(@start_context)
  end

  def set_world(&callback)
    @world = callback
  end

  def start_game
    raise ConstructionError, 'You should set world to start a game' if @world.nil?
    @world = @world.call

    @world.on :pause do pause_game end

    @state_machine.change_state(@world)
  end

  def pause_game
    raise ConstructionError, 'You should set pause to stop the a game' if @pause.nil?
    @state_machine.change_state(@pause)
  end

  def change_to_options
    raise ConstructionError, 'You should set options to access it' if @options.nil?
    @state_machine.change_state(@options)
  end
end
