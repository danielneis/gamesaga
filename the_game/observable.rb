module Observable
  def initialize
    @listeners = []
  end

  def register_listener(listener)
    @listeners << listener
  end

  def unregister_listener(listener)
    @listeners.remove(listener)
  end

  protected
  def notify_listeners(event)
    @listeners.each {|l| l.send(event, self) }
  end
end
