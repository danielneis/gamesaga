require 'lib/state.rb'
require 'models/player'
require 'models/enemy'
require 'models/items'
require 'models/pieces'

class World < States::State

  include EventDispatcher

  def initialize(&block)

    @item_types = {:chicken => Models::Chicken, :meat => Models::Meat}

    @dirty_rects = []
    @all_sprites = Rubygame::Sprites::Group.new
    @all_sprites.extend(Rubygame::Sprites::UpdateGroup)

    setup_listeners()

    @screen = Rubygame::Screen.get_surface
    @clock = Rubygame::Clock.new { |clock| clock.target_framerate = 35 }

    @ih = InputsHandler.new do |ih|
      ih.ignore = [Rubygame::MouseMotionEvent, Rubygame::MouseDownEvent, Rubygame::MouseUpEvent]

      ih.key_down = {Rubygame::K_ESCAPE => lambda do open_console end,
                     Rubygame::K_RETURN => lambda do notify :pause end,
                     Rubygame::K_LEFT   => lambda do @player.walk :left end,
                     Rubygame::K_RIGHT  => lambda do @player.walk :right end,
                     Rubygame::K_UP     => lambda do @player.walk :up end,
                     Rubygame::K_DOWN   => lambda do @player.walk :down end,
                     Rubygame::K_S      => lambda do @player.act end,
                     Rubygame::K_D      => lambda do @player.jump end}

      ih.key_up = {Rubygame::K_LEFT  => lambda do @player.stop_walk :left end,
                   Rubygame::K_RIGHT => lambda do @player.stop_walk :right end,
                   Rubygame::K_UP    => lambda do @player.stop_walk :up end,
                   Rubygame::K_DOWN  => lambda do @player.stop_walk :down end}
    end

    @enemies = Rubygame::Sprites::Group.new
    @items   = Rubygame::Sprites::Group.new
    @objects = Rubygame::Sprites::Group.new

    @screen.show_cursor = false

    @console_open = false

    instance_eval(&block)
  end

  def enter

    config = Configuration.instance

    @background = @background.zoom_to(config.screen_width, config.screen_height)
    @background.blit(@screen, [0,0])
  end

  def add_player(position, name)

    @player = Models::Player.new(position, name.to_s)

    @player.on :player_death  do notify :player_death, @player end

    @all_sprites << @player
  end

  def revive_player
    @player.revive
  end

  def add_enemies(positions_and_names)

    positions_and_names.each do |pos, name|
      @enemies.push  Models::Enemy.new(pos, name.to_s)
    end

    callback = lambda do |enemy|
      @dirty_rects.push(enemy.undraw(@screen, @background))
      @all_sprites.delete(enemy)
      @enemies.delete(enemy)
    end

    @enemies.each do |enemy| 
      enemy.on(:enemy_death, &callback)
      @all_sprites << enemy
    end
  end

  def add_items(positions_and_types)

    positions_and_types.each do |pos, type|
      @items.push(@item_types[type].new(pos))
    end

    callback = lambda do |item|
      @dirty_rects.push(item.undraw(@screen, @background))
      @all_sprites.delete(item)
      @items.delete(item)
    end

    @items.each do |item|
      item.on(:item_catched, &callback)
      @all_sprites << item
    end
  end

  def add_object(*objects)
    @objects += objects

    objects.each do |obj|
      @all_sprites << obj
    end
  end

  def use_background image
    @background = Rubygame::Surface.load_image(image)
  end

  def execute

    @clock.tick()

    @all_sprites.undraw(@screen, @background)

    unless @console_open
      @ih.handle
      @player.update(@enemies, @items, @objects)
    end

    @enemies.update(@player)

    @all_sprites.sort! { |a,b| a.ground.end <=> b.ground.end }

    @dirty_rects += @all_sprites.draw(@screen)

    @screen.update_rects(@dirty_rects)

    @dirty_rects.clear
  end

  def open_console
    notify :open_console
    @console_open = true
  end

  def close_console
    @console_open = false
  end
end
