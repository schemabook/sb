module Subscribers
  module Subscriber
    extend self

    def subscribe
      raise NameError unless defined?(self.class::EVENT_NAME)

      ActiveSupport::Notifications.subscribe(self.class::EVENT_NAME) { |event| process(event: event) }
    end

    def process
      raise NoMethodError, "Your subscriber needs to define a process method"
    end
  end
end
