class FiniteStateMachine

  def initialize(owner, current_state = States::State)

    @owner = owner

    @current_state = current_state.new(self)
    @last_state = @current_state

    @current_state.enter(self)
  end

  def in_state?(state)
    @current_state.is_a? state
  end

  def change_state(new_state)

    @last_state = @current_state

    @current_state.exit(@owner)

    @current_state = new_state.new(self)

    @current_state.enter(@owner)
  end

  def back_to_last_state
    change_state(@last_state.class)
  end

  def update
    @current_state.execute(@owner)
  end
end
