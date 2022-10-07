module Subscribers
  module Businesses
    module Created
      class WelcomeEmail
        include Subscribers::Subscriber

        EVENT_NAME = Events::Businesses::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload  = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          user     = User.find(payload.after.actor_id)

          UserMailer.with(user:).welcome_email.deliver_now
        end
      end
    end
  end
end
