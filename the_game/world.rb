class World

  include EventDispatcher

  def initialize

    yield self if block_given?

    @screen = Rubygame::Screen.get_surface
    @clock = Rubygame::Time::Clock.new(35)
    @queue = Rubygame::Queue.instance

    # Create the life bar, FPS display etc.
    @fps_display = Display.new('FPS:', [0,0], @clock.fps.to_s)
    @life_display =  Display.new('Life:', [50,0], @player.life.to_s)

    @kills = 0
    @kills_display =  Display.new('Kills:', [100,0], @kills.to_s)


    setup_listeners()

    @all_sprites = [@items, @enemies, @player].flatten!

    @screen.update()
  end

  def add_player(image)
    @player = Player.new(300, 400, image)

    @player.subscribe :player_death do
      title = Display.new('DIED! press [ESC] to end game', [50, 200], '', 25)
      title.update()

      @screen.update()

      loop do
        @queue.get.each do |event|
          case event
          when Rubygame::QuitEvent then exit
          when Rubygame::KeyDownEvent
            case event.key
            when Rubygame::K_ESCAPE then exit
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

    @enemies.each { |enemy| enemy.subscribe(:enemy_death, &callback) }
  end

  def add_items(*items)
    (@items ||= Rubygame::Sprites::Group.new).push *items

    callback = lambda { |item| @items.delete(item) }

    @items.each { |item| item.subscribe(:item_catched, &callback)}
  end

  def background=(image)
    @background = Rubygame::Image.load(image)
  end

  def update
    @clock.tick()

    @background.blit(@screen, [0, 0])

    @life_display.update(@player.life.to_s)
    @fps_display.update(@clock.fps.to_s)
    @kills_display.update(@kills.to_s)

    @player.update(@enemies, @items)
    @enemies.update()
    @items.update()

    @all_sprites.sort! { |a,b| a.rect.bottom <=> b.rect.bottom }
    @all_sprites.each  { |sprite| sprite.draw(@screen) }

    @screen.update()

    handle_inputs
  end

  private
  def handle_inputs
    @queue.get.each do |event|
      case event
      when Rubygame::QuitEvent then exit
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
