module Components
  class RadioGroup < Component
    include EventDispatcher

    def initialize
      super()
      @checked = nil
    end

    def add(button)
      button.on :clicked do |radio|
        if radio != @checked
          @checked.uncheck unless @checked.nil?
          @checked = radio
        end
      end
    end
  end
end
