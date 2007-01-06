#!/usr/bin ruby -w

require 'rubygame'

# Global constants
SCREEN_WIDTH = 500
SCREEN_HEIGHT = 350
BALL_RADIUS = 5
PADDLE_LENGTH = 40
PADDLE_THIKNESS = 10
MAX_POINTS = 20

# Class definitions
class Environment

    attr_reader :screen, :state, :score

    def initialize(players, ball, rect, screen, digits)
	@players = players
	@ball = ball
	@score = [0, 0]
	@state = :started
	@rect = rect
	@main_screen = screen
	@digits = digits
    end

    def start
	@state = :started
    end

    def stop
	@state = :stopped
    end

    def handle_collisions
	if @players.first.paddle.rect.collide_rect? @ball.rect or @players.last.paddle.rect.collide_rect? @ball.rect then # Collides with first paddle
	    @ball.bounce_off_paddle
	elsif @ball.rect.top < 0 or @ball.rect.bottom > SCREEN_HEIGHT then # Collides with walls
	    @ball.bounce_off_walls
	elsif @ball.rect.right < 0 then
	    @ball.out
	    @score[1] += 1
	    @digits[2].value = (@score[1] / 10).round
	    @digits[3].value = @score[1] >= 10 ? @score[1] - 10 : @score[1]
	    @ball.speed[0] *= 1.1
	    @ball.speed[1] *= 1.1
	elsif @ball.rect.left > SCREEN_WIDTH then
	    @ball.out
	    @score[0] += 1
	    @digits[0].value = (@score[0] / 10).round
	    @digits[1].value = @score[0] >= 10 ? @score[0] - 10 : @score[0]
	    @ball.speed[0] *= 1.05
	    @ball.speed[1] *= 1.05
	end
	if @score[0] >= MAX_POINTS or @score[1] >= MAX_POINTS then 
	    @main_screen.set_caption "#{@players[0].name} wins"
	    sleep(1)
	    self.stop
	end
    end

    def round
	@score[0] + @score[1]
    end
end

class Paddle
    include Rubygame::Sprites::Sprite

    attr_reader :image, :rect

    def initialize(position)
	@image = Rubygame::Surface.new([PADDLE_THIKNESS, PADDLE_LENGTH])
	@rect = @image.make_rect
	@image.fill([255, 255, 255])
	@rect.center = position
	@state = :still
    end

    def update
	case @state
	    when :up
		move_by(-5)
	    when :down
		move_by(5)
	end
    end

    def state=(s)
	if s == :up or s == :down or s == :still then
	    @state = s
	end
    end

    private

    def move_by(pixels)
	if @rect.top+pixels > 0 and @rect.bottom+pixels < SCREEN_HEIGHT then
	    @rect.move!(0, pixels)
	end
    end

end

class Ball
    include Rubygame::Sprites::Sprite

    attr_reader :image, :rect, :speed
    attr_writer :speed

    def initialize(position, speed)
	@image = Rubygame::Surface.new([2*BALL_RADIUS, 2*BALL_RADIUS])
	@rect = @image.make_rect
	@image.fill([255, 255, 255])

	@initial_position = position
	@initial_speed = speed
	@rect.center = position
	@speed = speed
    end

    def update
	@rect.move!(@speed)
    end

    def position
	@rect.center
    end

    def bounce_off_paddle
	@speed[0] = -@speed[0]
    end

    def bounce_off_walls
	@speed[1] = -@speed[1]
    end

    def out
	@rect.center = @initial_position
	@speed = @initial_speed
    end
end

class Player

    attr_reader :paddle, :name

    def initialize(paddle, name)
	@paddle = paddle
	@name = name
    end
end

