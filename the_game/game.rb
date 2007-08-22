require 'rubygame'
require 'rubygame/sfont'

require 'config/config.rb'
require 'lib/automata'
require 'console/text.console'
require 'contexts/mainmenu'
require 'contexts/options'
require 'contexts/pause'
require 'contexts/controller.config'
require 'contexts/gameover'
require 'contexts/continue'
require 'world'

class ConstructionError < StandardError; end

class Game

  include Automata
  attr_writer :start_context, :pause, :options, :game_over, :continue
  
  def initialize(title = 'game')

    Rubygame.init()

    @start_context = nil
    @world = nil
    @options = nil
    @game_over = Contexts::GameOver
    @continue = Contexts::Continue

    config = Configuration.instance
    config.game_root = File.dirname(File.expand_path(__FILE__))
    config.pix_root =  config.game_root + '/pix/'
    config.font_root = config.game_root + '/fonts/'
    config.save

    options = []
    options.push(Rubygame::FULLSCREEN) if config.fullscreen

    @screen = Rubygame::Screen.new([config.screen_width, config.screen_height], config.color_depth, options)
    @screen.title = title

    yield self if block_given?

    raise ConstructionError, 'You should set start_context' if @start_context.nil?
  end
  
  def start

    @state_machine = FiniteStateMachine.new(self)
    @state_machine.change_state(@start_context)

    begin
      catch :exit do
        loop do
          @state_machine.update
        end
      end
    ensure
      Rubygame::quit
    end
  end

  def back_to_start
    @state_machine.change_state(@start_context)
  end

  def set_world(&callback)
    @world_definition = callback
  end

  def start_game
    raise ConstructionError, 'You should set world to start a game' if @world_definition.nil?
    @world = @world_definition.call

    @world.on :pause do pause_game end
    @world.on :open_console do open_console end

    @world.game = self

    @state_machine.change_state(@world)
  end

  def pause_game
    raise ConstructionError, 'You should set pause to stop the a game' if @pause.nil?
    @state_machine.change_state(@pause)
  end

  def resume_game
    @state_machine.change_state(@world)
  end

  def restart_game
    @world.revive_player
    resume_game
  end

  def open_console
    @console ||= Console::TextConsole.new

    catch :close_console do
      loop do
        @console.update
        @console.draw(@screen)
        @screen.update_rects([@console.rect])
      end
    end
  end

  def change_to_options
    raise ConstructionError, 'You should set options to access it' if @options.nil?
    @state_machine.change_state(@options)
  end

  def request_continue
    @state_machine.change_state(@continue)
  end

  def game_over
    @state_machine.change_state(@game_over)
  end
end
