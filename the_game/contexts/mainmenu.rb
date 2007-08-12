require File.dirname(__FILE__)+'/context'

module Contexts

  class Main < Context

    def enter

      @ih = InputsHandler.new do |ih|
        ih.ignore = [Rubygame::MouseMotionEvent]
        
        ih.key_down = {Rubygame::K_ESCAPE  => lambda do throw :exit end,
                       Rubygame::K_RETURN  => lambda do @performer.start_game end,
                       Rubygame::K_O       => lambda do @performer.change_to_options end,
                       Rubygame::K_C       => lambda do @performer.change_state Contexts::ControllerConfig end}
          

        ih.mouse_down = {'left' => lambda do |event| @hud.click(event.pos) end}
      end

      @clock = Rubygame::Clock.new { |clock| clock.target_framerate = 35 }

      @menu = UI::Menu.new(:horizontal, 30)
      @menu.push(Components::Buttons::NewGame.new(),
                 Components::Buttons::Options.new(),
                 Components::Buttons::Instructions.new(),
                 Components::Buttons::Quit.new())
      @hud = UI::Hud.new(@menu, :bottom)

      @menu.each do |button|
        button.on :start_game do @performer.start_game end
        button.on :quit_game  do throw :exit end
        button.on :options    do @performer.change_to_options end
      end

      @previous_animation = @clock.tick()
      @anim_diff = @previous_animation - @clock.tick
      @anim_times_done = 0
      @anim_times = 10

      @screen.show_cursor = true

      @background = Rubygame::Surface.new([@config.screen_width, @config.screen_height])
      @background.fill([0,0,0])

      setup_background_images
    end

    def execute

      @ih.handle

      @anim_diff = @previous_animation - @clock.tick
      if (@anim_diff < 15) && (@anim_times_done < @anim_times)
        @anim_times_done += 1
        @bg_img1.blit(@background, [0,0])
      else
        @anim_times_done = 0
        @bg_img2.blit(@background, [0,0])
      end
      @previous_animation = @clock.tick

      @background.blit(@screen, [0,0])
      @hud.draw(@screen)
      @screen.update()
    end

    private
    def setup_background_images

      config = Configuration.instance

      pix_dir = config.pix_root + 'main.menu/'

      @bg_img1 = Rubygame::Surface.load_image(pix_dir + 'fundoPrincipal1.png')
      @bg_img1.set_colorkey(@bg_img1.get_at([0,0]))
      @bg_img1 = @bg_img1.zoom_to(config.screen_width, config.screen_height, true)

      @bg_img2 = Rubygame::Surface.load_image(pix_dir + 'fundoPrincipal2.png')
      @bg_img2.set_colorkey(@bg_img2.get_at([0,0]))
      @bg_img2 = @bg_img2.zoom_to(config.screen_width, config.screen_height, true)

      face = Rubygame::Surface.load_image(pix_dir + 'rosto1.png')
      face.set_colorkey(face.get_at([0,0]))
      face_width = config.screen_width / 4
      face_height = config.screen_height / 4
      face = face.zoom_to(face_width, face_height, true)

      face_x = (config.screen_width - face.w - 10) / 2
      face_y = (config.screen_height - face.h) / 2
      face.blit(@bg_img2, [face_x, face_y])

      left_ray = Rubygame::Surface.load_image(pix_dir + 'raioesquerdo.png')
      left_ray.set_colorkey(left_ray.get_at([0,0]))
      ray_width = config.screen_width / 8
      ray_height = ray_width
      left_ray = left_ray.zoom_to(ray_width, ray_height)

      ray_x = config.screen_width / 7
      ray_y = config.screen_height / 5
      left_ray.blit(@bg_img2, [ray_x, ray_y])

      right_ray = Rubygame::Surface.load_image(pix_dir + 'raiodireito.png')
      right_ray.set_colorkey(right_ray.get_at([0,0]))
      right_ray = left_ray.zoom_to(ray_width, ray_height)

      ray_x = 7 * config.screen_width / 10
      right_ray.blit(@bg_img2, [ray_x, ray_y])
    end
  end
end
