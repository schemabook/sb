module Subscribers
  module Businesses
    module Updated
      class PaymentEmail
        include Subscribers::Subscriber

        EVENT_NAME = Events::Businesses::Updated::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload  = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          user     = User.find(payload.after.actor_id)
          business = user.business

          UserMailer.with(business:).payment_email.deliver_now
        end
      end
    end
  end
end
