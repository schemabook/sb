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
          business = Business.find(payload.after.id)
          user     = User.find(payload.after.actor_id)
          log      = ::ActivityLog.create(business: business)

          Activity.create(
            activity_log: log,
            user: user,
            title: "Created Business",
            detail: "Establed account for #{business.name}"
          )
        end
      end
    end
  end
end
