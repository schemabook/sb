module Subscribers
  module Businesses
    module Created
      class ActivityLog
        include Subscribers::Subscriber

        EVENT_NAME = Events::Businesses::Created::EVENT_NAME

        def initialize
          subscribe
        end

        def process(event:)
          payload  = JSON.parse(event.payload.to_json, object_class: OpenStruct)
          business = Business.where(id: payload.after.id).first

          ::ActivityLog.create(business: business)
        end
      end
    end
  end
end
