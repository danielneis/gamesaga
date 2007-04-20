class World

  include Automata

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


    @state_machine = FiniteStateMachine.new(self, States::Game::Run)

    @screen.update()
  end

  def add_player(image)
    @player = Player.new(300, 400, image)

    @player.subscribe :player_death do
      change_state(PlayerDeath)
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
    @state_machine.update()

    @background.blit(@screen, [0, 0])

    @life_display.update(@player.life.to_s)
    @fps_display.update(@clock.fps.to_s)
    @kills_display.update(@kills.to_s)

    @player.update(@enemies, @items)
    @enemies.update()
    @items.update()

    @player.draw(@screen)
    @enemies.draw(@screen)
    @items.draw(@screen)

    @screen.update()
  end
 
  def item_catched(item)
  end
end
