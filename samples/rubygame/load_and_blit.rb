#/usr/bin/env ruby

# A very basic sample application.

require 'rubygems'
require_gem "rubygame", '2.0.0'
include Rubygame

Rubygame.init

screen = Screen.set_mode([320,240])

queue = EventQueue.new() { 
  |q| q.ignore = [MouseMotionEvent, ActiveEvent]
}

image = Surface.load_image("panda.png")
puts "Size is: [%s,%s]"%image.size
image.blit(screen,[0,0])

queue.wait() { screen.update() }

Rubygame.quit
