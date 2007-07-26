require 'models/player'
require 'models/enemy'
require 'models/items'
require 'models/tree'

class World

  include EventDispatcher

  def initialize

    @item_types = {:chicken => Models::Chicken, :meat => Models::Meat}

    @dirty_rects = []
    @all_sprites = Rubygame::Sprites::Group.new
    @all_sprites.extend(Rubygame::Sprites::UpdateGroup)

    setup_listeners()

    @screen = Rubygame::Screen.get_surface
    @clock = Rubygame::Clock.new { |clock| clock.target_framerate = 35 }
    @queue = Rubygame::EventQueue.new

    # Create the life bar, FPS display etc.
    @fps_display = Display.new('FPS:', [0,0])
    @life_display =  Display.new('Life:', [250,0])

    @kills = 0

    @kills_display =  Display.new('Kills:', [400,0])

    @enemies = Rubygame::Sprites::Group.new
    @items   = Rubygame::Sprites::Group.new
    @objects = Rubygame::Sprites::Group.new

    yield self if block_given?

    @background.blit(@screen, [0, 0])
    @screen.update
  end

  def add_player(position)

    @player = Models::Player.new(position, 'panda.png')

    @player.on :player_death do
      title = Display.new('DIED! press [ESC] to end game', [50, 200], '', 25)
      title.update()

      @screen.update()

      loop do
        @queue.each do |event|
          case event
          when Rubygame::QuitEvent then throw :exit
          when Rubygame::KeyDownEvent
            case event.key
            when Rubygame::K_ESCAPE then throw :exit
            end
          end
        end
      end
    end

    @all_sprites << @player
  end

  def add_enemies(*positions)

    positions.each do |pos|
      @enemies.push  Models::Enemy.new(pos, 'panda.invert.png')
    end

    callback = lambda do |enemy|
      @dirty_rects.push(enemy.undraw(@screen, @background))
      @all_sprites.delete(enemy)
      @enemies.delete(enemy)
      @kills += 1
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
    @objects.push *objects

    objects.each do |obj|
      @all_sprites << obj
    end
  end

  def background=(image)
    config = Configuration.instance
    @background = Rubygame::Surface.load_image(image)
    @background = @background.zoom_to(config.screen_width, config.screen_height)
    @background.blit(@screen, [0,0])
  end

  def run
    @screen.show_cursor = false
    loop do
      update()
    end
  end

  def update

    @clock.tick()

    @all_sprites.undraw(@screen, @background)

    @life_display.update(@player.life.to_s)
    @fps_display.update(@clock.framerate.to_i.to_s)
    @kills_display.update(@kills.to_s)

    @player.update(@enemies, @items, @objects)
    @enemies.update(@player)

    @all_sprites.sort! { |a,b| a.ground.begin <=> b.ground.begin }
    @dirty_rects += @all_sprites.draw(@screen) + [@life_display.rect, @fps_display.rect, @kills_display.rect]
    @screen.update_rects(@dirty_rects)
    @dirty_rects.clear

    handle_inputs
  end

  private
  def handle_inputs
    @queue.each do |event|
      case event
      when Rubygame::QuitEvent then throw :exit
      when Rubygame::KeyDownEvent
        case event.key
        when Rubygame::K_ESCAPE, Rubygame::K_RETURN then notify :pause
        when Rubygame::K_LEFT   then @player.walk :left
        when Rubygame::K_RIGHT  then @player.walk :right
        when Rubygame::K_UP     then @player.walk :up
        when Rubygame::K_DOWN   then @player.walk :down
        when Rubygame::K_S      then @player.act
        when Rubygame::K_D      then @player.jump
        end
      when Rubygame::KeyUpEvent
        case event.key
        when Rubygame::K_LEFT  then @player.stop_walk :left
        when Rubygame::K_RIGHT then @player.stop_walk :right
        when Rubygame::K_UP    then @player.stop_walk :up
        when Rubygame::K_DOWN  then @player.stop_walk :down
        end
      end
    end
  end

end