class Digit
    include Rubygame::Sprites::Sprite

    @@setup_array = [[true, true, true, true, true, true, false],       # 0
    [false, true, true, false, false, false, false],   # 1
    [true, true, false, true, true, false, true],      # 2
    [true, true, true, true, false, false, true],      # 3
    [false, true, true, false, false, true, true],     # 4
    [true, false, true, true, false, true, true],     # 5
    [true, false, true, true, true, true, true],       # 6
    [true, true, true, false, false, false, false],    # 7
    [true, true, true, true, true, true, true],        # 8
    [true, true, true, true, false, true, true],       # 9
    [false, false, false, false, false, false]]        # empty

    @@initialized = false
    @@dimensions = [20, 40]
    @@thickness = 5

    attr_reader :value, :position, :rect, :image

    def initialize(value, position)
	@position = position
	@rect = Rubygame::Rect.new(@position, @@dimensions)
	unless @@initialized
	    construct_corners
	    construct_surfaces
	    @@initialized = true
	end
	self.value = value
    end

    def value=(x)
	if (0..9).include?(x) then
	    @value = x.round
	    @image = @@surfaces[x]
	elsif x == nil then
	    @image = @@surfaces[10]
	end
    end

    private

    def construct_surfaces
	@@surfaces = Array.new
	@@setup_array.each do |ary|
	    @@surfaces.push(current = Rubygame::Surface.new(@@dimensions, 24, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]))
	    ary.each_with_index do |bool, i|
	    Rubygame::Draw.filled_box(current, @@upper_corner[i] ,@@bottom_corner[i] ,[255, 255, 255]) if bool
	    end
	end
    end

    def construct_corners
	@@upper_corner = [[0, 0],
	[@@dimensions[0] - @@thickness, 0],
	[@@dimensions[0] - @@thickness, @@dimensions[1]/2],
	[0, @@dimensions[1]-@@thickness],
	[0, @@dimensions[1]/2],
	[0, 0],
	[0, @@dimensions[1]/2-@@thickness/2]]

	@@bottom_corner =[[@@dimensions[0], @@thickness],
	[@@dimensions[0], @@dimensions[1]/2],
	[@@dimensions[0], @@dimensions[1]],
	[@@dimensions[0], @@dimensions[1]],
	[@@thickness, @@dimensions[1]],
	[@@thickness, @@dimensions[1]/2],
	[@@dimensions[0], @@dimensions[1]/2+@@thickness/2]]
    end
end

# Initialize rubygame and set up screen
    Rubygame.init()
    screen = Rubygame::Screen.set_mode([SCREEN_WIDTH, SCREEN_HEIGHT], 24, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    screen.set_caption("pong")

    paddles = [Paddle.new([0, SCREEN_HEIGHT/2]), Paddle.new([SCREEN_WIDTH-1, SCREEN_HEIGHT/2])]
    players = [Player.new(paddles.first, "Computer"), Player.new(paddles.last, "Human")]
    ball = Ball.new([SCREEN_HEIGHT/2, SCREEN_HEIGHT/2], [5*Math::cos(0.34906585), 5*Math::sin(0.34906585)])
    digits = [Digit.new(0, [SCREEN_WIDTH/2 - 80, 20]), Digit.new(0, [SCREEN_WIDTH/2-40, 20]), Digit.new(0, [SCREEN_WIDTH/2, 20]), Digit.new(0, [SCREEN_WIDTH/2 + 40, 20])]
    env = Environment.new(players, ball, screen.make_rect, screen, digits)
    event_queue = Rubygame::Queue.instance()
    clock = Rubygame::Time::Clock.new(30)

    while env.state == :started do
# Maintains the framerate constant
    clock.tick

# Event handeling
    event_queue.get().each do |event|
	case(event)
	    when Rubygame::QuitEvent
		exit
	    when Rubygame::KeyDownEvent
		case event.key
		    when Rubygame::K_ESCAPE
			exit
		    when Rubygame::K_UP
			paddles.last.state = :up
		    when Rubygame::K_DOWN
			paddles.last.state = :down
		    when Rubygame::K_W
			paddles.first.state = :up
		    when Rubygame::K_S
			paddles.first.state = :down
		    end
		    when Rubygame::KeyUpEvent
			case event.key
			    when Rubygame::K_UP, Rubygame::K_DOWN
				paddles.last.state = :still
			    when Rubygame::K_W, Rubygame::K_S
				paddles.first.state = :still
			end
		end
	end

    screen.fill([0,0,0]) # Refill screen with black
    ball.update
    paddles.each {|p| p.update}
    ball.draw(screen)
    paddles.each {|p| p.draw(screen)}
    digits.each {|d| d.draw(screen)}
    env.handle_collisions
    screen.update()
end #end main loop
