module Automata
  def in_state?(state)
    @state_machine.in_state? state
  end

  def change_state(new_state)
    @state_machine.change_state(new_state)
  end

  def back_to_last_state
    @state_machine.back_to_last_state
  end

  def set_next_state(state)
    @state_machine.next_state = state;
  end

  def has_next_state?
    @state_machine.has_next_state?
  end

  def next_state
    @state_machine.next_state
  end

  def go_to_next_state
    @state_machine.go_to_next_state 
  end
end
