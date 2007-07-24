require File.dirname(__FILE__)+'/context'

module Contexts

  class Main < Context

    def initialize

      super()

      @clock = Rubygame::Clock.new { |clock| clock.target_framerate = 35 }

      yield self if block_given?

      config = Configuration.instance

      @menu = UI::Menu.new(:horizontal, 30)
      @menu.push(Components::Buttons::NewGame.new(),
                 Components::Buttons::Options.new(),
                 Components::Buttons::Instructions.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @menu.each do |button|
        button.on :start_game do 
          notify :start_game
        end
        button.on :quit_game do
          throw :exit
        end
        button.on :options do
          notify :options
        end
      end

      @previous_animation = @clock.tick()
      @anim_diff = @previous_animation - @clock.tick
      @anim_times_done = 0
      @anim_times = 10

      @background = Rubygame::Surface.new([config.screen_width, config.screen_height])
      @background.fill([0,0,0])

      pix_dir = config.pix_root + 'main.menu/'

      @bg_img1 = Rubygame::Surface.load_image(pix_dir + 'fundoPrincipal1.png')
      @bg_img1.set_colorkey(@bg_img1.get_at([0,0]))
      @bg_img1 = @bg_img1.zoom_to(config.screen_width, config.screen_height, true)

      @bg_img2 = Rubygame::Surface.load_image(pix_dir + 'fundoPrincipal2.png')
      @bg_img2.set_colorkey(@bg_img2.get_at([0,0]))
      @bg_img2 = @bg_img2.zoom_to(config.screen_width, config.screen_height, true)

      face = Rubygame::Surface.load_image(pix_dir + 'rosto1.png')
      face.set_colorkey(face.get_at([0,0]))
      face = face.zoom_to(config.screen_width / 4, config.screen_height / 4, true)
      face.blit(@bg_img2, [(config.screen_width - face.w - 10)/2, 280])

      left_ray = Rubygame::Surface.load_image(pix_dir + 'raioesquerdo.png')
      left_ray.set_colorkey(left_ray.get_at([0,0]))
      left_ray = left_ray.zoom_to(150,150)
      left_ray.blit(@bg_img2, [700, 150])

      right_ray = Rubygame::Surface.load_image(pix_dir + 'raiodireito.png')
      right_ray.set_colorkey(right_ray.get_at([0,0]))
      right_ray = left_ray.zoom_to(150,150)
      right_ray.blit(@bg_img2, [150, 150])
    end

    def update

      @anim_diff = @previous_animation - @clock.tick
      if (@anim_diff < 15) && (@anim_times_done < @anim_times)
        @anim_times_done += 1
        @bg_img1.blit(@background, [0,0])
      else
        @anim_times_done = 0
        @bg_img2.blit(@background, [0,0])
      end
      @previous_animation = @clock.tick

      @queue.each do |event|
        case event
        when Rubygame::QuitEvent then throw :exit
        when Rubygame::KeyDownEvent
          case event.key
          when Rubygame::K_ESCAPE then throw :exit
          when Rubygame::K_RETURN then notify :start_game
          when Rubygame::K_O      then notify :options
          end
        when Rubygame::MouseDownEvent
          @hud.click(event.pos) if event.string == 'left'
        end
      end

      @background.blit(@screen, [0,0])
      @hud.draw(@screen)
      @screen.update()
    end
  end
end
