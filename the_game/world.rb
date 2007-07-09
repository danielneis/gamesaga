require 'player'
require 'enemy'
require 'items'

class World

  include EventDispatcher

  def initialize

    setup_listeners()

    yield self if block_given?

    @screen = Rubygame::Screen.get_surface
    @clock = Rubygame::Clock.new
    @queue = Rubygame::EventQueue.new

    # Create the life bar, FPS display etc.
    @fps_display = Display.new('FPS:', [0,0])
    @life_display =  Display.new('Life:', [50,0])

    @kills = 0
    @kills_display =  Display.new('Kills:', [100,0])

    @screen.update()
  end

  def add_player(player)

    @player = player

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
  end

  def add_enemy(*enemies)
    (@enemies ||= Rubygame::Sprites::Group.new).push *enemies

    callback = lambda do |enemy|
      @enemies.delete(enemy)
      @kills += 1
    end

    @enemies.each { |enemy| enemy.on(:enemy_death, &callback) }
  end

  def add_items(*items)
    (@items ||= Rubygame::Sprites::Group.new).push *items

    callback = lambda { |item| @items.delete(item) }

    @items.each { |item| item.on(:item_catched, &callback)}
  end

  def background=(image)
    @background = Rubygame::Surface.load_image(image)
    @background = @background.zoom_to(800, 600) if Configuration.instance.screen_width == 800
  end

  def run
    @screen.show_cursor = false
    loop do
      update()
    end
  end

  def update
    @clock.tick()

    @background.blit(@screen, [0, 0])

    @life_display.update(@player.life.to_s)
    @fps_display.update(@clock.framerate.to_i.to_s)
    @kills_display.update(@kills.to_s)

    @player.update(@enemies, @items)
    @enemies.update()
    @items.update()

    all_sprites = [@player, @enemies, @items].flatten!.sort! { |a,b| a.ground <=> b.ground }
    all_sprites.each  { |sprite| sprite.draw(@screen) }

    @screen.update()

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
        when Rubygame::K_S      then @player.attack
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
