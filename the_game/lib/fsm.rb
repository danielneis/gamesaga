class FiniteStateMachine

  attr_reader :next_state

  def initialize(owner, current_state = States::State, global_state = States::State)

    @owner = owner

    @global_state = global_state.new @owner

    @current_state = current_state.new @owner
    @last_state = @current_state

    @global_state.enter
    @current_state.enter

    @next_state = nil
  end

  def next_state=(state)
    @next_state = state
  end

  def in_state?(state)
    @current_state.is_a? state
  end

  def has_next_state?()
    !@next_state.nil?
  end

  def go_to_next_state()
    change_state(@next_state)
    @next_state = nil
  end

  def change_state(new_state)

    @last_state = @current_state

    @last_state.exit

    if new_state.respond_to? :new
      @current_state = new_state.new @owner
    else
      @current_state = new_state
    end

    @current_state.enter
  end

  def back_to_last_state
    change_state(@last_state.class)
  end

  def update
    @global_state.execute

    @current_state.execute
  end
end
