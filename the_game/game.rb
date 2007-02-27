#!/usr/bin/env ruby
require 'rubygame'
require 'config'
require 'ui/hud'
require 'ui/menu'
require 'ui/buttons'
require 'display'
require 'fsm'
require 'states'
require 'character'
require 'player'
require 'enemy'
require 'items'

# Initialize rubygame, set up screen and start the event queue
Rubygame.init()
screen = Rubygame::Screen.set_mode(SCREEN_SIZE)
screen.set_caption(TITLE)

@state_machine = FiniteStateMachine.new(self, States::Game::MainMenu)

catch(:end_game) do
  loop do
    @state_machine.update()
  end
end
