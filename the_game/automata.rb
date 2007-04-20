module Automata
  def in_state?(state)
    @state_machine.current_state.is_a? state
  end

  def change_state(new_state)
    @state_machine.change_state(new_state)
  end

  def back_to_last_state()
    @state_machine.back_to_last_state
  end
end
