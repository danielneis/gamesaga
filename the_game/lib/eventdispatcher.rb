module EventDispatcher

  def setup_listeners
    @event_listeners = {}
  end

  def on(event, &callback)
    (@event_listeners[event] ||= []) << callback
  end

  protected
  def notify(event, *args)
    if @event_listeners[event]
      @event_listeners[event].each do |m|
        m.call(*args) if m.respond_to? :call
      end
    end
  end
end

