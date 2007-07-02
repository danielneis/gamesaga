module Components
  class RadioGroup < Component
    include EventDispatcher

    def initialize(*radio_buttons)

      super()

      @radio_buttons = radio_buttons
      @checked = nil

      callback = lambda do |radio|
        if @checked.respond_to? :uncheck && radio != @checked
          @checked.uncheck 
          @checked = radio
        end
      end

      @radio_buttons.each { |radio| radio.on(:clicked, &callback) }
    end
  end
end
